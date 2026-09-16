import 'dart:io';
import 'dart:ui' as ui;

import 'package:ekidzee/app_routes.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/mywebview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../main.dart';

class PromoNotification {
  static Future<void> displayPromoNotification(
      String title, String body, String bigImage, dynamic extraData) async {
    BuildContext context = MyApp.navigatorKey.currentContext!;
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            iconPadding: const EdgeInsets.only(right: 5.0, top: 0.0),
            titlePadding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
            icon: IconButton(
                alignment: Alignment.topRight,
                onPressed: () => Navigator.of(ctx).pop(),
                icon: const Icon(
                  Icons.clear,
                  size: 30,
                )),
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.start,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            content: SingleChildScrollView(
              child: InkWell(
                  onTap: () async {
                    if (extraData != null && extraData.toString().isNotEmpty) {
                      Navigator.pop(context);
                      await openCelebrationWebsite(
                        ctx,
                        title: title,
                        url: extraData.toString(),
                      );
                    }
                  },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      bigImage,
                      // height: MediaQuery.of(context).size.height * 0.3,
                      // fit: BoxFit.fitWidth,
                    ),
                    const SizedBox(height: 20),
                    Text(body, style: Theme.of(context).textTheme.labelLarge),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Future<void> displayCustomPromoNotification(
      String title,
      String body,
      String bigImage,
      dynamic actionurl,
      String displayName,
      String assetImage) async {
    BuildContext context = MyApp.navigatorKey.currentContext!;

    GlobalKey key = GlobalKey();
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(0),
            actions: [],
            iconPadding: const EdgeInsets.only(right: 5.0, top: 0.0),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            content: SizedBox(
              width: kIsWeb ? 400 : 500,
              child: SingleChildScrollView(
                child: InkWell(
                  onTap: () async {
                    if (actionurl != null && actionurl.toString().isNotEmpty) {
                      Navigator.pop(context);
                      await openCelebrationWebsite(
                        ctx,
                        title: title,
                        url: actionurl.toString(),
                      );
                    }
                  },
                  child: RepaintBoundary(
                    key: key,
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              assetImage,
                              // height: MediaQuery.of(context).size.height * 0.3,
                              // fit: BoxFit.fitWidth,
                            ),
                          ],
                        ),
                        Positioned(
                          top: kIsWeb
                              ? MediaQuery.of(context).size.height * 0.2
                              : MediaQuery.of(context).size.height *
                                  0.15, // 5% from the top
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              displayName,
                              style: LightColors.textHeaderStyleSatisfy,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 5.0, // Distance from the right edge
                          top:
                              5.0, // Distance from the top edge (adjust as needed)
                          child: WebWidget.getCloseButton(context),
                        ),
                        // Positioned(
                        //   right: 5.0, // Distance from the right edge
                        //   bottom:
                        //       5.0, // Distance from the top edge (adjust as needed)
                        //   child: InkWell(
                        //     onTap: () {
                        //       PromoNotification.captureAndPrint(_key);
                        //     },
                        //     child: Container(
                        //       width: 32.0, // You can adjust the size as needed
                        //       height: 32.0, // You can adjust the size as needed
                        //       decoration: BoxDecoration(
                        //         color: Colors.red, // Background color
                        //         borderRadius: BorderRadius.circular(
                        //             12.0), // Rounded corners
                        //         border: Border.all(
                        //           color: Colors.black, // Border color
                        //           width: 2.0, // Border width
                        //         ),
                        //       ),
                        //       child: Center(
                        //         child: Icon(
                        //           Icons.share, // Cross icon
                        //           color: Colors.white, // Icon color
                        //           size: 18.0, // Icon size
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  static Future<void> captureAndPrint(GlobalKey key) async {
//     debugPrint('prining');
    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    //final buffer = byteData!.buffer.asUint8List();
    final image1 = byteData!.buffer.asUint8List();
//     debugPrint('image generated');

// Create a PDF document
    // final pdf = pw.Document();
    // debugPrint('pdf generated');
    // final imageProvider = PdfImage(pdf.document,
    //     image: image1,
    //     height: PdfPageFormat.a4.height.toInt(),
    //     width: PdfPageFormat.a4.width.toInt()
    //     //size: PdfPageFormat.a4.size,
    //     );
    // debugPrint('pdf provider generated');
    // pdf.addPage(
    //   pw.Page(
    //     build: (pw.Context context) =>
    //         pw.Image(imageProvider as pw.ImageProvider),
    //   ),
    // );

    // Save PDF to a file
    final outputFile = await savePdf(image1);
    final pdfData = await outputFile.readAsBytes();

    // Print the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfData,
    );
    // await Printing.layoutPdf(
    //   onLayout: (PdfPageFormat format) async => buffer,
    // );
//     debugPrint('printing completed....');
  }

  static Future<File> savePdf(Uint8List pdfData) async {
    // Get the application's document directory
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/document.pdf';

    // Write the byte data to the file
    final file = File(filePath);
    await file.writeAsBytes(pdfData);

//     debugPrint('PDF saved to $filePath');
    return file;
  }

  static void showCustomDialog(
      BuildContext context, String assetName, String displayName) {
    GlobalKey key = GlobalKey();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: RepaintBoundary(
            key: key,
            child: Stack(
              children: [
                // Background image
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          assetName), // Replace with your image asset
                      fit: BoxFit.none,
                    ),
                  ),
                ),
                // Content of the dialog
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.topCenter,
                      child: Text(
                        'This is the title',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Spacer(), // Pushes the text to the top
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Dialog content goes here.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // Add more content here as needed
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
