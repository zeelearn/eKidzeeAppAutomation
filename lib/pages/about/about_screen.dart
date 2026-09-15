import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  final String title;
  final String name;
  AboutUs({required this.name, required this.title}) : super();

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text('About Us'),
        ));
  }
}
