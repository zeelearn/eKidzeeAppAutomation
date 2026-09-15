import 'package:ekidzee/constants.dart';
import 'package:ekidzee/pages/pentemind/module/myclass/add_annunancement.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../api/response/pentemind/myclass/announancement_response.dart';
import '../../../../firebase/anylatics.dart';
import '../../../../helper/utils.dart';
import '../../../../utils/theme/colors/light_colors.dart';
import '../../../k12/core/utils.dart';
import 'announcement_controller.dart';

class AnnoucementListScreen extends StatelessWidget {
  const AnnoucementListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initializing the controller
    final AnnouncementController controller = Get.put(AnnouncementController());
    
    FirebaseAnalyticsUtils().sendAnalyticsEvent('MYCLASS_Announcement');

    return Obx(() {
      // Show loader until base data (userType, userId etc.) is loaded from SharedPreferences
      if (!controller.isBaseLoaded.value) {
        return  Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: kPrimaryLightColor),
          ),
        );
      }

      return Scaffold(
        appBar: controller.userType == 'P'
            ? null
            : AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                title: Text(
                  'Announcement',
                  style: LightColors.textHeaderStyleWhite,
                ),
                backgroundColor: kPrimaryLightColor,
              ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: RefreshIndicator(
            color: Colors.white,
            backgroundColor: kPrimaryLightColor,
            strokeWidth: 4.0,
            onRefresh: () => controller.refreshData(),
            child: Column(
              children: [
                if (controller.userType != 'P') _buildHeader(context, controller),
                if (controller.canApprove) ...[
                  _buildTabBar(controller),
                  const SizedBox(height: 10),
                ],
                Expanded(
                  child: _buildAnnouncementList(controller),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHeader(BuildContext context, AnnouncementController controller) {
    return Container(
      color: LightColors.kLightBlue,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Announcement',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () async {
              await Get.to(() => Utility.isKES(controller.curriculumType)
                  ? NewAnnouncement.KES(
                      token: controller.token,
                      userName: controller.userName,
                      userId: controller.uid,
                      programId: controller.programId.toString(),
                    )
                  : NewAnnouncement(
                      token: controller.token,
                      userId: controller.uid,
                      programId: controller.programId.toString(),
                    ));
              controller.refreshData();
            },
            icon:  Icon(
              Icons.add_box,
              size: 30,
              color: kPrimaryLightColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(AnnouncementController controller) {
    return DefaultTabController(
      length: 2,
      child: Builder(builder: (context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            controller.filterAnnouncements(tabController.index == 0 ? 'app' : 'pend');
          }
        });
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: TabBar(
            isScrollable: false,
            tabs: const [Tab(text: 'Approved'), Tab(text: 'Pending')],
            dividerColor: Colors.blueGrey,
            labelColor: Utils.tabselectedColor,
            indicatorColor: Utils.tabindicatorColor,
            unselectedLabelColor: Utils.tabunselectedColor,
          ),
        );
      }),
    );
  }

  Widget _buildAnnouncementList(AnnouncementController controller) {
    return Obx(() {
      if (controller.isLoading.value && controller.announcementOriginalList.isEmpty) {
        return Center(
          child: Lottie.asset('assets/json/kidzee_loader.json'),
        );
      }

      if (controller.announcementList.isEmpty) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: Get.height * 0.6,
              child: Utility.emptyData(Get.context!,
                  "Announcement List not available at this moment please check later"),
            ),
          ],
        );
      }

      return ListView.builder(
        itemCount: controller.announcementList.length,
        padding: const EdgeInsets.only(bottom: 20),
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return AnnouncementRow(model: controller.announcementList[index]);
        },
      );
    });
  }
}

class AnnouncementRow extends StatelessWidget {
  final AnnouncementModel model;
  const AnnouncementRow({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          model.subject,
          style: LightColors.textStyle.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              model.msgBody,
              style: LightColors.subTextStyle,
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                model.publishDate,
                style: LightColors.smallTextStyle.copyWith(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
