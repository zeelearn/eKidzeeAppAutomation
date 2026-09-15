import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../constants.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../api/response/pentemind/parent_corner/artst.dart';
import '../../../../app_routes.dart';
import '../../../../utils/theme/colors/light_colors.dart';
import '../../../../widget/MyWidget.dart';
import 'artsy_controller.dart';
import 'artsy_details.dart';

class ArtsyScreen extends StatelessWidget {
  const ArtsyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ArtsyController controller = Get.put(ArtsyController());
    FirebaseAnalyticsUtils().sendAnalyticsEvent('ParentCorner:ELG');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          color: Colors.white,
          backgroundColor: kPrimaryLightColor,
          strokeWidth: 4.0,
          onRefresh: () async {
            await controller.getArtsyList();
          },
          child: Obx(() {
            if (controller.isLoading.value && controller.mArtsyList.isEmpty) {
              return Utility.showLoader();
            }
            return _buildContent(context, controller);
          }),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ArtsyController controller) {
    if (controller.mArtsyList.isEmpty) {
      return Column(
        children: [
          if (!kIsWeb)
            MyWidget().richText('Pull down to refresh...', LightColors.textvSmallStyle),
          _buildHeader(controller),
          Expanded(
            child: Utility.emptyData(context,
                "Data are not available at this moment please check later"),
          )
        ],
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 1),
      child: Column(
        children: [
          const SizedBox(height: 5),
          if (!kIsWeb)
            MyWidget().richText('Pull down to refresh...', LightColors.textSmallHightliteStyle),
          _buildHeader(controller),
          Expanded(
            child: ListView.builder(
              itemCount: controller.mArtsyList.length,
              itemBuilder: (context, index) {
                return _buildArtsyItem(context, controller, controller.mArtsyList[index]);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(ArtsyController controller) {
    return Container(
      margin: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Expanded(flex: 5, child: SizedBox()),
          Expanded(
              flex: 25,
              child: MyWidget().richText('Culmination', LightColors.textSmallStyle)),
          Expanded(
              flex: 50,
              child: Obx(() => MyWidget().getDropdownButton(
                  'Select Culmination',
                  controller.chosenValue.value,
                  controller.options,
                  Utility.ACTION_OBSERVATION,
                  controller))),
        ],
      ),
    );
  }

  Widget _buildArtsyItem(BuildContext context, ArtsyController controller, ArtsyModel model) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
      child: Container(
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
        child: ListTile(
          leading: model.MediaUrl.isEmpty
              ? null
              : GestureDetector(
                  onTap: () {
                    Get.to(() => goToVideoPlayer(
                          path: model.MediaUrl,
                          Title: model.Title,
                        ))?.then((_) => controller.getArtsyList());
                  },
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: Image.asset(
                      'assets/icons/ic_video.png',
                      width: 25,
                      height: 25,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          title: GestureDetector(
            onTap: () {
              _navigateDetails(controller, model);
            },
            child: Text(
              model.Title,
              style: GoogleFonts.roboto(
                fontSize: 14.0,
                color: const Color(0xFF4B39EF),
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),
          ),
          trailing: GestureDetector(
            onTap: () {
              _navigateDetails(controller, model);
            },
            child: Wrap(
              spacing: 5,
              children: <Widget>[
                _buildStatChip('D', model.D.toString(), LightColors.kLightGreenMaterial),
                _buildStatChip('ND', model.ND.toString(), LightColors.kLightRedMaterial),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Chip(
      backgroundColor: LightColors.kLightGrayM,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      avatar: CircleAvatar(
        radius: 10,
        backgroundColor: color,
        child: Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 8.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      label: Text(
        value,
        style: GoogleFonts.roboto(
          fontSize: 10.0,
          color: LightColors.kDarkBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _navigateDetails(ArtsyController controller, ArtsyModel model) {
    Get.to(() => ArtsyDetails(
          model: model,
          programID: controller.programId,
          userId: controller.uid,
        ))?.then((_) => controller.getArtsyList());
  }
}
