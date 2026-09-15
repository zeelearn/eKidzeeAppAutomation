import 'package:ekidzee/helper/LightColor.dart';
import 'package:ekidzee/pages/tracker_indent/AllInvoicesScreen.dart';
import 'package:ekidzee/pages/tracker_indent/AllProductScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import 'InvoiceWidget.dart';
import 'OrderDeliverySheet.dart';
import 'TrackerOrderCubit/tracker_order_cubit.dart';
import 'model/TrackerIndent.dart';

class OrderDetailScreen extends StatefulWidget {
  Indents indents;
  OrderDetailScreen({required this.indents, super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.indents.indentId != null) {
      BlocProvider.of<TrackerOrderCubit>(context)
          .getTrackerIndentDetails(widget.indents.indentId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor,
        title: Text(
          'View Order Details',
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.white),
        ),
        // leadingWidth: 20,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                          'Indent date',
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Indent No',
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Indent total',
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.indents.indentDate != null
                            ? DateFormat('yyyy-MM-dd').format(
                                DateTime.parse(widget.indents.indentDate!))
                            : ''),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(widget.indents.indentId ?? ''),
                        const SizedBox(
                          height: 5,
                        ),
                        Text('\u{20B9}${widget.indents.indentAmount ?? ''}')
                      ],
                    ))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 2,
                  color: LightColor.grey,
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<TrackerOrderCubit, TrackerOrderState>(
                  buildWhen: (previous, current) =>
                      current is IndentOrderDetailErrorState ||
                      current is IndentOrderDetailLoadingState ||
                      current is IndentOrderDetailSuccessState,
                  builder: (context, state) {
                    if (state is IndentOrderDetailSuccessState) {
                      return InkWell(
                        onTap: () {
                          state.indents.products != null
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AllProductScreen(
                                        products: state.indents.products!),
                                  ))
                              : null;
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'View Product',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded)
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ]),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          BlocBuilder<TrackerOrderCubit, TrackerOrderState>(
            buildWhen: (previous, current) =>
                current is IndentOrderDetailErrorState ||
                current is IndentOrderDetailLoadingState ||
                current is IndentOrderDetailSuccessState,
            builder: (context, state) {
              if (state is IndentOrderDetailErrorState) {
                return Center(
                  child: Text(state.error),
                );
              } else if (state is IndentOrderDetailSuccessState) {
                return state.indents.invoices != null &&
                        state.indents.invoices!.isNotEmpty
                    ? Expanded(
                        child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Invoices details ${index + 1} of ${state.indents.invoices!.length}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AllInvoicesScreen(
                                                    invoices: state.indents
                                                        .invoices![index]),
                                          ));
                                    },
                                    child: Card(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
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
                                                height: 5,
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Delivery',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                height: 2,
                                                color: Colors.grey.shade300,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      state
                                                              .indents
                                                              .invoices![index]
                                                              .status ??
                                                          '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        const Text(
                                                          'Delivery By : ',
                                                        ),
                                                        Text(
                                                          state
                                                                  .indents
                                                                  .invoices![
                                                                      index]
                                                                  .provider ??
                                                              '',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyLarge!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        const Text(
                                                            'Invoice No - '),
                                                        Text(
                                                          state
                                                                  .indents
                                                                  .invoices![
                                                                      index]
                                                                  .invoiceno ??
                                                              '',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        const Text(
                                                            'Docket No - '),
                                                        Text(
                                                          state
                                                                  .indents
                                                                  .invoices![
                                                                      index]
                                                                  .docketNo ??
                                                              '',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              if (state.indents.invoices![index]
                                                          .invoicedetails !=
                                                      null &&
                                                  state
                                                      .indents
                                                      .invoices![index]
                                                      .invoicedetails!
                                                      .isNotEmpty) ...[
                                                if (state
                                                        .indents
                                                        .invoices![index]
                                                        .invoicedetails!
                                                        .length >=
                                                    3) ...[
                                                  for (int i = 0;
                                                      i < 3;
                                                      i++) ...[
                                                    InvoiceWidget(
                                                        invoicedetails: state
                                                            .indents
                                                            .invoices![index]
                                                            .invoicedetails![i])
                                                  ],
                                                  InkWell(
                                                    onTap: () => Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              AllInvoicesScreen(
                                                                  invoices: state
                                                                          .indents
                                                                          .invoices![
                                                                      index]),
                                                        )),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Text(
                                                        'Show more',
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge,
                                                      ),
                                                    ),
                                                  ),
                                                ] else if (state
                                                        .indents
                                                        .invoices![index]
                                                        .invoicedetails!
                                                        .length ==
                                                    2) ...[
                                                  for (int i = 0;
                                                      i < 2;
                                                      i++) ...[
                                                    InvoiceWidget(
                                                        invoicedetails: state
                                                            .indents
                                                            .invoices![index]
                                                            .invoicedetails![i])
                                                  ]
                                                ] else ...[
                                                  InvoiceWidget(
                                                      invoicedetails: state
                                                          .indents
                                                          .invoices![index]
                                                          .invoicedetails![0])
                                                ]
                                              ]
                                            ]),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        builder: (context) {
                                          return OrderDeliverySheet(
                                            invoices:
                                                state.indents.invoices![index],
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Track Shipment',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 20,
                                        )
                                      ],
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
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 10,
                                ),
                            itemCount: state.indents.invoices!.length),
                      )
                    : const Center(
                        child: Text('No Invoice Available'),
                      );
              } else if (state is IndentOrderDetailLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ]),
      ),
    );
  }

  void loadProductData() {}
}
