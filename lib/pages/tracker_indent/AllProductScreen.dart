import 'package:ekidzee/pages/tracker_indent/model/TrackerIndent.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'ImageLoaderWidget.dart';

class AllProductScreen extends StatefulWidget {
  final List<Products> products;
  const AllProductScreen({required this.products, super.key});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor,
        title: Text(
          'All Products',
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.white),
        ),
        // leadingWidth: 20,
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.products.isNotEmpty
              ? ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, productIndex) {
                    return Column(mainAxisSize: MainAxisSize.min, children: [
                      Card(
                        elevation: 10,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(15),
                          //     border: Border.all(width: 1, color: Colors.grey.shade300)),
                          child: Column(children: [
                            InkWell(
                              onTap: () {
                                if (selectedIndex == productIndex) {
                                  selectedIndex = -1;
                                } else {
                                  selectedIndex = productIndex;
                                }
                                setState(() {});
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Product Name',
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'Product Code',
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      widget.products[productIndex].productDtls!
                                              .isEmpty
                                          ? const SizedBox.shrink()
                                          : const Text(
                                              'Product total',
                                            ),
                                    ],
                                  )),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        widget.products[productIndex]
                                                .productName ??
                                            '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        widget.products[productIndex]
                                                .productCode ??
                                            '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      widget.products[productIndex].productDtls!
                                              .isEmpty
                                          ? const SizedBox.shrink()
                                          : Text(
                                              '${widget.products[productIndex].productDtls!.length} item',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            )
                                    ],
                                  ))
                                ],
                              ),
                            ),
                            widget.products[productIndex].productDtls!.isEmpty
                                ? const SizedBox.shrink()
                                : InkWell(
                                    onTap: () {
                                      if (selectedIndex == productIndex) {
                                        selectedIndex = -1;
                                      } else {
                                        selectedIndex = productIndex;
                                      }
                                      setState(() {});
                                    },
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: selectedIndex != productIndex
                                          ? const Icon(
                                              Icons.keyboard_arrow_down)
                                          : const Icon(Icons.keyboard_arrow_up),
                                    ),
                                  )
                          ]),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (selectedIndex == productIndex) ...[
                        if (widget.products[productIndex].productDtls != null &&
                            widget.products[productIndex].productDtls!
                                .isNotEmpty) ...[
                          for (int productDtlsIndex = 0;
                              productDtlsIndex <
                                  widget.products[productIndex].productDtls!
                                      .length;
                              productDtlsIndex++) ...[
                            Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Card(
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
                                            height: 10,
                                          ),
                                          Text(
                                            widget
                                                    .products[productIndex]
                                                    .productDtls![
                                                        productDtlsIndex]
                                                    .status ??
                                                '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(color: Colors.green),
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                'Bom Code:',
                                              ),
                                              Text(
                                                widget
                                                        .products[productIndex]
                                                        .productDtls![
                                                            productDtlsIndex]
                                                        .bomCode ??
                                                    '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                        color: Colors.green),
                                              ),
                                            ],
                                          ),
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
                                                              .products[
                                                                  productIndex]
                                                              .productDtls![
                                                                  productDtlsIndex]
                                                              .productImg !=
                                                          null
                                                      ? ImageLoaderWidget(
                                                          imageUrl: widget
                                                              .products[
                                                                  productIndex]
                                                              .productDtls![
                                                                  productDtlsIndex]
                                                              .productImg!)
                                                      : const Icon(Icons.shop)),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                  flex: 7,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        widget
                                                                .products[
                                                                    productIndex]
                                                                .productDtls![
                                                                    productDtlsIndex]
                                                                .productName ??
                                                            '',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .copyWith(
                                                                fontSize: 16),
                                                      ),
                                                      Text(
                                                          'Product Id: ${widget.products[productIndex].productDtls![productDtlsIndex].productId ?? ''}'),
                                                      Text(
                                                          'Qty: ${widget.products[productIndex].productDtls![productDtlsIndex].qty ?? ''}'),
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
                            )
                          ],
                        ]
                      ]
                    ]);
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                  itemCount: widget.products.length)
              : const Center(
                  child: Text('No Data Available'),
                )),
    );
  }
}
