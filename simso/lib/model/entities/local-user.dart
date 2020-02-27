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
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return e;
    }
  }

  Future<File> writeLocalUser(String localUser) async {
    final file = await localFile;
    // Write the file
    return file.writeAsString('$localUser');
  }
}