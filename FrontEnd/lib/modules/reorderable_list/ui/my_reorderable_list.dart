import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../router/router_name.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_text.dart';

class MyReorderableList extends StatefulWidget {
  @override
  _MyReorderableListState createState() => _MyReorderableListState();
}

class _MyReorderableListState extends State<MyReorderableList> {
  List<String> items = List.generate(5, (index) => 'Item ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomGOEButton(
            size: const Size(200, 36),
            onPressed: () async {
              kIsWeb
                  ? context.goNamed(RouteName.order)
                  : context.pushNamed(RouteName.order);
            },
            gradient: const LinearGradient(colors: [
              Colors.red,
              Colors.blue,
            ]),
            child: const CustomText("Navigate to order")),
        Expanded(
          child: ReorderableListView(
            shrinkWrap: true,
            buildDefaultDragHandles: false,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = items.removeAt(oldIndex);
                items.insert(newIndex, item);
              });
            },
            proxyDecorator: (child, index, animation) {
              return AnimatedBuilder(
                animation: animation,
                builder: (BuildContext context, Widget? child) {
                  final double animValue =
                      Curves.easeInOut.transform(animation.value);
                  final double scale = lerpDouble(1, 1.1, animValue)!;
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: child,
              );
            },
            children: List.generate(
              items.length,
              (index) => ReorderableDragStartListener(
                index: index,
                key: Key('$index'),
                child: Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      items[index],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          items.removeAt(index);
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
