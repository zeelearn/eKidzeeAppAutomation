import 'package:ekidzee/pages/feedback/presentation/controller/feedback_controller.dart';
import 'package:ekidzee/pages/feedback/presentation/widgets/feedback_media_widget.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppFeedbackScreen extends StatefulWidget {
  const AppFeedbackScreen(
      {required this.surveyId, required this.userId, super.key});
  final String surveyId;
  final String userId;

  @override
  State<AppFeedbackScreen> createState() => _FeedbackHomeState();
}

class _FeedbackHomeState extends State<AppFeedbackScreen> {
  @override
  void dispose() {
    Get.delete<FeedbackController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
        FeedbackController(surveyId: widget.surveyId, userId: widget.userId));
    /*  Future.delayed(Duration(milliseconds: 1000), () async {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }); */
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        // if (didPop) return;
        // ToastUtility.showWarning(msg: 'Please Complete Feedback');
      },
      child: Obx(() {
        final content = () {
          if (controller.questions.isEmpty) {
            return IntrinsicHeight(
              child: const Center(
                child: CircularProgressIndicator(
                  padding: EdgeInsets.all(24),
                ),
              ),
            );
          }
          if (controller.isIntro.value) {
            controller.currentPage.value = 0;
            return controller.introUI();
          } else if (controller.isCompleted.value) {
            return controller.showSubmitUI();
          } else {
            final q = controller.questions[controller.currentPage.value];
            final selected = controller.answers[q.questionID.toString()] ?? [];
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: LightColors.kLightGrayM,
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${controller.questions.value.first.title}',
                          style: LightColors.textHeaderStyle13,
                        ),
                        Text(
                          '${controller.getPage() + 1} / ${controller.questions.length}',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  FeedbackMediaWidget(
                    url: controller.questions.first.mediaURL,
                    type: controller.questions.first.mediaType,
                    isMandatory:
                        controller.questions.first.isMediaMandotry ?? false,
                    onVideoFinished: () {
                      for (int i = 0; i < controller.questions.length; i++) {
                        controller.completedVideoQuestions.add(
                            controller.questions[i].questionID?.toString() ??
                                '');
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                                text: ' ${q.questionText ?? ''}',
                                style: LightColors.textHeaderStyle13.copyWith(
                                  fontSize: 18,
                                ))
                          ],
                          text: ' ${(q.isMandotry ?? false) ? '*' : ''}',
                          style: LightColors.textHeaderStyle13
                              .copyWith(fontSize: 18, color: Colors.red)),
                    ),
                  ),
                  ...q.options?.map((option) => q.questionType?.toLowerCase() ==
                              'checkbox'
                          ? CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(option.optionText ?? '',
                                  style: LightColors.textHeaderStyle13.copyWith(
                                    fontSize: 18,
                                  )),
                              value: selected.contains(option.optionText),
                              onChanged: (val) => controller.selectAnswer(
                                  q.questionID?.toString() ?? '0',
                                  option.optionText ?? '',
                                  val!),
                            )
                          : RadioListTile<String>(
                              title: Text(
                                option.optionText ?? '',
                                style: LightColors.textHeaderStyle13.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                              value: option.optionText ?? '',
                              groupValue:
                                  selected.isEmpty ? null : selected.first,
                              onChanged: (val) => controller.selectAnswer(
                                  q.questionID?.toString() ?? '0', val!, true),
                            )) ??
                      [],
                  controller.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    controller.currentPage.value > 0
                                        ? MainAxisAlignment.spaceBetween
                                        : MainAxisAlignment.end,
                                children: [
                                  if (controller.currentPage.value > 0)
                                    ElevatedButton(
                                        onPressed: controller.previousPage,
                                        child: Text(
                                          'Previous',
                                          style:
                                              LightColors.textHeaderStyleWhite,
                                        )),
                                  if (controller.currentPage.value <
                                      controller.questions.length - 1)
                                    ElevatedButton(
                                        onPressed: controller.nextPage,
                                        child: Text(
                                          'Next',
                                          style:
                                              LightColors.textHeaderStyleWhite,
                                        ))
                                  else
                                    ElevatedButton(
                                        onPressed:
                                            controller.allMandatoryVideosWatched
                                                ? controller.submitFeedback
                                                : null,
                                        child: Text(
                                          'Submit',
                                          style:
                                              LightColors.textHeaderStyleWhite,
                                        )),
                                ],
                              ),
                              controller.allMandatoryVideosWatched ||
                                      controller.currentPage.value <
                                          controller.questions.length - 1
                                  ? const SizedBox.shrink()
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Please watch full videos to enable submission.',
                                        style:
                                            LightColors.textSmallHightliteStyle,
                                      ),
                                    )
                            ],
                          ),
                        ),
                ],
              ),
            );
          }
        }();

        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: controller.isOffline.value ? 300 : 0,
          ),
          child: Stack(
            children: [
              content,
              if (controller.isOffline.value)
                Positioned.fill(
                  child: OfflineOverlay(
                    onClose: () => Get.back(),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
