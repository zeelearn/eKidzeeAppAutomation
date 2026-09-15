import 'package:ekidzee/helper/LightColor.dart';
import 'package:ekidzee/pages/tracker_indent/FilterOrderScreen.dart';
import 'package:ekidzee/pages/tracker_indent/OrderDetailScreen.dart';
import 'package:ekidzee/pages/tracker_indent/TrackerOrderCubit/tracker_order_cubit.dart';
import 'package:ekidzee/pages/tracker_indent/model/TrackerIndent.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'model/TrackerRequest.dart';

class TrackerOrderScreen extends StatefulWidget {
  final String franchiseeId;

  const TrackerOrderScreen({super.key, required this.franchiseeId});

  @override
  State<TrackerOrderScreen> createState() => _TrackerOrderScreenState();
}

class _TrackerOrderScreenState extends State<TrackerOrderScreen> {
  final TextEditingController searchController = TextEditingController();

  List<Indents> originalList = [];
  List<Indents> filteredList = [];

  String filterTime = 'Last 30 Days';
  TrackerRequest? trackerRequest;

  @override
  void initState() {
    super.initState();
    _loadTrackerData();
  }

  void _loadTrackerData() {
    trackerRequest = TrackerRequest(
      frachisee_Id: widget.franchiseeId,
      DocketNo: '',
      IndentType: 'ACK',
      fromDate: "2023-07-01",
      toDate: "2023-07-02",
      academicyearId: '0',
      indentNo: '0',
      status: 'ALL',
      last_days: '-30',
      academicyearName: 'Last 30 Days',
    );

    context.read<TrackerOrderCubit>().getTrackerIndent(trackerRequest!);
  }

  void _runFilter(String keyword) {
    if (keyword.isEmpty) {
      filteredList = originalList;
    } else {
      filteredList = originalList.where((indent) {
        return (indent.indentId ?? '').contains(keyword) ||
            (indent.indentDescription ?? '')
                .toLowerCase()
                .contains(keyword.toLowerCase()) ||
            (indent.indentStatus ?? '')
                .toLowerCase()
                .contains(keyword.toLowerCase());
      }).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool isTabletOrWeb = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Your Orders",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<TrackerOrderCubit, TrackerOrderState>(
        listener: (context, state) {
          if (state is TrackerOrderSuccessState) {
            originalList =
                state.trackerIndent.root?.subroot?.indents ?? [];
            filteredList = originalList;
            setState(() {});
          }
        },
        builder: (context, state) {
          if (state is TrackerOrderLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TrackerOrderErrorState) {
            return Center(child: Text(state.error));
          }

          if (filteredList.isEmpty) {
            return const Center(child: Text("No Orders Available"));
          }

          return Column(
            children: [
              _buildSearchAndFilter(isTabletOrWeb),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTabletOrWeb ? 100 : 12,
                  ),
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return _buildOrderCard(filteredList[index]);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // =============================
  // 🔎 Search & Filter Header
  // =============================
  Widget _buildSearchAndFilter(bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 100 : 16,
        vertical: 12,
      ),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: _runFilter,
                  decoration: InputDecoration(
                    hintText: "Search Orders",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.filter_alt,color: Colors.white,),
                label:  Text("Filter",style: LightColors.textHeaderStyle13Selected,),
                onPressed: () {
                  // Navigate to filter
                },
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(
            filterTime,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  // =============================
  // 📦 Attractive Order Card
  // =============================
  Widget _buildOrderCard(Indents indent) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OrderDetailScreen(indents: indent),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.blue.shade50,
                child: const Icon(Icons.inventory_2,
                    color: Colors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      indent.indentId ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      indent.indentDescription ?? '',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatusChip(indent.indentStatus ?? ''),
                        Text(
                          indent.indentDate != null
                              ? DateFormat('dd MMM yyyy').format(
                              DateTime.parse(indent.indentDate!))
                              : '',
                          style: const TextStyle(
                              color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = Colors.grey;

    if (status.toLowerCase().contains("approved")) {
      color = Colors.green;
    } else if (status.toLowerCase().contains("pending")) {
      color = Colors.orange;
    } else if (status.toLowerCase().contains("rejected")) {
      color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
            color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

