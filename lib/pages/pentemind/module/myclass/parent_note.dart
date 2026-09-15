import 'package:ekidzee/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../api/response/pentemind/myclass/parentnote.dart';
import '../../../../utils/theme/colors/light_colors.dart';
import 'parent_note_controller.dart';

class ParentNoteScreen extends StatelessWidget {
  final bool isToolbar;
  const ParentNoteScreen({required this.isToolbar, super.key});

  @override
  Widget build(BuildContext context) {
    final ParentNoteController controller = Get.put(ParentNoteController());
    FirebaseAnalyticsUtils().sendAnalyticsEvent('MyClass:ParentNote');

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
        appBar: isToolbar
            ? AppBar(
                centerTitle: false,
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: kPrimaryLightColor,
                title: Text(
                  'Parent Note Resources',
                  style: LightColors.textHeaderStyleWhite,
                ),
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

  Widget _buildBody(ParentNoteController controller) {
    return Obx(() {
      if (controller.isLoading.value && controller.parentNoteList.isEmpty) {
        return Center(
          child: Lottie.asset('assets/json/kidzee_loader.json'),
        );
      }

      if (controller.parentNoteList.isEmpty) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: Get.height * 0.6,
              child: Utility.emptyData(Get.context!,
                  "Data are not available at this moment please check later"),
            ),
          ],
        );
      }

      return Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: controller.parentNoteList.length,
          padding: const EdgeInsets.only(bottom: 20),
          itemBuilder: (context, index) {
            return ParentNoteRow(model: controller.parentNoteList[index]);
          },
        ),
      );
    });
  }
}

class ParentNoteRow extends StatelessWidget {
  final ParentNoteModel model;
  const ParentNoteRow({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 3,
              color: Color(0x430F1113),
              offset: Offset(0, 1),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text('Day : ', style: LightColors.textvSmallStyle),
                      Text(model.CName, style: LightColors.textvSmallStyle),
                    ],
                  ),
                  Text(
                    'Date : ${Utility.parseDate(model.AssignedDate)}',
                    style: LightColors.textvSmallStyle,
                  ),
                ],
              ),
            ),
            ListTile(
              minLeadingWidth: 10,
              leading: SizedBox(
                width: 20,
                child: Image.asset(
                  'assets/icons/ic_parentnote.png',
                  width: 15,
                ),
              ),
              title: Text(
                model.ParentNote,
                style: LightColors.textHeaderStyle13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
