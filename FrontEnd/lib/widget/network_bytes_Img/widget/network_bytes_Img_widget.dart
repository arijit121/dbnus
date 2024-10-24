import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/network_bytes_Img_bloc.dart';

class NetworkBytesImage extends StatelessWidget {
  const NetworkBytesImage(
      {super.key,
      this.height,
      this.width,
      this.radius,
      required this.imgUri,
      this.fit,
      this.errorWidget,
      this.loadingWidget});

  final double? width, height, radius;
  final String imgUri;
  final BoxFit? fit;
  final Widget? errorWidget, loadingWidget;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NetworkBytesImgBloc()..add(GetData(url: imgUri)),
      child: BlocBuilder<NetworkBytesImgBloc, NetworkBytesImgState>(
          builder: (context, state) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(radius ?? 0.0),
          child: state.isLoaded && state.bytes != null
              ? Image.memory(
                  state.bytes!,
                  width: width,
                  height: height,
                  fit: fit ?? BoxFit.contain,
                  errorBuilder: (_, __, ___) {
                    return errorWidget ??
                        Container(
                            color: Colors.grey,
                            width: width,
                            height: height,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                size: 20,
                              ),
                            ));
                  },
                )
              : state.isError == true
                  ? errorWidget ??
                      Container(
                          color: Colors.grey,
                          width: width,
                          height: height,
                          child: const Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              size: 20,
                            ),
                          ))
                  : loadingWidget ??
                      Container(
                        color: Colors.grey,
                        width: width,
                        height: height,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
        );
      }),
    );
  }
}
