import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/errors/exceptions.dart';
import 'package:squirrel_app/core/metadata.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/features/transactions/data/models/addition_model.dart';
import 'package:squirrel_app/features/transactions/data/models/issue_model.dart';
import 'package:squirrel_app/features/transactions/data/models/removal_model.dart';
import 'package:squirrel_app/features/transactions/domain/entities/transaction.dart';

abstract class TransactionsRemoteDatasource {
  /// Throws [AdditionsException], [RemovalsException] or [IssuesException]
  Future<Transaction> getAllTransactions(Tokenparam<ItemIdAndTransactionFilter> tokenItemAndFilter);
}

class TransactionRemoteDatasourceImpl implements TransactionsRemoteDatasource {
  final http.Client client;

  final host = "http://10.0.2.2:8080";

  Map<String, String> getHeader(AuthToken token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token.token}',
    };
  }

  TransactionRemoteDatasourceImpl({required this.client});
  @override
  Future<Transaction> getAllTransactions(Tokenparam<ItemIdAndTransactionFilter> tokenItemAndFilter) async {
    http.Response additionResult;
    http.Response issuesResult;
    http.Response removalsResult;

    late List<AdditionModel> additions;
    late List<RemovalModel> removals;
    late List<IssueModel> issues;

    late Metadata metadata;

    // Getting additions
    try {
      additionResult = await client.get(
        Uri.parse('$host/additions/${tokenItemAndFilter.param.itemId}?${tokenItemAndFilter.param.transactionFilter.toQuery()}'),
        headers: getHeader(tokenItemAndFilter.token),
      );
    } catch (e) {
      throw AdditionsException(message: e.toString());
    }

    dev.log(additionResult.body);

    if (additionResult.statusCode == 200) {
      additions =
          (json.decode(additionResult.body)['additions']).map<AdditionModel>((
            item,
          ) {
            return AdditionModel.fromJson(item);
          }).toList();

      metadata = Metadata.fromJson(
        json.decode(additionResult.body)['metadata'],
      );
    } else if (additionResult.statusCode == 500) {
      throw AdditionsException(
        message: json.decode(additionResult.body)['error'],
      );
    } else {
      throw AdditionsException(
        message: json.decode(additionResult.body)['error'].toString(),
      );
    }

    // Getting removals
    try {
      removalsResult = await client.get(
        Uri.parse('$host/removals/${tokenItemAndFilter.param.itemId}?${tokenItemAndFilter.param.transactionFilter.toQuery()}'),
        headers: getHeader(tokenItemAndFilter.token),
      );
    } catch (e) {
      throw RemovalsException(message: e.toString());
    }

    dev.log(removalsResult.body);

    if (removalsResult.statusCode == 200) {
      removals =
          (json.decode(removalsResult.body)['removals']).map<RemovalModel>((
            item,
          ) {
            return RemovalModel.fromJson(item);
          }).toList();

      final removalMeta = Metadata.fromJson(
        json.decode(removalsResult.body)['metadata'],
      );
      metadata.totalRecords = max(
        metadata.totalRecords ?? 0,
        removalMeta.totalRecords ?? 0,
      );
      metadata.lastPage = max(
        metadata.lastPage ?? 0,
        removalMeta.lastPage ?? 0,
      );
    } else if (removalsResult.statusCode == 500) {
      throw RemovalsException(
        message: json.decode(removalsResult.body)['error'],
      );
    } else {
      throw RemovalsException(
        message: json.decode(removalsResult.body)['error'].toString(),
      );
    }

    // Getting issues
    try {
      issuesResult = await client.get(
        Uri.parse('$host/issues/${tokenItemAndFilter.param.itemId}?${tokenItemAndFilter.param.transactionFilter.toQuery()}'),
        headers: getHeader(tokenItemAndFilter.token),
      );
    } catch (e) {
      throw IssuesException(message: e.toString());
    }

    dev.log(issuesResult.body);

    if (issuesResult.statusCode == 200) {
      issues =
          (json.decode(issuesResult.body)['issues']).map<IssueModel>((item) {
            return IssueModel.fromJson(item);
          }).toList();

      final issueMeta = Metadata.fromJson(
        json.decode(issuesResult.body)['metadata'],
      );
      metadata.totalRecords = max(
        metadata.totalRecords ?? 0,
        issueMeta.totalRecords ?? 0,
      );
      metadata.lastPage = max(metadata.lastPage ?? 0, issueMeta.lastPage ?? 0);
    } else if (issuesResult.statusCode == 500) {
      throw IssuesException(message: json.decode(issuesResult.body)['error']);
    } else {
      throw IssuesException(
        message: json.decode(issuesResult.body)['error'].toString(),
      );
    }

    final transaction = Transaction(
      additions: additions,
      removals: removals,
      issues: issues,
      metadata: metadata,
    );
    return transaction;
  }
}
