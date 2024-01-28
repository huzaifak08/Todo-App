import 'package:todo_app/exports.dart';

final ImagePicker _picker = ImagePicker();

Future<XFile?> cameraCapture() async {
  final XFile? image = await _picker.pickImage(source: ImageSource.camera);
  return image;
}

Future<XFile?> galleryImagePicker() async {
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  return image;
}
