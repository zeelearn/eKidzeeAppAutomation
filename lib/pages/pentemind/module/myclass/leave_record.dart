import 'package:ekidzee/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../api/response/pentemind/myclass/leave_records.dart';
import '../../../../utils/theme/colors/light_colors.dart';
import '../../../k12/core/utils.dart';
import '../Parent/add_leave.dart';
import 'leave_record_controller.dart';

class LeaveRecordScreen extends StatelessWidget {
  final bool isAppbar;
  const LeaveRecordScreen({super.key, required this.isAppbar});

  @override
  Widget build(BuildContext context) {
    final LeaveRecordController controller = Get.put(LeaveRecordController());
    FirebaseAnalyticsUtils().sendAnalyticsEvent('MyClass:LeaveRecord');
    controller.fetchLeaveRecords();
    return Obx(() {
      if (!controller.isBaseLoaded.value) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: kPrimaryLightColor),
          ),
        );
      }

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: isAppbar
            ? AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: kPrimaryLightColor,
                centerTitle: false,
                title: Text('Leave Record',
                    style: LightColors.textHeaderStyleWhite),
              )
            : null,
        body: SafeArea(
          child: RefreshIndicator(
            color: Colors.white,
            backgroundColor: kPrimaryLightColor,
            strokeWidth: 4.0,
            onRefresh: () => controller.refreshData(),
            child: _buildBody(controller),
          ),
        ),
      );
    });
  }

  Widget _buildBody(LeaveRecordController controller) {
    return Obx(() {
      if (controller.isLoading.value &&
          controller.mLeaveOriginalInfoList.isEmpty) {
        return Center(
          child: Lottie.asset('assets/json/kidzee_loader.json'),
        );
      }

      return Column(
        children: [
          if (controller.userType == 'P') _buildParentHeader(controller),
          const SizedBox(height: 10),
          Expanded(
            child: controller.canAcknowledge()
                ? _buildAcknowledgeTabs(controller)
                : _LeaveListView(type: 'all', controller: controller),
          ),
        ],
      );
    });
  }

  Widget _buildParentHeader(LeaveRecordController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Leave Record",
            style: TextStyle(
              color: Color.fromRGBO(19, 22, 33, 1),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          _AddNewLeaveButton(controller: controller),
        ],
      ),
    );
  }

  Widget _buildAcknowledgeTabs(LeaveRecordController controller) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: TabBar(
              tabs: const [
                Tab(text: 'Approved'),
                Tab(text: 'Pending to Acknowledge'),
              ],
              labelColor: Utils.tabselectedColor,
              unselectedLabelColor: Utils.tabunselectedColor,
              indicatorColor: Utils.tabindicatorColor,
              dividerColor: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              children: [
                _LeaveListView(type: 'all', controller: controller),
                _LeaveListView(type: 'ack', controller: controller),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddNewLeaveButton extends StatelessWidget {
  final LeaveRecordController controller;
  const _AddNewLeaveButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await Get.to(() => AddNewLeave(
              token: controller.token,
              userId: controller.uid,
              programId: controller.programId.toString(),
              studentId: controller.studentId,
            ));
        controller.refreshData();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryLightColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text("Add New Leave"),
    );
  }
}

class _LeaveListView extends StatelessWidget {
  final String type;
  final LeaveRecordController controller;
  final TextEditingController searchController = TextEditingController();

  _LeaveListView({required this.type, required this.controller});

  @override
  Widget build(BuildContext context) {
    bool isAll = type == 'all';

    return Obx(() {
      var list =
          isAll ? controller.mLeaveAllInfoList : controller.mLeaveAckInfoList;

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              onChanged: (value) => controller.performSearch(value.trim()),
              decoration: InputDecoration(
                hintText: 'Search by subject, body...',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              ),
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: Get.height * 0.5,
                        child: Utility.emptyData(
                          context,
                          searchController.text.isNotEmpty
                              ? 'No Matching Data found.'
                              : "Data are not available at this moment please check later",
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: list.length,
                    padding: const EdgeInsets.only(bottom: 20),
                    itemBuilder: (context, index) {
                      return LeaveRecordRow(
                        model: list[index],
                        canAck: !isAll && controller.canAcknowledge(),
                        controller: controller,
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }
}

class LeaveRecordRow extends StatelessWidget {
  final LeaveInfoModel model;
  final bool canAck;
  final LeaveRecordController controller;

  const LeaveRecordRow({
    super.key,
    required this.model,
    required this.canAck,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ref ID: ${model.ID}', style: LightColors.textvSmallStyle),
                Text(
                  'Date: ${Utility.parseDateformat(model.Date)}',
                  style: LightColors.textvSmallStyle,
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(model.Subject, style: LightColors.textHeaderStyle16),
            subtitle: Html(
              data: model.Body,
              style: {
                "body": Style(
                    fontSize: FontSize(13.0),
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero)
              },
            ),
            trailing: canAck
                ? Checkbox(
                    value: model.ApprovalStatus == 'Approved',
                    onChanged: (val) {
                      if (val != null) {
                        controller.updateLeaveStatus(
                            model, val ? 'Approved' : 'Pending');
                      }
                    },
                  )
                : null,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  model.ApprovalStatus == 'Approved'
                      ? 'Acknowledged'
                      : 'Pending for Acknowledgement',
                  style: LightColors.textvSmallStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: model.ApprovalStatus == 'Approved'
                        ? LightColors.kLightGreen
                        : LightColors.kRed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
