class ImageModel {
  String imageId; // firestore doc id
  String title;
  String imageURL;
  String summary;
  String createdBy;
  DateTime lastUpdatedAt; // created or revised
  List<dynamic> sharedWith;

  ImageModel({
    this.title,
    this.imageURL,
    this.summary,
    this.createdBy,
    this.lastUpdatedAt,
    this.sharedWith,
  });

  // empty book obj
  ImageModel.empty() {
    this.title = '';
    this.imageURL = '';
    this.summary = '';
    this.createdBy = '';
    this.sharedWith = <dynamic>[];
  }

  ImageModel.clone(ImageModel b) {
    this.imageId = b.imageId;
    this.title = b.title;
    this.imageURL = b.imageURL;
    this.summary = b.summary;
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
      IMAGEURL: imageURL,
      SUMMARY: summary,
      CREATEDBY: createdBy,
      // timestamp is allowed as well
      LASTUPDATEDAT: lastUpdatedAt,
      // list is array, acceptable by firestore
      SHAREDWITH: sharedWith,
    };
  }

  static ImageModel deserialize(Map<String, dynamic> data, String imagesId) {
    var image = ImageModel(
      title: data[ImageModel.TITLE],
      imageURL: data[ImageModel.IMAGEURL],
      summary: data[ImageModel.SUMMARY],
      createdBy: data[ImageModel.CREATEDBY],
      sharedWith: data[ImageModel.SHAREDWITH],
    );
    if (data[ImageModel.LASTUPDATEDAT] != null) {
      // convert timestamp type to DateTime obj
      image.lastUpdatedAt = DateTime.fromMillisecondsSinceEpoch(
          data[ImageModel.LASTUPDATEDAT].millisecondsSinceEpoch);
    }
    // passed as param
    image.imageId = imagesId;
    return image;
  }

  static const IMAGE_COLLECTION = 'images';
  static const TITLE = 'title';
  static const IMAGEURL = 'imageURL';
  static const SUMMARY = 'summary';
  static const CREATEDBY = 'createdBy';
  static const LASTUPDATEDAT = 'lastUpdatedAt';
  static const SHAREDWITH = 'sharedWith';
}
