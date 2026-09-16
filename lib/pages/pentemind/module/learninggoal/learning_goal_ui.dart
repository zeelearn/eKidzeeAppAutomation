import 'package:ekidzee/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

/// Shared layout + styling for Learning Goal anecdotal screens.
class LearningGoalUi {
  LearningGoalUi._();

  static const Color pageBackground = Color(0xFFF6F7FB);

  static int gridCrossAxisCount(double width) {
    if (width >= 1200) return 4;
    if (width >= 900) return 3;
    if (width >= 600) return 2;
    return 2;
  }

  static double gridChildAspectRatio(double width) {
    if (width >= 900) return 2.35;
    if (width >= 600) return 2.1;
    return 1.85;
  }

  static EdgeInsets pagePadding(double width) {
    final horizontal = width >= 900 ? 24.0 : 12.0;
    return EdgeInsets.fromLTRB(horizontal, 12, horizontal, 24);
  }

  static double contentMaxWidth(double width) {
    if (width >= 1200) return 1100;
    if (width >= 900) return 900;
    return width;
  }

  static PreferredSizeWidget appBar({
    required String title,
    String? subtitle,
    List<Widget>? actions,
  }) {
    return AppBar(
      centerTitle: false,
      backgroundColor: kPrimaryLightColor,
      elevation: 0,
      leading: const BackButton(color: Colors.white),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (subtitle != null && subtitle.isNotEmpty)
            Text(
              subtitle,
              style: GoogleFonts.roboto(
                fontSize: 11,
                color: Colors.white70,
              ),
            ),
        ],
      ),
      actions: actions,
    );
  }

  static Widget loading() {
    return Center(
      child: Lottie.asset('assets/json/kidzee_loader.json'),
    );
  }

  static Widget offlineBanner() {
    return Material(
      color: const Color(0xFFFFF4E5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.cloud_off, size: 18, color: Color(0xFFB76E00)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Showing saved offline data. Pull to refresh when online.',
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: const Color(0xFF8A5A00),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget termSelector({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String label = 'Term',
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today_outlined,
              size: 20, color: kPrimaryLightColor),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down, color: kPrimaryLightColor),
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                items: items
                    .map(
                      (t) => DropdownMenuItem<String>(
                        value: t,
                        child: Text(t),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget studentCardShell({
    required Widget header,
    required Widget body,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          const Divider(height: 1),
          body,
        ],
      ),
    );
  }

  static Widget studentHeader({
    required String name,
    required Widget avatar,
    String? subtitle,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      child: Row(
        children: [
          avatar,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  static Widget gridTile({
    required String title,
    String? subtitle,
    String? preview,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Material(
      color: const Color(0xFFF8F9FC),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.robotoSlab(
                        fontSize: 12,
                        color: kPrimaryLightColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null && subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                    if (preview != null && preview.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        preview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontSize: 11,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing,
              ],
            ],
          ),
        ),
      ),
    );
  }

  static Widget centeredContent({
    required double maxWidth,
    required Widget child,
  }) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
