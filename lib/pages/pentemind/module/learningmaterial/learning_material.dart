import 'package:ekidzee/constants.dart';
import 'package:ekidzee/videoplayer/AudioPlayer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../../../api/response/pentemind/learningmaterial/learning_material.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../app_routes.dart';
import 'learning_material_controller.dart';

class LearningMaterialScreen extends StatefulWidget {
  final bool isForNepal;
  const LearningMaterialScreen({super.key, required this.isForNepal});

  @override
  State<LearningMaterialScreen> createState() => _LearningMaterialScreenState();
}

class _LearningMaterialScreenState extends State<LearningMaterialScreen> {
  late final LearningMaterialController controller;
  late final TextEditingController _dayController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<LearningMaterialController>()) {
      Get.delete<LearningMaterialController>(force: true);
    }
    controller = Get.put(
      LearningMaterialController(isForNepal: widget.isForNepal),
      permanent: false,
    );
    _dayController = TextEditingController();
    ever(controller.currentDay, (String day) {
      if (_dayController.text != day) {
        _dayController.text = day;
      }
    });
    FirebaseAnalyticsUtils().sendAnalyticsEvent('LearningGoal:Materials');
  }

  @override
  void dispose() {
    _dayController.dispose();
    if (Get.isRegistered<LearningMaterialController>()) {
      Get.delete<LearningMaterialController>(force: true);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Obx(() {
          if (!controller.isBaseLoaded.value) {
            return Center(
              child: CircularProgressIndicator(color: kPrimaryLightColor),
            );
          }

          return RefreshIndicator(
            color: Colors.white,
            backgroundColor: kPrimaryLightColor,
            strokeWidth: 3,
            onRefresh: () => controller.refreshData(),
            child: _buildBody(),
          );
        }),
      ),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      final isLoading =
          controller.isLoading.value && controller.materialList.isEmpty;

      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          if (controller.isDownloadingAll.value)
            SliverToBoxAdapter(child: _downloadProgressBanner()),
          if (isLoading)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Lottie.asset('assets/json/kidzee_loader.json'),
              ),
            )
          else if (controller.materialList.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmptyState(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
              sliver: Obx(
                () => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final model = controller.materialList[index];
                      var materialId = model.RefKey.toString();
                      if (materialId.isEmpty) {
                        materialId = model.ContentDescription;
                      }
                      final isDownloaded =
                          controller.fileStatusMap[materialId] ?? false;
                      return MaterialRow(
                        model: model,
                        controller: controller,
                        isDownloaded: isDownloaded,
                        index: index,
                      );
                    },
                    childCount: controller.materialList.length,
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Learning Materials',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Obx(() {
                  if (controller.culminationName.value.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: kPrimaryLightColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      controller.culminationName.value,
                      style: GoogleFonts.roboto(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryLightColor,
                      ),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _categoryDropdown()),
                Obx(() {
                  if (controller.selectedCategory.value != 'Critcal Thinking') {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SizedBox(
                      width: 72,
                      child: TextField(
                        controller: _dayController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          labelText: 'Day',
                          filled: true,
                          fillColor: const Color(0xFFF3F5FA),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (val) => controller.updateDay(val),
                      ),
                    ),
                  );
                }),
                Obx(() {
                  if (!(controller.materialList.isNotEmpty &&
                      controller.isPrintCategory)) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: _downloadAllButton(),
                  );
                }),
              ],
            ),
            Obx(() {
              if (controller.selectedCategory.value == 'Select Category' ||
                  controller.materialList.isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  '${controller.materialList.length} item${controller.materialList.length == 1 ? '' : 's'}'
                  '${controller.isPrintCategory ? ' · Tap download to save PDF' : ''}',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _categoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: Obx(
          () => DropdownButton<String>(
            value: controller.selectedCategory.value,
            isExpanded: true,
            icon: Icon(Icons.keyboard_arrow_down, color: kPrimaryLightColor),
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            items: controller.categoryOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) controller.updateCategory(val);
            },
          ),
        ),
      ),
    );
  }

  Widget _downloadAllButton() {
    return Material(
      color: kPrimaryLightColor.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: controller.isDownloadingAll.value
            ? null
            : () => controller.downloadAll(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: controller.isDownloadingAll.value
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: kPrimaryLightColor,
                    strokeWidth: 2.5,
                    value: controller.downloadProgress.value > 0
                        ? controller.downloadProgress.value
                        : null,
                  ),
                )
              : Icon(Icons.download_rounded,
                  color: kPrimaryLightColor, size: 22),
        ),
      ),
    );
  }

  Widget _downloadProgressBanner() {
    return Obx(() {
      final progress = controller.downloadProgress.value;
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0FE),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: kPrimaryLightColor,
                  value: progress > 0 ? progress : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  progress > 0
                      ? 'Downloading… ${(progress * 100).toInt()}%'
                      : 'Preparing downloads…',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: kPrimaryLightColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    final waitingForCategory =
        controller.selectedCategory.value == 'Select Category';
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            waitingForCategory
                ? Icons.category_outlined
                : Icons.folder_open_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            waitingForCategory ? 'Select a category' : 'No materials found',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            waitingForCategory
                ? 'Choose a category above to view learning materials.'
                : 'Try another category or pull to refresh.',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class MaterialRow extends StatelessWidget {
  final LearningMaterialModel model;
  final LearningMaterialController controller;
  final bool isDownloaded;
  final int index;

  const MaterialRow({
    super.key,
    required this.model,
    required this.controller,
    required this.isDownloaded,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final typeLabel = _typeLabel(model.MediaType);
    final typeColor = _typeColor(model.MediaType);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _handleItemClick(context),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: !controller.isPrintCategory && isDownloaded
                    ? Colors.blue.shade100
                    : Colors.grey.shade200,
              ),
              color: !controller.isPrintCategory && isDownloaded
                  ? const Color(0xFFF5F9FF)
                  : Colors.white,
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildLeading(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.ContentDescription,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _chip(
                            label: typeLabel,
                            color: typeColor,
                            icon: _typeIcon(model.MediaType),
                          ),
                          if (!controller.isPrintCategory && isDownloaded) ...[
                            const SizedBox(width: 6),
                            _chip(
                              label: 'Offline',
                              color: Colors.green.shade700,
                              icon: Icons.offline_pin,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (controller.isPrintCategory)
                  _buildPrintAction()
                else
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey.shade400,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeading() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5FA),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: controller.isPrintCategory
          ? Center(child: _buildTypeIcon(size: 28))
          : _buildThumbnail(),
    );
  }

  Widget _buildThumbnail() {
    if (model.ThumbnailURL.isEmpty) {
      return Center(child: _buildTypeIcon(size: 28));
    }
    return FadeInImage(
      width: 52,
      height: 52,
      placeholder: const AssetImage('assets/images/ic_def_rhymes.png'),
      image: NetworkImage(Uri.encodeFull(model.ThumbnailURL)),
      imageErrorBuilder: (context, error, stackTrace) => Center(
        child: _buildTypeIcon(size: 28),
      ),
      fit: BoxFit.cover,
    );
  }

  Widget _buildTypeIcon({double size = 28}) {
    return Image.asset(
      controller.getMediaTypeAsset(model.MediaType),
      height: size,
      width: size,
    );
  }

  Widget _chip({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrintAction() {
    if (model.MediaType == 'mp4') {
      return Icon(Icons.play_circle_outline,
          color: kPrimaryLightColor, size: 28);
    }

    if (kIsWeb) {
      return _actionButton(
        icon: Icons.download_rounded,
        color: kPrimaryLightColor,
        background: kPrimaryLightColor.withValues(alpha: 0.12),
        onTap: () => controller.downloadPrintFile(model),
      );
    }

    return Obx(() {
      final isDownloaded = index < controller.printDownloadStatus.length &&
          controller.printDownloadStatus[index];

      return _actionButton(
        icon: isDownloaded ? Icons.share_rounded : Icons.download_rounded,
        color: isDownloaded ? Colors.green.shade700 : kPrimaryLightColor,
        background: isDownloaded
            ? Colors.green.withValues(alpha: 0.12)
            : kPrimaryLightColor.withValues(alpha: 0.12),
        onTap: () {
          if (isDownloaded) {
            controller.sharePrintFile(model);
          } else {
            controller.downloadPrintFile(model);
          }
        },
      );
    });
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required Color background,
    required VoidCallback onTap,
  }) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }

  String _typeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'mp3':
        return 'Audio';
      case 'mp4':
        return 'Video';
      case 'pdf':
        return 'PDF';
      case 'image':
        return 'Image';
      default:
        return type.isEmpty ? 'File' : type.toUpperCase();
    }
  }

  Color _typeColor(String type) {
    switch (type.toLowerCase()) {
      case 'mp3':
        return Colors.orange.shade700;
      case 'mp4':
        return Colors.purple.shade600;
      case 'pdf':
        return Colors.red.shade600;
      case 'image':
        return Colors.teal.shade600;
      default:
        return kPrimaryLightColor;
    }
  }

  IconData _typeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'mp3':
        return Icons.audiotrack_rounded;
      case 'mp4':
        return Icons.videocam_rounded;
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'image':
        return Icons.image_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Future<void> _handleItemClick(BuildContext context) async {
    //if (controller.isPrintCategory) {
    if (model.MediaType == 'mp4') {
      final localPath = await controller.getLocalPath(model);
      final path = localPath ?? model.WebUrl;
      Get.to(
          () => goToVideoPlayer(path: path, Title: model.ContentDescription));
      return;
    }
    //   await controller.downloadPrintFile(model);
    //   return;
    // }

    final localPath = await controller.getLocalPath(model);
    final effectivePath = localPath ?? model.WebUrl;

    if (model.MediaType == 'mp3') {
      Get.to(() => AudioPlayer(
            path: effectivePath,
            background: model.BackgroundURL,
            Title: model.ContentDescription,
          ));
    } else if (model.MediaType == 'mp4') {
      Get.to(() => goToVideoPlayer(
            path: effectivePath,
            Title: model.ContentDescription,
          ));
    } else if (model.MediaType == 'pdf') {
      Get.to(() => goToMyPdf(
            worksheetUrl: effectivePath,
            title: model.ContentDescription,
            filename: model.ContentDescription,
            module: 'material',
          ));
    } else if (_isImage(model.MediaType, model.WebUrl)) {
      Get.to(() => goToImageViewer(imageUrl: effectivePath));
    }
  }

  bool _isImage(String type, String url) {
    return type == 'image' ||
        url.toLowerCase().contains('.png') ||
        url.toLowerCase().contains('.jpg') ||
        url.toLowerCase().contains('.jpeg');
  }
}
