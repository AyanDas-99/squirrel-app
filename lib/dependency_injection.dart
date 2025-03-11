import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squirrel_app/core/auth/data/datasources/auth_data_source.dart';
import 'package:squirrel_app/core/auth/data/datasources/auth_local_data_source.dart';
import 'package:squirrel_app/core/auth/data/repositories/user_repository_impl.dart';
import 'package:squirrel_app/core/auth/domain/repositories/user_repository.dart';
import 'package:squirrel_app/core/auth/domain/usecases/get_local_token.dart';
import 'package:squirrel_app/core/auth/domain/usecases/login.dart';
import 'package:squirrel_app/core/auth/domain/usecases/logout.dart';
import 'package:squirrel_app/core/auth/domain/usecases/signup.dart';
import 'package:squirrel_app/core/auth/domain/usecases/validate_token.dart';
import 'package:squirrel_app/core/auth/presentation/bloc/user_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:squirrel_app/features/items/data/datasources/items_remote_datasource.dart';
import 'package:squirrel_app/features/items/data/respositories/item_repository_impl.dart';
import 'package:squirrel_app/features/items/domain/repositories/items_repositories.dart';
import 'package:squirrel_app/features/items/domain/usecases/add_item.dart';
import 'package:squirrel_app/features/items/domain/usecases/get_all_items.dart';
import 'package:squirrel_app/features/items/domain/usecases/get_item_by_id.dart';
import 'package:squirrel_app/features/items/domain/usecases/refill_item.dart';
import 'package:squirrel_app/features/items/domain/usecases/remove_item.dart';
import 'package:squirrel_app/features/items/presentation/bloc/add_item_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_by_id_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_refill_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/remove_item_bloc.dart';
import 'package:squirrel_app/features/tags/data/datastores/tag_remote_datasource.dart';
import 'package:squirrel_app/features/tags/data/repositories/tag_repository_impl.dart';
import 'package:squirrel_app/features/tags/domain/repositories/tag_repository.dart';
import 'package:squirrel_app/features/tags/domain/usecases/add_tag.dart';
import 'package:squirrel_app/features/tags/domain/usecases/get_all_tags.dart';
import 'package:squirrel_app/features/tags/domain/usecases/get_all_tags_for_item.dart';
import 'package:squirrel_app/features/tags/domain/usecases/remove_tag.dart';
import 'package:squirrel_app/features/tags/presentation/bloc/tags_bloc.dart';
import 'package:squirrel_app/features/tags/presentation/bloc/tags_for_item_bloc.dart';
import 'package:squirrel_app/features/transactions/data/datasources/transactions_remote_datasource.dart';
import 'package:squirrel_app/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:squirrel_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:squirrel_app/features/transactions/domain/usecases/get_all_transactions.dart';
import 'package:squirrel_app/features/transactions/domain/usecases/issue_item.dart';
import 'package:squirrel_app/features/transactions/presentation/bloc/issue_item_bloc.dart';
import 'package:squirrel_app/features/transactions/presentation/bloc/transaction_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory<UserBloc>(
    () => UserBloc(
      signUp: sl(),
      login: sl(),
      getLocalToken: sl(),
      validateToken: sl(),
      logout: sl(),
    ),
  );
  sl.registerFactory<ItemBloc>(() => ItemBloc(getAllItems: sl()));
  sl.registerFactory<TagsBloc>(
    () => TagsBloc(getAllTags: sl(), addTag: sl(), removeTag: sl()),
  );
  sl.registerFactory<TagsForItemBloc>(
    () => TagsForItemBloc(getAllTagsForItem: sl()),
  );
  sl.registerFactory<TransactionBloc>(
    () => TransactionBloc(getAllTransactions: sl()),
  );

  sl.registerFactory<AddItemBloc>(
    () => AddItemBloc(addItem: sl()),
  );
  
  sl.registerFactory<RemoveItemBloc>(
    () => RemoveItemBloc(removeItem: sl()),
  );


  sl.registerFactory<ItemByIdBloc>(
    () => ItemByIdBloc(getItemById: sl()),
  );


  sl.registerFactory<ItemRefillBloc>(
    () => ItemRefillBloc(refillItem: sl()),
  );


  sl.registerFactory<IssueItemBloc>(
    () => IssueItemBloc(issueItem: sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => Signup(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => GetLocalToken(sl()));
  sl.registerLazySingleton(() => ValidateToken(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GetAllItems(sl()));
  sl.registerLazySingleton(() => GetAllTags(repository: sl()));
  sl.registerLazySingleton(() => AddTag(repository: sl()));
  sl.registerLazySingleton(() => RemoveTag(repository: sl()));
  sl.registerLazySingleton(() => GetAllTagsForItem(repository: sl()));
  sl.registerLazySingleton(() => GetAllTransactions(repository: sl()));
  sl.registerLazySingleton(() => AddItem(sl()));
  sl.registerLazySingleton(() => RemoveItem(sl()));
  sl.registerLazySingleton(() => GetItemById(sl()));
  sl.registerLazySingleton(() => RefillItem(itemsRepositories: sl()));
  sl.registerLazySingleton(() => IssueItem(repository: sl()));

  // Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(authDataSource: sl(), authLocalDataSource: sl()),
  );

  sl.registerLazySingleton<ItemsRepositories>(
    () => ItemRepositoryImpl(itemRemoteDatasource: sl()),
  );

  sl.registerLazySingleton<TagRepository>(
    () => TagRepositoryImpl(tagRemoteDatasource: sl()),
  );

  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(transactionRemoteDatasource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<ItemRemoteDatasource>(
    () => ItemRemoteDatasourceImpl(client: sl()),
  );

  sl.registerLazySingleton<TagRemoteDatasource>(
    () => TagRemoteDatasourceImpl(client: sl()),
  );

  sl.registerLazySingleton<TransactionsRemoteDatasource>(
    () => TransactionRemoteDatasourceImpl(client: sl()),
  );

  // External
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
