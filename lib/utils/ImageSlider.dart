import 'package:carousel_slider/carousel_slider.dart';
import 'package:ekidzee/helper/utils.dart';
import 'package:flutter/material.dart';

import '../helper/LightColor.dart';

class ImageSliderWidget extends StatefulWidget {
  ImageSliderWidget({
    Key? key,
    required this.imageList,
    required this.title,
  }) : super(key: key);

  String title;
  List<String> imageList;
  String _currentType = 'Normal View';

  @override
  _ImageSliderWidget createState() => _ImageSliderWidget();
}

class _ImageSliderWidget extends State<ImageSliderWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: getUserInterface(),
    );
  }

  headerClick(value) {
    if (widget._currentType == '' || widget._currentType == 'Normal View') {
      widget._currentType = 'FULL SCREEN';
    } else {
      widget._currentType = 'Normal View';
    }
    //debugPrint(widget._currentType);
    setState(() {});
  }

  Widget _header(String text, Color textColor,
      {double height = 0, bool isPrimaryCard = false}) {
    return GestureDetector(
      //onTap: clipClick(actionString),
      onTap: () => headerClick(text),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: height),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: textColor.withAlpha(isPrimaryCard ? 150 : 50),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: isPrimaryCard ? Colors.white : textColor, fontSize: 12),
        ),
      ),
    );
  }

  Widget getUserInterface() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        _header(widget._currentType, LightColor.darkOrange, height: 5),
        getData(),
      ],
    );
  }

  Widget getFullScreen(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Builder(
        builder: (context) {
          final double height = MediaQuery.of(context).size.height - 200;
          return CarouselSlider(
            options: CarouselOptions(
              height: height,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              // autoPlay: false,
            ),
            items: widget.imageList
                .map((item) => Container(
                      child: Center(
                          child: Image.network(
                        item,
                        fit: BoxFit.cover,
                        height: height,
                      )),
                    ))
                .toList(),
          );
        },
      ),
    );
  }

  Widget getSlider(BuildContext context) {
    return Container(
        child: CarouselSlider.builder(
      options: CarouselOptions(
        aspectRatio: 2.0,
        enlargeCenterPage: false,
        viewportFraction: 1,
      ),
      itemCount: (widget.imageList.length / 2).round(),
      itemBuilder: (context, index, realIdx) {
        final int first = index * 2;
        final int second = first + 1;
        return Row(
          children: [first, second].map((idx) {
            return Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Image.network(widget.imageList[idx], fit: BoxFit.cover),
              ),
            );
          }).toList(),
        );
      },
    ));
  }

  Widget getData() {
    if (widget.imageList.length == 0) {
      return Utility.emptyDataSet(context);
    } else if (widget._currentType == '' ||
        widget._currentType == 'Normal View') {
      return getFullScreen(context);
    } else {
      return getSlider(context);
    }
  }
}
