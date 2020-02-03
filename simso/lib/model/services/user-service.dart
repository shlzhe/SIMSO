import '../entities/user-model.dart';
import '../entities/api-constants.dart';
import 'package:http/http.dart';
import 'iuser-service.dart';
import 'dart:convert';

// The implimentation of IUserService.
// Here we make the actual call to the database
class UserService extends IUserService {
  
  // This is the subsection of the API we need to call
  String url = APIConstants.BaseAPIURL + '/users';

  // Implimentation of the getUserDataByID
  @override
  Future<UserModel> getUserDataByID(String id) async {
    Response response = await get('$url/$id');
    var jsonString = response.body;
    Map<String, dynamic> map = jsonDecode(jsonString);
    UserModel user = UserModel.fromJson(map);
    return user;
  }

  // Implimentation of the saveUser
  @override
  Future<String> saveUser(UserModel user) async {
    Response response = await post(url, body: user.toJson());
    if (response.statusCode == 201)
      return response.body;
    else
      return null;
  }
}