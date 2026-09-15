import 'package:flutter/material.dart';

class ImageViewScreen extends StatelessWidget {
  String url;
  ImageViewScreen({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'image',
            child: Image.network(
              url,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}