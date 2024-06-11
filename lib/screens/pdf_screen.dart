import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PdfPreviewPage extends StatelessWidget {
  // final String pdfUrl;

  PdfPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final ref = ;
    // final String url = await ref.getDownloadURL();

    return Scaffold(
        appBar: AppBar(title: Text('PDF Preview')),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    final file = await PdfApi.pickFile();
                    if (file == null) return null;
                    OpenPDF(file, context);
                  },
                  child: Text("File pdf ")),
              ElevatedButton(
                  onPressed: () async {
                    final url = '';
                    final file = await PdfApi.loadNetwork(url);
                    if (file == null) return null;
                    OpenPDF(file, context);
                  },
                  child: Text("Network pdf")),
              ElevatedButton(
                  onPressed: () async {
                    final path = 'asset/sample.pdf';
                    final file = await PdfApi.loadAsset(path);
                    if (file == null) return null;
                    OpenPDF(file!, context);
                  },
                  child: Text("Asset pdf")),
              ElevatedButton(
                  onPressed: () async {
                    final url = 'blogs/Algo Pseudo/Algo_intro.pdf';
                    final file = await PdfApi.loadFirebase(url);
                    if (file == null) return null;
                    OpenPDF(file, context);
                  },
                  child: Text("Firebase pdf")),
            ],
          ),
        ));
  }
}

class PdfApi {
  static Future<File?> loadNetwork(String url) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    final localFilePath = '${dir.path}/${filename}';

    // Check if the file exists locally
    if (await File(localFilePath).exists()) {
      return File(localFilePath);
    } else {
      final response = await http.get(Uri.http(url));
      final bytes = response.bodyBytes;
      return _storeFile(url, bytes);
    }
  }

  static Future<File?> loadAsset(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();
    return _storeFile(path, bytes);
  }

  static Future<File?> loadFirebase(String url) async {
    try {
      final filename = basename(url);
      final dir = await getApplicationDocumentsDirectory();
      final localFilePath = '${dir.path}/${filename}';

      // Check if the file exists locally
      if (await File(localFilePath).exists()) {
        return File(localFilePath);
      }
      final refPdf = FirebaseStorage.instance.ref().child(url);
      final bytes = await refPdf.getData();
      return _storeFile(url, bytes!);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  static Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) return null;
    return File(result.paths.first!);
  }

  static Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${filename}');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}

void OpenPDF(File file, BuildContext context) => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => PDFViewerPage(file: file),
      ),
    );

//  By using rootBundle.load('assets/image.png'), Flutter loads the image into memory so that it can be displayed using an Image.memory widget or used in other ways in your app.

// just displaying a pdf. from different resources that is done through PdfApi class funcitons.

class PDFViewerPage extends StatefulWidget {
  final File file;

  PDFViewerPage({required this.file, super.key});

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  late PDFViewController controller;
  final GlobalKey _scaffoldKey = GlobalKey();
  TextEditingController _controller = TextEditingController();

  int _index = 0;
  int _totalPages = 0;
  bool _fitPage = true;
  bool _horizontal = false;

  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);
    final trimmedName = name.substring(0, name.lastIndexOf('.'));

    return Scaffold(
      appBar: AppBar(
        title: Text(trimmedName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(children: [
        PDFView(
          filePath: widget.file.path,
          autoSpacing: true,
          swipeHorizontal: _horizontal,
          pageFling: _fitPage,
          onRender: (pages) => setState(() {
            _totalPages = pages!;
          }),
          onViewCreated: (controller) => setState(() {
            this.controller = controller;
          }),
          onPageChanged: (page, total) => setState(() {
            _index = page! + 1;
          }),
        ),
        Positioned(
          right: 5,
          top: 5,
          child: Container(
            height: 40,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade700.withOpacity(0.7),
            ),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Container(
                        height: 150,
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 50,
                                  child: Expanded(
                                    child: TextField(
                                      controller: _controller,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      try {
                                        int ind = int.parse(_controller.text);
                                        if (ind <= _totalPages) {
                                          _index = ind;
                                          controller.setPage(_index - 1);
                                        }
                                      } catch (e) {
                                        return null;
                                      }
                                      _controller.clear();
                                    },
                                    child: Text("GoToPage")),
                              ],
                            ),
                            SizedBox(height: 10),
                            Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    'Total pages : ',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    _totalPages.toString(),
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ]),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('close'),
                              style:
                                  ButtonStyle(alignment: Alignment.centerRight),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child:
                  Wrap(crossAxisAlignment: WrapCrossAlignment.end, children: [
                Text(
                  _index.toString(),
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                Text(
                  "/$_totalPages",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}
