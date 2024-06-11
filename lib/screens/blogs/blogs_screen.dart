import 'package:arc_inventory/resource/providers/blog_provider.dart';
import 'package:arc_inventory/screens/blogs/blog_section_screen.dart';
import 'package:arc_inventory/utilities/circularprogress_indicator.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlogsScreen extends ConsumerWidget {
  BlogsScreen({super.key});
  late List<String> firestorepaths;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
        future: ref.read(blogProvider.notifier).init(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return ProgressGIF();
          }
          if (snap.hasData) {
            // print(snap.data!);

            return MainBlogGird();
          }
          return Container();
        });
  }
}

class MainBlogGird extends ConsumerWidget {
  Map<String, Map<String, bool>> data = {};
  MainBlogGird({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(blogProvider);
    data = ref.read(blogProvider.notifier).getData;

    final firestorepaths = data.keys.toList() as List<String>;
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(blogProvider.notifier).init();
        await Future.delayed(Duration(seconds: 2));
      },
      child: Container(
        margin: EdgeInsets.all(8),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1 / 1.2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: firestorepaths.length,
          itemBuilder: (context, index) {
            return BlogSectionScreen(
              title: firestorepaths[index],
            );
          },
        ),
      ),
    );
    ;
  }
}
