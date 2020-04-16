import 'package:simso/model/entities/song-model.dart';
import 'package:simso/model/entities/user-model.dart';

abstract class ISongService {
  Future<List<SongModel>> getSong(String email);
  Future<String> addSong(SongModel song);
  Future<void> updateSongURL(String songURL, SongModel song);
  Future<void> updateSong(SongModel song);
  Future<List<SongModel>> getSongList(String email);
  Future<List<SongModel>> getAllSongList();
  Future<List<SongModel>> contentSongList(bool friends, UserModel user);
}
