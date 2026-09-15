import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../model/TrackerIndent.dart';
import '../../model/TrackerRequest.dart';

class TrackerController extends GetxController {
  final String franchiseeId;

  TrackerController(this.franchiseeId);

  /// Observables
  var orders = <Indents>[].obs;
  var filteredOrders = <Indents>[].obs;
  var isLoading = false.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;

  var page = 1.obs;
  var hasMore = true.obs;
  final int pageSize = 10;

  final searchController = TextEditingController();
  final scrollController = ScrollController();

  TrackerRequest? trackerRequest;

  @override
  void onInit() {
    super.onInit();
    _initScrollListener();
    loadInitialData();
  }

  void _initScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent &&
          hasMore.value &&
          !isLoading.value) {
        loadMore();
      }
    });
  }

  Future<void> loadInitialData() async {
    page.value = 1;
    orders.clear();
    hasMore.value = true;
    await fetchOrders();
  }

  Future<void> loadMore() async {
    page.value++;
    await fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      isError.value = false;

      // 🔥 Replace with real API call
      await Future.delayed(const Duration(seconds: 1));

      List<Indents> newData = List.generate(
        pageSize,
            (index) => Indents(
          indentId: "ORD-${page.value}-$index",
          indentDescription: "Books & Materials",
          indentStatus: "Delivered",
          indentDate: DateTime.now().toIso8601String(),
        ),
      );

      if (newData.length < pageSize) {
        hasMore.value = false;
      }

      orders.addAll(newData);
      filteredOrders.assignAll(orders);
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void filter(String keyword) {
    if (keyword.isEmpty) {
      filteredOrders.assignAll(orders);
    } else {
      filteredOrders.assignAll(
        orders.where((order) =>
        order.indentId!.toLowerCase().contains(keyword.toLowerCase()) ||
            order.indentDescription!
                .toLowerCase()
                .contains(keyword.toLowerCase())),
      );
    }
  }
}
