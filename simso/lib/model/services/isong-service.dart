import 'package:simso/model/entities/song-model.dart';

abstract class ISongService {
  Future<List<SongModel>> getSong(String email);
  Future<String> addSong(SongModel song);
  Future<void> updateSongURL(String songURL, SongModel song);
  Future<void> updateSong(SongModel song);
}
