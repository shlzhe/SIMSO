import 'package:simso/model/entities/image-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simso/model/entities/user-model.dart';
import 'ipicture-service.dart';

int imageNum = 0;

class ImageService extends IImageService {
  @override
  Future<String> addImage(ImageModel image) async {
    // save it from firestore instance
    // collection name is Image.IMAGE_COLLECTION
    // add function after serialized data
    // returns document reference type
    DocumentReference ref = await Firestore.instance
        .collection(ImageModel.IMAGE_COLLECTION)
        .add(image.serialize());
    return ref.documentID;
  }

  @override
  Future<List<ImageModel>> getImage(String email) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(ImageModel.IMAGE_COLLECTION)
        .where(ImageModel.CREATEDBY, isEqualTo: email)
        .getDocuments();
    var imagelist = <ImageModel>[];
    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      return imagelist;
    }

    for (DocumentSnapshot doc in querySnapshot.documents) {
      imagelist.add(ImageModel.deserialize(doc.data, doc.documentID));
    }
    return imagelist;
  }

  @override
  Future<List<ImageModel>> getImageList(String email) async {
    try {
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection(ImageModel.IMAGE_COLLECTION)
          .where(ImageModel.CREATEDBY, isEqualTo: email) // access request
          .orderBy(ImageModel.LASTUPDATEDAT)
          .getDocuments();
      var imagelist = <ImageModel>[];
      if (querySnapshot == null || querySnapshot.documents.length == 0) {
        return imagelist;
      }
      for (DocumentSnapshot doc in querySnapshot.documents) {
        imagelist.add(ImageModel.deserialize(doc.data, doc.documentID));
      }
      imageNum = querySnapshot.documents.length;
      return imagelist.reversed.toList();
    } 
    catch (e) {
      print("getImageList(picture-service) error");
      print(e);
    }
  }

  @override
  Future<void> updateImageURL(String imageURL, ImageModel image) async {
    await Firestore.instance
        .collection(ImageModel.IMAGE_COLLECTION)
        .document(image.imageId)
        //.setData(user.serialize()
        .updateData({'imageURL': imageURL}).then((val) {
      print('ImageURL Updated');
    }).catchError((e) {
      print(e);
    }); // serialized for keymap val, if user exist, corresponding user updated
  }

  @override
  Future<void> updateImage(ImageModel image) async {
    await Firestore.instance
        .collection(ImageModel.IMAGE_COLLECTION)
        .document(image.imageId)
        .setData(image
            .serialize()); // serialized for keymap val, if book exist, corresponding book updated
  }

  @override
  Future<List<ImageModel>> contentSnaps(bool friends, UserModel user) async{
    var data = <ImageModel>[];
    var snapshotsList = <ImageModel>[];
    try {
      QuerySnapshot queryMeme = await Firestore.instance
          .collection(ImageModel.IMAGE_COLLECTION)
          .orderBy(ImageModel.LASTUPDATEDAT)
          .getDocuments();
      for (DocumentSnapshot doc in queryMeme.documents) {
        data.add(ImageModel.deserialize(doc.data, doc.documentID));
      }
      data.removeWhere((element) => element.ownerID==user.uid.toString());
      if(!friends){ //new content remove friends content
        try{
          for (var i in user.friends){
            data.removeWhere((element) => element.ownerID==i.toString());
          }
        }catch(error){print(error);}
        return data;
      }
      else{
        try{
          for (var i in user.friends){//friends content remove public content
            var temp = data.where((element) => element.ownerID==i.toString());
            snapshotsList.addAll(temp);
          }
        }catch(error){print(error);}
      }
      return snapshotsList;
    }catch(error){
      return data;
    }
  }
}
