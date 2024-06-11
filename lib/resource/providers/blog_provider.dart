// for checking whether the blog exisit or need to be downloaded

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class BlogInfoNotifier extends StateNotifier<Map<String, Map<String, bool>>> {
  BlogInfoNotifier() : super({});
  final reference = FirebaseStorage.instance.ref().child('blogs');
  Future<Map<String, Map<String, bool>>> init() async {
    print('INSIDE BlogProvider INIT');
    final list = await reference.listAll();
    final Map<String, Map<String, bool>> copyState = {};
    final List<String> listBlogNames = list.prefixes
        .map((e) => e.fullPath.substring(e.fullPath.indexOf('/') + 1))
        .toList();
    for (final blog in listBlogNames) {
      final blogFiles = await reference.child(blog).listAll();
      final blogPdfs = blogFiles.items.map((e) => e.name);
      final Map<String, bool> data = {};
      blogPdfs.forEach((element) {
        data[element] = false;
      });
      copyState[blog] = data;
    }
    // print(copyState);
    print('Copy State completed');
    state = copyState;
    await updateAvailability();
    return copyState;
  }

  Map<String, Map<String, bool>> get getData => state;

  Future<void> updateAvailability() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = dir.listSync();
    List<String> avilableBlogs = [];
    files.forEach((fileDir) {
      if (fileDir is File) {
        avilableBlogs.add(basename(fileDir.path));
      }
    });
    final Map<String, Map<String, bool>> copyState = state;
    copyState.forEach((folderName, folder) {
      final Map<String, bool> temp = copyState[folderName]!;
      folder.forEach((pdfName, available) {
        if (avilableBlogs.contains(pdfName)) temp[pdfName] = true;
      });
    });
    state = copyState;
    print('objects listed files');
  }

  Future<File?> downloadAndStore(String name, String parent) async {
    try {
      final filename = name;
      final dir = await getApplicationDocumentsDirectory();
      final localFilePath = '${dir.path}/${filename}';

      // Check if the file exists locally
      if (await File(localFilePath).exists()) {
        return File(localFilePath);
      }
      final refPdf = FirebaseStorage.instance
          .ref()
          .child('blogs')
          .child(parent)
          .child(name);
      final bytes = await refPdf.getData();
      // storing data
      final file = File('${dir.path}/${filename}');
      await file.writeAsBytes(bytes!, flush: true);
      print('done');
      final copyState = state;
      copyState[parent]![name] = true;
      state = copyState;
      // Future.delayed(Duration(seconds: 1)).then((value) => );
      return file;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}

final blogProvider =
    StateNotifierProvider<BlogInfoNotifier, Map<String, Map<String, bool>>>(
  (ref) => BlogInfoNotifier(),
);
