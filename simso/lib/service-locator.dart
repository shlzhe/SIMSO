import 'model/services/iuser-service.dart';
import 'model/services/user-service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

setupServiceLocator() {
  locator.registerLazySingleton<IUserService>(() => UserService());
}