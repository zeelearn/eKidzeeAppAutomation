import 'package:ekidzee/model/NotificationModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

import '../../app_routes.dart';
import '../../constants.dart';

class DetailPage extends StatefulWidget {
  final NotificationModel notificationModel;
  const DetailPage({super.key, required this.notificationModel});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String _formatNotificationTime(String value) {
    try {
      final date = DateFormat('yyyy-MM-dd hh:mm a').parse(value);
      return DateFormat('MMM d, hh:mm a').format(date);
    } catch (_) {
      return value;
    }
  }

  void _openWebView() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => goToMYWebsite(
          title: widget.notificationModel.subject,
          url: widget.notificationModel.webViewUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryLightColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notification'),
        actions: [
          if (widget.notificationModel.logoUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.notificationModel.logoUrl),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
        children: [
          Text(
            widget.notificationModel.subject,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.schedule_rounded,
                  size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                _formatNotificationTime(widget.notificationModel.time),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ],
          ),
          if (widget.notificationModel.bigImageUrl.isNotEmpty) ...[
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => goToImageViewer(
                      imageUrl: widget.notificationModel.bigImageUrl,
                    ),
                  ),
                ),
                child: Image.network(
                  widget.notificationModel.bigImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image_outlined, size: 42),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: widget.notificationModel.message.contains('<')
                ? Html(data: widget.notificationModel.message)
                : Text(
                    widget.notificationModel.message,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.5,
                        ),
                  ),
          ),
          if (widget.notificationModel.webViewUrl.isNotEmpty) ...[
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _openWebView,
              style: FilledButton.styleFrom(
                backgroundColor: kPrimaryLightColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.open_in_browser_rounded),
              label: const Text('Open linked page'),
            ),
          ],
        ],
      ),
    );
  }
}
