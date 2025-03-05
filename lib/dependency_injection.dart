import 'package:get_it/get_it.dart';
import 'package:squirrel_app/features/auth/data/datasources/auth_data_source.dart';
import 'package:squirrel_app/features/auth/data/repositories/user_repository_impl.dart';
import 'package:squirrel_app/features/auth/domain/repositories/user_repository.dart';
import 'package:squirrel_app/features/auth/domain/usecases/login.dart';
import 'package:squirrel_app/features/auth/domain/usecases/signup.dart';
import 'package:squirrel_app/features/auth/presentation/bloc/user_bloc.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => UserBloc(sl(), sl()));

  sl.registerLazySingleton(() => Signup(sl()));
  sl.registerLazySingleton(() => Login(sl()));

  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(authDataSource: sl()));

  sl.registerLazySingleton<AuthDataSource>(
      () => AuthDataSourceImpl(client: sl()));

  sl.registerLazySingleton<http.Client>(() => http.Client());
}
