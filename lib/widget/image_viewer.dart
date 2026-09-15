import 'dart:typed_data';

import 'package:ekidzee/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ImageViewer extends StatelessWidget {
  final String? imageUrl;
  final Uint8List? imageData;

  const ImageViewer({super.key, this.imageUrl, this.imageData});

  @override
  Widget build(BuildContext context) {
    debugPrint('image is $imageUrl');
    return Scaffold(
      body: GestureDetector(
        child: PinchZoom(
          maxScale: 4,
          zoomEnabled: true,
          child: Center(
            child: buildImageWidgetFromPathOrData(
              path: imageUrl,
              imageData: imageData,
              fit: BoxFit.contain,
              placeholder: Image.asset('assets/icons/ic_no_img_uploaded.png'),
            ),
            // : FadeInImage(
            //     width: MediaQuery.of(context).size.width,
            //     placeholderFit: BoxFit.none,
            //     placeholder:
            //         AssetImage('assets/icons/ic_no_img_uploaded.png'),
            //     image: NetworkImage(imageUrl),
            //     imageErrorBuilder: (context, error, stackTrace) {
            //       return Image.asset('assets/icons/ic_alerts.png',
            //           fit: BoxFit.fitWidth);
            //     },
            //     fit: BoxFit.cover,
            //   ),
          ),
          /*resetDuration: const Duration(milliseconds: 100),*/
          onZoomStart: () {
//             debugPrint('Start zooming');
          },
          onZoomEnd: () {
//             debugPrint('Stop zooming');
          },
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
