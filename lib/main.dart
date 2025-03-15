import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squirrel_app/dependency_injection.dart';
import 'package:squirrel_app/core/auth/presentation/bloc/user_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/add_item_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/add_removal_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_by_id_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_refill_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/remove_item_bloc.dart';
import 'package:squirrel_app/features/tags/presentation/bloc/add_tag_for_item_bloc.dart';
import 'package:squirrel_app/features/tags/presentation/bloc/remove_tag_for_item_bloc.dart';
import 'package:squirrel_app/features/tags/presentation/bloc/tags_bloc.dart';
import 'package:squirrel_app/features/tags/presentation/bloc/tags_for_item_bloc.dart';
import 'package:squirrel_app/features/transactions/presentation/bloc/issue_item_bloc.dart';
import 'package:squirrel_app/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:squirrel_app/features/users/presentation/bloc/all_users_bloc.dart';
import 'package:squirrel_app/features/users/presentation/bloc/update_permission_bloc.dart';
import 'package:squirrel_app/features/users/presentation/bloc/user_permissions_bloc.dart';
import 'package:squirrel_app/screen_controller.dart';
import 'dependency_injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const SquirrelApp());
}

class SquirrelApp extends StatelessWidget {
  const SquirrelApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<UserBloc>()),
        BlocProvider(create: (context) => sl<ItemBloc>()),
        BlocProvider(create: (context) => sl<RemoveItemBloc>()),
        BlocProvider(create: (context) => sl<AddItemBloc>()),
        BlocProvider(create: (context) => sl<TagsBloc>()),
        BlocProvider(create: (context) => sl<TagsForItemBloc>()),
        BlocProvider(create: (context) => sl<TransactionBloc>()),
        BlocProvider(create: (context) => sl<ItemByIdBloc>()),
        BlocProvider(create: (context) => sl<ItemRefillBloc>()),
        BlocProvider(create: (context) => sl<IssueItemBloc>()),
        BlocProvider(create: (context) => sl<AllUsersBloc>()),
        BlocProvider(create: (context) => sl<UpdatePermissionBloc>()),
        BlocProvider(create: (context) => sl<UserPermissionsBloc>()),
        BlocProvider(create: (context) => sl<AddTagForItemBloc>()),
        BlocProvider(create: (context) => sl<AddRemovalBloc>()),
        BlocProvider(create: (context) => sl<RemoveTagForItemBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Squirrel',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          scaffoldBackgroundColor: Colors.white,
          cardTheme: CardTheme(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
          ),
        ),
        home: ScreenController(),
      ),
    );
  }
}
