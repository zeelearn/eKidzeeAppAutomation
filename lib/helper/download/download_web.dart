import 'dart:html' as html;

Future<void> downloadFile(String url) async {
  final anchor = html.AnchorElement(href: url)
    ..target = '_blank'
    ..download = url.split('/').last
    ..rel = 'noopener noreferrer';

  html.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
}
