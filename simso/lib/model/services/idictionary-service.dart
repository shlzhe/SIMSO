import 'package:simso/model/entities/thought-model.dart';
import 'package:simso/model/entities/song-model.dart';
import 'package:simso/model/entities/image-model.dart';
import 'package:simso/model/entities/dictionary-word-model.dart';

abstract class IDictionaryService {
  Future<void> updateDictionary(Thought thought, SongModel song, ImageModel image);
  Future<List<DictionaryWord>> getDictionary();
  Future<void> updateDictionaryWord(DictionaryWord word, Thought thought, SongModel song, ImageModel image);
  Future<void> addDictionaryWord(String word, Thought thought, SongModel song, ImageModel image);
  Future<void> deleteDictionaryWord(String docID);
  Future<List<String>> getMyKeywords(String thoughtId, String songId, String imageId);
}
