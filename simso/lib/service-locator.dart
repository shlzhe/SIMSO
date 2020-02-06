import 'model/services/itimer-service.dart';
import 'model/services/iuser-service.dart';
import 'model/services/timer-service.dart';
import 'model/services/user-service.dart';
import 'package:get_it/get_it.dart';

// This is for dependancy injection. Register each new service here
GetIt locator = GetIt.instance;

setupServiceLocator() {
  locator.registerLazySingleton<IUserService>(() => UserService());
  locator.registerLazySingleton<ITimerService>(() => TimerService());
}