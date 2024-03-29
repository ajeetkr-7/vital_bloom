import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'core/api/api_service.dart';
import 'core/db/shared_prefs.dart';
import 'screens/auth/bloc/user_bloc.dart';
import 'services/auth_service.dart';
import 'utils/constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final GetIt getit = GetIt.instance;

Future<void> setup() async {
  // core
  final dio = await initDio();
  getit.registerLazySingleton<ApiService>(() => ApiServiceImpl(dio: dio));
  getit.registerLazySingletonAsync<SharedPrefs>(() => SharedPrefs.init());
  await GetIt.instance.isReady<SharedPrefs>();
  // services
  getit.registerLazySingleton<AuthService>(() => AuthService());
  // providers
  // cubits and blocs
  getit.registerFactory(() => UserBloc(authService: getit()));
}

Future<Dio> initDio() async {
  final dio = Dio();
  dio.options.baseUrl = apiBaseURL;
  dio.options.connectTimeout = const Duration(seconds: 5);
  dio.options.receiveTimeout = const Duration(seconds: 5);

  dio.interceptors.add(PrettyDioLogger(
    request: true,
    responseBody: true,
    responseHeader: true,
    requestBody: true,
    requestHeader: true,
    error: true,
  ));

  return dio;
}
