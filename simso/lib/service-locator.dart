import 'model/services/friend-service.dart';
import 'model/services/ifriend-service.dart';
import 'package:simso/model/services/limit-service.dart';
import 'model/services/ilimit-service.dart';
import 'model/services/itimer-service.dart';
import 'model/services/itouch-service.dart';
import 'model/services/iuser-service.dart';
import 'model/services/isong-service.dart';
import 'model/services/ipicture-service.dart';
import 'model/services/timer-service.dart';
import 'model/services/touch-service.dart';
import 'model/services/user-service.dart';
import 'model/services/song-service.dart';
import 'model/services/picture-service.dart';
import 'model/services/thought-service.dart';
import 'model/services/ithought-service.dart';
import 'model/services/meme-service.dart';
import 'model/services/imeme-service.dart';
import 'model/services/dictionary-service.dart';
import 'model/services/idictionary-service.dart';
import 'package:get_it/get_it.dart';

// This is for dependancy injection. Register each new service here
GetIt locator = GetIt.instance;

setupServiceLocator() {
  locator.registerLazySingleton<IUserService>(() => UserService());
  locator.registerLazySingleton<ITimerService>(() => TimerService());
  locator.registerLazySingleton<ITouchService>(() => TouchService());
  locator.registerLazySingleton<ISongService>(() => SongService());
  locator.registerLazySingleton<IImageService>(() => ImageService());
  locator.registerLazySingleton<IThoughtService>(() => ThoughtService());
  locator.registerLazySingleton<IMemeService>(() => MemeService());
  //locator.registerLazySingleton<IMemeService>(() => MemeService());

  locator.registerLazySingleton<IFriendService>(() => FriendService());
  locator.registerLazySingleton<ILimitService>(() => LimitService());
  locator.registerLazySingleton<IDictionaryService>(() => DictionaryService());
}