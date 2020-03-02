import 'package:simso/model/entities/image-model.dart';

abstract class IImageService {
  Future<List<ImageModel>> getImage(String email);
  Future<String> addImage(ImageModel image);
  Future<void> updateImageURL(String imageURL, ImageModel image);
  Future<void> updateImage(ImageModel image);
}