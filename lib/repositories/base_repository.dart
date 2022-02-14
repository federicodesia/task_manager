import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/repositories/interceptors/access_token_interceptor.dart';
import 'package:task_manager/services/context_service.dart';
import 'package:task_manager/services/locator_service.dart';

class BaseRepository{

  late BaseOptions baseOptions = BaseOptions(
    baseUrl: "https://yusuf007r.dev/task-manager/",
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );

  late FlutterSecureStorage secureStorage = FlutterSecureStorage();

  late AuthBloc? authBloc = getAuthBloc;
  AuthBloc? get getAuthBloc{
    try{
      final context = locator<ContextService>().context;
      if(context != null) return BlocProvider.of<AuthBloc>(context);
    } catch(_){}
  }

  Future<String?> getRefreshToken() async{
    try{
      if(authBloc != null) return authBloc!.state.credentials.refreshToken;
      return await secureStorage.read(key: "refreshToken");
    } catch(_){}
  }

  Future<String?> getAccessToken() async{
    try{
      if(authBloc != null) return authBloc!.state.credentials.accessToken;
      return await secureStorage.read(key: "accessToken");
    } catch(_){}
  }
  
  late Dio dio = Dio(baseOptions);

  late Dio _dioRefreshToken = Dio(baseOptions);
  Future<Dio> dioRefreshToken() async{
    final _refreshToken = await getRefreshToken() ?? "";
    return _dioRefreshToken..options.headers = {
      "Authorization": "Bearer " + _refreshToken
    };
  }

  late Dio _dioAccessToken = Dio(baseOptions)..interceptors.add(AccessTokenInterceptor(
    getRefreshToken: () => getRefreshToken(),
    onAuthCredentialsChanged: (credentials) {
      try{
        if(authBloc != null) authBloc!.add(AuthCredentialsChanged(credentials: credentials));
        else{
          secureStorage.write(key: "refreshToken", value: credentials.refreshToken);
          secureStorage.write(key: "accessToken", value: credentials.accessToken);
        }
      }
      catch(_){}
    }
  ));
  Future<Dio> dioAccessToken() async{
    final _accessToken = await getAccessToken() ?? "";
    return _dioAccessToken..options.headers = {
      "Authorization": "Bearer " + _accessToken
    };
  }
}