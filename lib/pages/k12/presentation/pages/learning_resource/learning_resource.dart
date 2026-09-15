import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../api/response/pentemind/learningmaterial/learning_material.dart';
import '../../../../../app_routes.dart';
import '../../../../../constants.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../../widget/MyWidget.dart';
import '../../../core/widgets/homework_dropdown_widget.dart';
import 'learning_resource_controller.dart';

class LearningResource extends StatelessWidget {
  final bool isForNepal;
  const LearningResource({required this.isForNepal, super.key});

  @override
  Widget build(BuildContext context) {
    // By setting permanent: false, GetX will dispose of the controller 
    // when this widget is removed from the navigation stack.
    final LearningResourceController controller = Get.put(
      LearningResourceController(isForNepal: isForNepal),
      permanent: false,
    );
    
    FirebaseAnalyticsUtils().sendAnalyticsEvent('Learning Resource');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          color: Colors.white,
          backgroundColor: kPrimaryLightColor,
          strokeWidth: 4.0,
          onRefresh: () => controller.getMaterials(),
          child: Obx(() {
            if (controller.isLoading.value && controller.mMaterials.isEmpty) {
              return Utility.showLoader();
            }
            return _buildContent(controller);
          }),
        ),
      ),
    );
  }

  Widget _buildContent(LearningResourceController controller) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildFilters(controller),
        const SizedBox(height: 10),
        _buildCategoryDropdown(controller),
        const SizedBox(height: 10),
        Expanded(
          child: controller.mMaterials.isEmpty
              ? _buildEmptyState()
              : _buildMaterialList(controller),
        ),
      ],
    );
  }

  Widget _buildFilters(LearningResourceController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: homwworkDropDown<String>(
              controller.selectedSubject.value,
              textEditingController: controller.subjectController,
              (val) => controller.selectedSubject.value = val!,
              controller.subjectoptions,
              (p0) => p0,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: homwworkDropDown<String>(
              controller.selectedChapter.value,
              textEditingController: controller.chapterController,
              (val) => controller.selectedChapter.value = val!,
              controller.chapteroptions,
              (p0) => p0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown(LearningResourceController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: MyWidget().getDropdownButton(
        'Select Activity',
        controller.chosenValue.value,
        controller.options,
        Utility.ACTION_OBSERVATION,
        controller,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No resources found for the selected criteria.',
        style: GoogleFonts.roboto(color: Colors.grey),
      ),
    );
  }

  Widget _buildMaterialList(LearningResourceController controller) {
    return ListView.builder(
      itemCount: controller.mMaterials.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, index) {
        return _buildMaterialItem(context, controller.mMaterials[index]);
      },
    );
  }

  Widget _buildMaterialItem(BuildContext context, LearningMaterialModel model) {
    return GestureDetector(
      onTap: () => _handleNavigation(context, model),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: _buildThumbnail(model),
          title: Text(
            model.ContentDescription,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF4B39EF),
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildThumbnail(LearningMaterialModel model) {
    if (model.ThumbnailURL.isEmpty) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          model.MediaType == 'mp4' ? Icons.videocam : Icons.audiotrack,
          color: kPrimaryLightColor,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: FadeInImage(
        width: 50,
        height: 50,
        placeholder: const AssetImage('assets/images/ic_def_rhymes.png'),
        image: NetworkImage(Uri.encodeFull(model.ThumbnailURL)),
        fit: BoxFit.cover,
        imageErrorBuilder: (_, __, ___) => Image.asset(
          'assets/images/ic_def_rhymes.png',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, LearningMaterialModel model) {
    if (model.MediaType == 'mp3') {
      Get.to(() => goToAudioPlayer(
            path: model.WebUrl,
            background: model.BackgroundURL,
            Title: model.ContentDescription,
          ));
    } else if (model.MediaType == 'mp4') {
      Get.to(() => goToVideoPlayer(path: model.WebUrl, Title: model.ContentDescription));
    } else if (model.MediaType == 'pdf') {
      Get.to(() => goToMyPdf(
            worksheetUrl: model.WebUrl,
            title: model.ContentDescription,
            filename: model.ContentDescription,
            module: 'material',
          ));
    } else {
      Get.to(() => goToImageViewer(imageUrl: model.WebUrl));
    }
  }
}
