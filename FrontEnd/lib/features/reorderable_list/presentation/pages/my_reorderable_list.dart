import 'dart:ui';

import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/navigation/router_name.dart';
import 'package:dbnus/core/storage/localCart/bloc/local_cart_bloc.dart';
import 'package:dbnus/core/storage/localCart/model/cart_service_model.dart';
import 'package:dbnus/shared/ui/atoms/buttons/custom_button.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';

class MyReOrderAbleList extends StatefulWidget {
  const MyReOrderAbleList({super.key});

  @override
  State<MyReOrderAbleList> createState() => _MyReOrderAbleListState();
}

class _MyReOrderAbleListState extends State<MyReOrderAbleList> {
  List<String> items = List.generate(5, (index) => 'Item ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomGOEButton(
            width: 200,
            onPressed: () async {
              context.read<LocalCartBloc>().add(AddServiceToCart(
                      serviceModel: CartServiceModel(
                    serviceId: "hvsdhvfshv",
                    price: 20.6,
                  )));
            },
            gradient: const LinearGradient(colors: [
              ColorConst.red,
              Colors.blue,
            ]),
            child: const CustomText("Add to cart")),
        12.ph,
        CustomGOEButton(
            width: 200,
            onPressed: () async {
              kIsWeb
                  ? context.goNamed(RouteName.order)
                  : context.pushNamed(RouteName.order);
            },
            gradient: const LinearGradient(colors: [
              ColorConst.red,
              Colors.blue,
            ]),
            child: const CustomText("Navigate to order")),
        12.ph,
        Expanded(
          child: ReorderableListView(
            shrinkWrap: true,
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
              (index) => Card(
                key: Key('$index'),
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    items[index],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
      ],
    );
  }
}
