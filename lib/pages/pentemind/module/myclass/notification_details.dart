import 'package:ekidzee/api/response/k12/notification/notification.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class NotificationDetialsPage extends StatefulWidget {
  final NotificationList notification;
  final int trimLength;

  const NotificationDetialsPage(
      {super.key, required this.notification, this.trimLength = 100});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<NotificationDetialsPage> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final showReadMore =
        widget.notification.msgBody!.length > widget.trimLength;
    final displayText =
        _isExpanded || widget.notification.msgBody!.length < widget.trimLength
            ? widget.notification.msgBody!
            : widget.notification.msgBody!.substring(0, widget.trimLength);

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black),
        children: [
          TextSpan(
            text: displayText,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
          if (true)
            TextSpan(
              text: _isExpanded ? " Read less" : "… Read more",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
            ),
        ],
      ),
    );
  }
}
