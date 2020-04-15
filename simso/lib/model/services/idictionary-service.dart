import 'package:simso/model/entities/thought-model.dart';
import 'package:simso/model/entities/song-model.dart';
import 'package:simso/model/entities/image-model.dart';
import 'package:simso/model/entities/dictionary-word-model.dart';

abstract class IDictionaryService {
  Future<void> updateDictionary(Thought thought);
  Future<List<DictionaryWord>> getDictionary();
  Future<void> updateDictionaryWord(DictionaryWord word, Thought thought);
  Future<void> addDictionaryWord(String word, Thought thought);
  Future<void> deleteDictionaryWord(String docID);
  Future<List<String>> getMyKeywords(String thoughtId);
  //Future<List<Thought>> searchDictionaryWord(String word); //add in whatever else I can search for, music?
  Future<bool> wordInDictionary(String searchWord);
  Future<DictionaryWord> getWordDocument(String searchWord);
}
