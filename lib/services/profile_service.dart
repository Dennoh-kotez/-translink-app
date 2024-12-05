import 'package:appwrite/appwrite.dart';
import 'dart:io';
import 'package:translink/services/appwrite_service.dart';

class ProfileService {
  final AppwriteService appwriteService;
  late final Storage storage;
  final String bucketId = 'profile_pictures';

  // Constructor takes an AppwriteService instance
  ProfileService(this.appwriteService) {
    storage = Storage(appwriteService.client);
  }

  // Upload profile picture
  Future<String> uploadProfilePicture(File file, String userId) async {
    try {
      final fileId = ID.unique();
      final result = await storage.createFile(
        bucketId: bucketId,
        fileId: fileId,
        file: InputFile.fromPath(path: file.path),
      );
      // Return URL to access the file
      return storage.getFileView(bucketId: bucketId, fileId: fileId).toString();
    } on AppwriteException catch (e) {
      throw 'Error uploading profile picture: ${e.message}';
    }
  }
}
