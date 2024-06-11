import 'dart:io';

import 'package:arc_inventory/resource/providers/blog_provider.dart';
import 'package:arc_inventory/resource/providers/refresh_provider.dart';
import 'package:arc_inventory/screens/pdf_screen.dart';
import 'package:arc_inventory/utilities/colors_gradients.dart';
import 'package:bottom_bar_matu/components/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class BlogElement extends ConsumerStatefulWidget {
  final String parentFolder;
  final String title;
  final bool available;

  BlogElement(
      {super.key,
      required this.title,
      required this.parentFolder,
      required this.available});

  @override
  ConsumerState<BlogElement> createState() => _BlogElementState();
}

class _BlogElementState extends ConsumerState<BlogElement> {
  bool loading = false;
  Future<void> onTaped(WidgetRef ref, BuildContext ctx) async {
    setState(() {
      loading = true;
    });

    print('object');
    File? file = await ref
        .read(blogProvider.notifier)
        .downloadAndStore(widget.title, widget.parentFolder);
    print('object123');
    ref.read(refreshProvider.notifier).refresh();
    if (file == null) return null;
    setState(() {
      loading = false;
    });
    if (widget.available) {
      Navigator.of(ctx)
          .push(MaterialPageRoute(builder: (ctx) => PDFViewerPage(file: file)));
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: MediaQuery.of(context).size.width / 3,
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              gradient: light_theme_gradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              image: DecorationImage(
                  image: AssetImage('asset/pdf_logo.png'), fit: BoxFit.contain),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            height: 40,
            clipBehavior: Clip.hardEdge,
            width: double.infinity,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: light_theme_gradient,
            ),
            alignment: Alignment.center,
            child: Text(
              widget.title,
              maxLines: 2,
              style: TextStyle(color: const Color.fromARGB(232, 255, 255, 255)),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                if (!loading) await onTaped(ref, context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                // height: 40,

                clipBehavior: Clip.hardEdge,
                width: double.infinity,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  color: Colors.black.withOpacity(0.3),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.available ? "Open" : "Download",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    color: const Color.fromARGB(187, 255, 255, 255),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
