import 'dart:io';

import 'package:ekidzee/pages/centersetup/Model/MessageModel.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../helper/math_utils.dart';

class ImageMessageCard extends StatelessWidget {
  const ImageMessageCard({Key? key, required this.model}) : super(key: key);
  final MessageModel model;


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Color(0xffdcf8c6),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: getVerticalSize(4),
                  left: getVerticalSize(4),
                ),
                child: FadeInImage(
                  height: getVerticalSize(42),
                  width: double.infinity,
                  placeholder: AssetImage('assets/icons/ic_error_image.png'),
                  image: NetworkImage(model.path!),
                  imageErrorBuilder:
                      (context, error, stackTrace) {
                    return Image.file(
                        File(model.path as String),
                        height: 120,
                        width: 400,
                        fit: BoxFit.fitWidth);
                  },
                  fit: BoxFit.cover,
                ),/*Image.asset(
                                image!,
                                height: getVerticalSize(152),
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),*/
              ),
              const Gap(5),
              Padding(padding: EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    model.message,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          model.time,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.done_all,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],

              ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
