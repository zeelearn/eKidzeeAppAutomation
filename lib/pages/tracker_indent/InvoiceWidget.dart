import 'package:ekidzee/pages/tracker_indent/model/TrackerIndent.dart';
import 'package:flutter/material.dart';

import 'ImageLoaderWidget.dart';

class InvoiceWidget extends StatelessWidget {
  final Invoicedetails invoicedetails;
  const InvoiceWidget({required this.invoicedetails, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 3,
                child: invoicedetails.productImg != null
                    ? ImageLoaderWidget(imageUrl: invoicedetails.productImg!)
                    : const Icon(Icons.shop)),
            const SizedBox(
              width: 5,
            ),
            Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoicedetails.description ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 16),
                    ),
                    Text('Qty: ${invoicedetails.qty ?? ''}'),
                  ],
                )),
          ],
        ),
        const SizedBox(
          height: 3,
        )
      ],
    );
  }
}
