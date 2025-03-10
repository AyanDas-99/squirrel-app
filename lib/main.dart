import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squirrel_app/dependency_injection.dart';
import 'package:squirrel_app/core/auth/presentation/bloc/user_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/add_item_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/remove_item_bloc.dart';
import 'package:squirrel_app/features/tags/presentation/bloc/tags_bloc.dart';
import 'package:squirrel_app/features/tags/presentation/bloc/tags_for_item_bloc.dart';
import 'package:squirrel_app/features/transactions/presentation/bloc/transaction_bloc.dart';
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
