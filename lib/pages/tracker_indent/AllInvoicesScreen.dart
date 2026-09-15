import 'package:ekidzee/pages/tracker_indent/model/TrackerIndent.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'ImageLoaderWidget.dart';

class AllInvoicesScreen extends StatefulWidget {
  final Invoices invoices;
  const AllInvoicesScreen({required this.invoices, super.key});

  @override
  State<AllInvoicesScreen> createState() => _AllInvoicesScreenState();
}

class _AllInvoicesScreenState extends State<AllInvoicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor,
        title: Text(
          'All Invoices',
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.white),
        ),
        // leadingWidth: 20,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Container(
              padding: const EdgeInsets.all(16),
              // decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(15),
              //     border: Border.all(width: 1, color: Colors.grey.shade300)),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Status : ',
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Invoice No : ',
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Delivery By : ',
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.invoices.status ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.invoices.invoiceno ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.invoices.provider ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                        ),
                      ],
                    ))
                  ],
                ),
              ]),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          widget.invoices.invoicedetails != null &&
                  widget.invoices.invoicedetails!.isNotEmpty
              ? Expanded(
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(15),
                                //     border: Border.all(
                                //         width: 1, color: Colors.grey.shade300)),
                                child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              flex: 3,
                                              child: widget
                                                          .invoices
                                                          .invoicedetails![
                                                              index]
                                                          .productImg !=
                                                      null
                                                  ? ImageLoaderWidget(
                                                      imageUrl: widget
                                                          .invoices
                                                          .invoicedetails![
                                                              index]
                                                          .productImg!)
                                                  : const Icon(Icons.shop)),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                              flex: 7,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    widget
                                                            .invoices
                                                            .invoicedetails![
                                                                index]
                                                            .description ??
                                                        '',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(fontSize: 16),
                                                  ),
                                                  Text(
                                                      'Qty: ${widget.invoices.invoicedetails![index].qty ?? ''}'),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ]),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 2,
                              color: Colors.grey.shade300,
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                      itemCount: widget.invoices.invoicedetails!.length),
                )
              : const Center(
                  child: Text('No Data Available'),
                )
        ]),
      ),
    );
  }
}
