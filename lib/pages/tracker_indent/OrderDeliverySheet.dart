import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'FilterUtils.dart';
import 'model/TrackerIndent.dart';

class OrderDeliverySheet extends StatefulWidget {
  final Invoices invoices;
  const OrderDeliverySheet({required this.invoices, super.key});

  @override
  State<OrderDeliverySheet> createState() => _OrderDeliverySheetState();
}

class _OrderDeliverySheetState extends State<OrderDeliverySheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Stack(children: [
        Container(
          color: Colors.white,
          margin: const EdgeInsets.only(top: 40),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              widget.invoices.logisticStatus != null &&
                      widget.invoices.logisticStatus!.isNotEmpty
                  ? Expanded(
                      child: ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                      // physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.invoices.logisticStatus![index]
                                          .docketDate !=
                                      null
                                  ? DateFormat('EEEE dd MMM').format(
                                      DateTime.parse(widget
                                          .invoices
                                          .logisticStatus![index]
                                          .milestoneDateTime!))
                                  : '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontSize: 16,
                                      color: HexColor.fromHex('#618183')),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Text(
                                      widget.invoices.logisticStatus![index]
                                                  .docketDate !=
                                              null
                                          ? DateFormat('HH:mm aa').format(
                                              DateTime.parse(widget
                                                  .invoices
                                                  .logisticStatus![index]
                                                  .milestoneDateTime!))
                                          : '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color:
                                                  HexColor.fromHex('#618183'),
                                              fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                  width: 2,
                                  height: 35,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Delivery Status - ${widget.invoices.logisticStatus![index].milestoneStatus ?? ''}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: HexColor.fromHex(
                                                    '#618183')),
                                      ),
                                      Text(
                                        'Address - ${widget.invoices.logisticStatus![index].milestoneReason ?? ''}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: HexColor.fromHex(
                                                    '#618183')),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        );
                      },
                      itemCount: widget.invoices.logisticStatus!.length,
                    ))
                  : const Center(
                      child: Text('No Data Available'),
                    )
            ]),
          ),
        ),
        Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ))
      ]),
    );
  }
}
