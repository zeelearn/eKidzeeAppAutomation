import 'package:ekidzee/widget/MyWebSiteView.dart';
import 'package:flutter/material.dart';

import '../models/user_payload.dart';
import '../services/encoder_service.dart';
import '../utils/app_constants.dart';

/// A page that generates a holiday master URL and launches it.
class HolidayMasterPage extends StatefulWidget {
  final UserPayload payload;
  final EncoderService encoderService;

  const HolidayMasterPage({
    super.key,
    required this.payload,
    this.encoderService = const EncoderService(),
  });

  @override
  State<HolidayMasterPage> createState() => _HolidayMasterPageState();
}

class _HolidayMasterPageState extends State<HolidayMasterPage> {
  late String _encodedUrl =
      'https:/google.com'; // Placeholder until initState runs

  @override
  void initState() {
    super.initState();
    _encodedUrl = widget.encoderService.buildEncodedUrl(
      payload: widget.payload,
      baseUrl: AppConstants.holidayBaseUrl,
    );
    debugPrint('Generated Holiday Master URL: $_encodedUrl');
  }

  @override
  Widget build(BuildContext context) {
    return MyWebsiteView(
      title: '',
      url: _encodedUrl,
    );
  }
}
