import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalUser {
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/user.txt');
  }

  Future<String> readLocalUser() async {
    try {
      final file = await localFile;

      // Read the file
      var contents = await file.readAsString();
      if (contents==null) return null;
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      // print('Error in readLocalUser');
      return null;
    }
  }
  Future<File> writeLocalUser(String value) async {
    final file = await localFile;
    // Write the file
    return file.writeAsString('$value');
  }
  Future<File> get credential async {
    final path = await localPath;
    return File('$path/credential.txt');
  }
  Future<File> writeCredential(String value) async {
    final file = await credential;
    // Write the file
    return file.writeAsString('$value');
  }
  Future<String> readCredential()async{
    var directory = await getApplicationDocumentsDirectory();
    var path = directory.path;
    var contents;
    contents = File('$path/credential.txt').readAsString();
    return contents;
  }
}