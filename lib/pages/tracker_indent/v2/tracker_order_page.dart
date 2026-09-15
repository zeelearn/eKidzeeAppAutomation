import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/tracker_controller.dart';
import 'order_card.dart';
import 'order_detail_page.dart';

class TrackerOrderPage extends StatelessWidget {
  final String franchiseeId;

  const TrackerOrderPage({super.key, required this.franchiseeId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TrackerController(franchiseeId));

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      // appBar: AppBar(
      //   title: const Text("Your Orders"),
      //   elevation: 0,
      // ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWeb = constraints.maxWidth > 800;

          return Column(
            children: [
              _searchBar(controller),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.orders.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.isError.value) {
                    return Center(
                        child: Text(controller.errorMessage.value));
                  }

                  if (controller.filteredOrders.isEmpty) {
                    return const Center(child: Text("No Orders Found"));
                  }

                  return GridView.builder(
                    controller: controller.scrollController,
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWeb ? 3 : 1,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 3.5,
                    ),
                    itemCount: controller.filteredOrders.length +
                        (controller.hasMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < controller.filteredOrders.length) {
                        final order =
                        controller.filteredOrders[index];

                        return Hero(
                          tag: order.indentId!,
                          child: OrderCard(
                            order: order,
                            onTap: () {
                              Get.to(() =>
                                  OrderDetailPage(order: order));
                            },
                          ),
                        );
                      } else {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                    },
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _searchBar(TrackerController controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.filter,
        decoration: InputDecoration(
          hintText: "Search orders...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
