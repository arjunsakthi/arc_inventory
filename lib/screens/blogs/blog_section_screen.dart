import 'package:arc_inventory/resource/providers/blog_provider.dart';
import 'package:arc_inventory/resource/providers/refresh_provider.dart';
import 'package:arc_inventory/utilities/circularprogress_indicator.dart';
import 'package:arc_inventory/utilities/colors_gradients.dart';
import 'package:arc_inventory/widgets/blog_element.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlogSectionScreen extends ConsumerWidget {
  final String title;

  const BlogSectionScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => BlogElementGrid(path: title),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Color.fromARGB(153, 122, 12, 144),
            gradient: light_theme_gradient,
            borderRadius: BorderRadius.circular(25),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.05,
              color: Color.fromARGB(206, 255, 255, 255),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class BlogElementGrid extends ConsumerStatefulWidget {
  final String path;

  BlogElementGrid({super.key, required this.path});

  @override
  ConsumerState<BlogElementGrid> createState() => _BlogElementGridState();
}

class _BlogElementGridState extends ConsumerState<BlogElementGrid> {
  late Map<String, bool> data;

  @override
  Widget build(BuildContext context) {
    ref.watch(blogProvider.notifier);
    print('changed');
    ref.watch(refreshProvider);
    data = ref.read(blogProvider.notifier).getData[widget.path]!;
    final keys = data.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.path + ' Blogs',
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
          await Future.delayed(Duration(seconds: 1));
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
            itemCount: keys.length,
            itemBuilder: (context, index) {
              return BlogElement(
                title: keys[index],
                available: data[keys[index]]!,
                parentFolder: widget.path,
              );
            },
          ),
        ),
      ),
    );
  }
}
