import 'package:ekidzee/model/ActivityPlanerModel.dart';
import 'package:flutter/material.dart';

class ArtworlViewer extends StatelessWidget {

  ArtworlViewer(
      {Key? key,
        required this.activityPlanerModel})
      : super(key: key);

  ActivityPlanerModel activityPlanerModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: activityPlanerModel.title,
            child: Image.network(
              activityPlanerModel.full_image,
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