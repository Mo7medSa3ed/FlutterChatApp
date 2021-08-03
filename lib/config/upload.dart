
import 'package:cloudinary_sdk/cloudinary_sdk.dart';

class Cloud {
  static final cloudinary =
      Cloudinary('156227526922149', 'ji6J6xcyIVRzqO3AZS2mMwaxt2o', 'de6wqnjl3');

  static upload(file) async {
    final response = await cloudinary.uploadFile(
      filePath: file.path,
      resourceType: CloudinaryResourceType.auto,
      folder: 'chats/records',
    );

    if (response.isSuccessful) {
      return response.secureUrl;
    }
    return null;
  }
}
