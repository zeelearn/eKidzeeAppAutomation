import 'package:flutter/material.dart';

import '../helper/LightColor.dart';

class CommonWidget{

   static header(String title){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: LightColor.lightGrey,

        /*boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],*/
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }

}