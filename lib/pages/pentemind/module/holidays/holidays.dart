import 'package:ekidzee/helper/LocalStrings.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// A page that opens the holiday master URL using supplied values.
class HolidayMasterPage extends StatelessWidget {
  final String zone;
  final String state;
  final int academicYear;
  final int frid;
  final String userType;

  const HolidayMasterPage({
    super.key,
    required this.zone,
    required this.state,
    required this.academicYear,
    required this.frid,
    required this.userType,
  });

  Uri get _holidayUrl {
    final encodedZone = Uri.encodeComponent(zone.trim());
    final encodedState = Uri.encodeComponent(state.trim());
    final encodedUserType = Uri.encodeComponent(userType.trim());
    return Uri.parse(
      '${WebViewUrlConstants.URL_HOLIDAY_MASTER}$encodedZone/$encodedState/$encodedUserType',
    );
  }

  Future<void> _openHolidayUrl(BuildContext context) async {
    final uri = _holidayUrl;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open URL: ${uri.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holiday Master'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Holiday URL is generated from provided values. No input fields are shown.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _openHolidayUrl(context),
                icon: const Icon(Icons.open_in_new),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  child: Text('Open Holiday URL'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Navigates to the HolidayMasterPage with the provided parameters.
void navigateToHolidayMasterPage(
  BuildContext context,
  String zone,
  String state,
  int academicYear,
  int frid,
  String userType,
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HolidayMasterPage(
        zone: zone,
        state: state,
        academicYear: academicYear,
        frid: frid,
        userType: userType,
      ),
    ),
  );
}
