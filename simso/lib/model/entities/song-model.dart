class SongModel {
  String songId; // firestore doc id
  String title;
  String artist;
  String genre;
  List<dynamic> featArtist;
  int pubyear;
  String artWork;
  String songURL;
  String review;
  String createdBy;
  DateTime lastUpdatedAt; // created or revised
  List<dynamic> sharedWith;

  SongModel({
    this.title,
    this.artist,
    this.genre,
    this.featArtist,
    this.pubyear,
    this.artWork,
    this.songURL,
    this.review,
    this.createdBy,
    this.lastUpdatedAt,
    this.sharedWith,
  });

  // empty book obj
  SongModel.empty() {
    this.title = '';
    this.artist = '';
    this.genre = '';
    this.featArtist = <dynamic>[];
    this.pubyear = 0000;
    this.artWork = '';
    this.songURL = '';
    this.review = '';
    this.createdBy = '';
    this.sharedWith = <dynamic>[];
  }

  SongModel.clone(SongModel b) {
    this.songId = b.songId;
    this.title = b.title;
    this.artist = b.artist;
    this.genre = b.genre;
    this.featArtist = <dynamic>[]..addAll(b.featArtist);
    this.pubyear = b.pubyear;
    this.review = b.review;
    this.artWork = b.artWork;
    this.songURL = b.songURL;
    this.lastUpdatedAt = b.lastUpdatedAt;
    this.createdBy = b.createdBy;
    // is an array or list in Dart
    // so deep copy of contents not just addr ref
    // create empty list 1st, add all contents from b obj,
    // . operator wif dynamic obj cr8ed adding addAll method
    // begin wif blank list, add all the members of this list
    this.sharedWith = <dynamic>[]..addAll(b.sharedWith);
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      TITLE: title,
      ARTIST: artist,
      GENRE: genre,
      FEATARTIST: featArtist,
      PUBYEAR: pubyear,
      ARTWORK: artWork,
      SONGURL: songURL,
      REVIEW: review,
      CREATEDBY: createdBy,
      // timestamp is allowed as well
      LASTUPDATEDAT: lastUpdatedAt,
      // list is array, acceptable by firestore
      SHAREDWITH: sharedWith,
    };
  }

  static SongModel deserialize(Map<String, dynamic> data, String songsId) {
    var song = SongModel(
      title: data[SongModel.TITLE],
      artist: data[SongModel.ARTIST],
      genre: data[SongModel.GENRE],
      featArtist: data[SongModel.FEATARTIST],
      pubyear: data[SongModel.PUBYEAR],
      artWork: data[SongModel.ARTWORK],
      songURL: data[SongModel.SONGURL],
      review: data[SongModel.REVIEW],
      createdBy: data[SongModel.CREATEDBY],
      sharedWith: data[SongModel.SHAREDWITH],
    );
    if (data[SongModel.LASTUPDATEDAT] != null) {
      // convert timestamp type to DateTime obj
      song.lastUpdatedAt = DateTime.fromMillisecondsSinceEpoch(
          data[SongModel.LASTUPDATEDAT].millisecondsSinceEpoch);
    }
    // passed as param
    song.songId = songsId;
    return song;
  }

  static const SONG_COLLECTION = 'songs';
  static const TITLE = 'title';
  static const ARTIST = 'author';
  static const GENRE = 'genre';
  static const FEATARTIST = 'featArtist';
  static const PUBYEAR = 'pubyear';
  static const ARTWORK = 'artWork';
  static const SONGURL = 'songURL';
  static const REVIEW = 'review';
  static const CREATEDBY = 'createdBy';
  static const LASTUPDATEDAT = 'lastUpdatedAt';
  static const SHAREDWITH = 'sharedWith';
}
