class DictionaryWord {
  String wordDocID; //firestore doc id
  String word; //word
  num useCount; //useCount
  bool isKeyword; //isKeyword
  List<dynamic> related; //related
  List<dynamic> usage; //usage
  List<dynamic> thoughtList; //usage
  List<dynamic> memeList; //usage
  List<dynamic> songList; //usage
  List<dynamic> imageList; //usage

  DictionaryWord({
    this.word, //uword
    this.useCount,
    this.isKeyword,
    this.related,
    this.usage,
    this.thoughtList,
    this.memeList,
    this.songList,
    this.imageList,
  });

  DictionaryWord.empty() {
    this.word = '';
    this.useCount = 0;
    this.isKeyword = true;
    this.related = <dynamic>[];
    this.usage = <dynamic>[];
    this.thoughtList = <dynamic>[];
    this.memeList = <dynamic>[];
    this.songList = <dynamic>[];
    this.imageList = <dynamic>[];
  }

  DictionaryWord.clone(DictionaryWord w) {
    this.wordDocID = w.wordDocID;
    this.word = w.word;
    this.useCount = w.useCount;
    this.isKeyword = w.isKeyword;
    //.. iterates to create deep copy
    this.related = <dynamic>[]..addAll(w.related);
    this.usage = <dynamic>[]..addAll(w.usage);
    this.thoughtList = <dynamic>[]..addAll(w.usage);
    this.memeList = <dynamic>[]..addAll(w.usage);
    this.songList = <dynamic>[]..addAll(w.usage);
    this.imageList = <dynamic>[]..addAll(w.usage);
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      WORD: word,
      USECOUNT: useCount,
      ISKEYWORD: isKeyword,
      RELATED: related,
      USAGE: usage,
      THOUGHTLIST: thoughtList,
      MEMELIST: memeList,
      SONGLIST: songList,
      IMAGELIST: imageList,
    };
  }

  static DictionaryWord deserialize(Map<String, dynamic> data, String docID) {
    var dictionaryWord = DictionaryWord(
      word: data[DictionaryWord.WORD],
      useCount: data[DictionaryWord.USECOUNT],
      related: data[DictionaryWord.RELATED],
      usage: data[DictionaryWord.USAGE],
      thoughtList: data[DictionaryWord.THOUGHTLIST],
      memeList: data[DictionaryWord.MEMELIST],
      songList: data[DictionaryWord.SONGLIST],
      imageList: data[DictionaryWord.IMAGELIST],
    );
    dictionaryWord.wordDocID = docID;
    
    return dictionaryWord;
  }

  static const DICTIONARY_COLLECTION = 'dictionary';
  static const WORD = 'word';
  static const USECOUNT = 'useCount';
  static const ISKEYWORD = 'isKeyword';
  static const RELATED = 'related';
  static const USAGE = 'usage';
  static const THOUGHTLIST = 'thoughtList';
  static const MEMELIST = 'memeList';
  static const SONGLIST = 'songList';
  static const IMAGELIST = 'imageList';
}
