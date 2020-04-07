import 'package:simso/model/entities/image-model.dart';
import 'package:simso/model/entities/user-model.dart';

abstract class IImageService {
  Future<List<ImageModel>> getImage(String email);
  Future<List<ImageModel>> getImageList(String email);
  Future<String> addImage(ImageModel image);
  Future<void> updateImageURL(String imageURL, ImageModel image);
  Future<void> updateImage(ImageModel image);

  Future<List<ImageModel>>contentSnaps(bool friends, UserModel user);
}