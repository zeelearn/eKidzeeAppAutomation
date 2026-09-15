import 'package:ekidzee/model/NotificationModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

import '../../app_routes.dart';

class DetailPage extends StatefulWidget {
  final NotificationModel notificationModel;
  const DetailPage({super.key, required this.notificationModel});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    debugPrint(widget.notificationModel.message);
    final topAppBar = AppBar(
      elevation: 1,
      leadingWidth: 30,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              text: TextSpan(
                text: widget.notificationModel.subject,
                style: Theme.of(context).textTheme.titleSmall,
              )),
          /*  Text(
            widget.notificationModel.subject,
            style: Theme.of(context).textTheme.titleSmall,
          ), */
          Text(
            DateFormat('MMM/dd,hh:mm a').format(DateFormat('yyyy-mm-dd hh:mm a')
                .parse(widget.notificationModel.time)),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium,
          )
        ],
      ),
      actions: [
        widget.notificationModel.logoUrl.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.notificationModel.logoUrl),
                ),
              )
            : const SizedBox.shrink(),
      ],
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
    );

    return Scaffold(
      // backgroundColor: kWhiteColor,
      appBar: topAppBar,
      body: SingleChildScrollView(
        child: SizedBox(
          // height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // margin: const EdgeInsets.all(8),
          // padding: const EdgeInsets.all(8),
          // decoration: BoxDecoration(
          //     shape: BoxShape.rectangle,
          //     borderRadius: BorderRadius.circular(8.0),
          //     color: Colors.white,
          //     boxShadow: const [BoxShadow(blurRadius: 2.0)]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /*    widget.notificationModel.image_url.isNotEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 16.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child:
                              Image.network(widget.notificationModel.image_url),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    )
                  : const SizedBox.shrink(), */

              widget.notificationModel.bigImageUrl.isNotEmpty
                  ? Column(
                      children: [
                        const SizedBox(height: 16.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => goToImageViewer(
                                      imageUrl:
                                          widget.notificationModel.bigImageUrl),
                                )),
                            child: Image.network(
                                widget.notificationModel.bigImageUrl),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: widget.notificationModel.message.contains('<')
                      ? Html(data: widget.notificationModel.message)
                      : Text(widget.notificationModel.message)),
              widget.notificationModel.webViewUrl.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.all(8),
                      child: ElevatedButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => goToMYWebsite(
                                    title: widget.notificationModel.subject,
                                    url: widget.notificationModel.webViewUrl),
                              )),
                          child: const Text('View',
                              style: TextStyle(color: Colors.white))),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
