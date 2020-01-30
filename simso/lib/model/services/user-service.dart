import '../entities/user-model.dart';
import '../entities/api-constants.dart';
import 'package:http/http.dart';
import 'iuser-service.dart';
import 'dart:convert';

class UserService extends IUserService {
  String url = APIConstants.BaseAPIURL + '/users';


  @override
  Future<UserModel> getUserDataByID(String id) async {
    Response response = await get('$url/$id');
    var jsonString = response.body;
    Map<String, dynamic> map = jsonDecode(jsonString);
    UserModel user = UserModel.fromJson(map);
    return user;
  }

  @override
  Future<String> saveUser(UserModel user) async {
    Response response = await post(url, body: user.toJson());
    if (response.statusCode == 201)
      return response.body;
    else
      return null;
  }
}