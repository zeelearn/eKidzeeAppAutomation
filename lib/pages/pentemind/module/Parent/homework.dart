import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/theme/colors/light_colors.dart';
import 'order.dart';

class LatestOrders extends StatelessWidget {
  final List<Order> orders = [
  ];

  LatestOrders({super.key});
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Latest Orders",
                  style: TextStyle(
                    color: Color.fromRGBO(19, 22, 33, 1),
                    fontSize: 18.0,
                  ),
                ),
                Text(
                  "View All",
                  style: TextStyle(
                    color: LightColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              // Lets pass the order to a new widget and render it there
              return OrderCard(
                order: orders[index],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 15.0,
              );
            },
            itemCount: orders.length,
          )
          // Let's create an order model
        ],
      ),
    );
  }
}

enum OrderStatus { PICKING_UP, DELIVERING }

class Order {
  final int id;
  final OrderStatus status;
  final DateTime arrivalDate;
  final DateTime placedDate;
  final String deliveryAddress;

  Order({
    required this.id,
    required this.status,
    required this.arrivalDate,
    required this.placedDate,
    required this.deliveryAddress,
  });
}
