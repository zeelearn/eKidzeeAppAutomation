import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ekidzee/constants.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/pages/feedback/entity/question_entity.dart';
import 'package:ekidzee/pages/feedback/entity/submit_survey_entity.dart';
import 'package:ekidzee/pages/feedback/firestore/survey_firestore.dart';
import 'package:ekidzee/pages/feedback/survery_hive_model/survey_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:literaoctave/core/toast_utility.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api/APIService.dart';
import '../../../../helper/utils.dart';

class FeedbackController extends GetxController {
  FeedbackController({required this.surveyId, required this.userId});
  final String surveyId;
  final String userId;
  var questions = <Data>[].obs;
  final currentPage = 0.obs;
  final answers = <String, List<String>>{}.obs;

  final box = Hive.box('feedback');
  var isIntro = true.obs;
  var isCompleted = false.obs;
  var isNextEnabled = false.obs;
  var isBackEnabled = false.obs;
  var completedMessage = ''.obs;

  var isLoading = false.obs;
  set setLoading(bool value) => isLoading.value = value;
  var isVideoFinished = false.obs;
  var completedVideoQuestions = <String>{}.obs;

  var isOffline = false.obs;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _checkConnectivity();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      isOffline.value = results.contains(ConnectivityResult.none);
    });
    loadProgress();
  }

  void _checkConnectivity() async {
    var results = await Connectivity().checkConnectivity();
    isOffline.value = results.contains(ConnectivityResult.none);
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  void reset() {
    isIntro.value = true;
    isCompleted.value = false;
    completedMessage.value = '';
  }

  int getPage() {
    return (currentPage.value.toInt());
  }

  void intro() {
    currentPage.value = 0;
    isIntro.value = false;
    isNextEnabled.value = false;
  }

  Container introUI() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Icon(Icons.feedback, size: 28, color: kPrimaryLightColor),
          SizedBox(height: 12),
          Text(
            '${questions.first.title}',
            //'New Feedback Available',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          // Text(
          //   'Please fill in the ${questions.value.first.title} Survey',
          //   // 'Your feedback is important to us! A new feedback form is now available and mandatory to complete.',
          //   textAlign: TextAlign.center,
          // ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              intro();
              // Navigator.pop(context); // Close the bottom sheet
              // Get.to(() => FeedbackHome(
              //       surveyId: activeSurveyId,
              //       userId: userId,
              //     ));
            },
            icon: Icon(Icons.arrow_forward),
            label: Text('Give Feedback'),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryLightColor,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 48),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  void selectAnswer(String questionId, String option, bool selected) {
    final question =
        questions.firstWhere((q) => q.questionID?.toString() == questionId);
    if (question.questionType?.toLowerCase() == 'checkbox') {
      final existing = answers[questionId] ?? [];
      if (selected) {
        answers[questionId] = [...existing, option];
      } else {
        answers[questionId] = existing..remove(option);
      }
    } else if (question.questionType?.toLowerCase() == 'radio') {
      // Radio button logic: only one answer allowed
      answers[questionId] = [option];
    } else {
      answers[questionId] = [option];
    }
    saveProgress();
    isNextEnabled.value = true;
  }

  void nextPage() {
    final currentQuestion = questions[currentPage.value];
    final selectedAnswers = answers[currentQuestion.questionID?.toString()];

    if ((currentQuestion.isMandotry ?? false)) {
      if (selectedAnswers == null || selectedAnswers.isEmpty) {
        ToastUtility.showErrorToast('Please select the option.');
        return;
      }
    }
    if (currentPage.value < questions.length - 1) {
      currentPage.value++;
    }
    saveProgress();
    isNextEnabled.value = false;
    update();
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      isVideoFinished.value =
          true; // Assume watched if going back? Or re-verify?
      // Usually better to assume watched if they already passed it, but for simplicity:
    }
    saveProgress();
  }

  void saveProgress() {
    // Get.log(
    //     'Current answers - ${answers.toJson()} current page is - ${currentPage.value}');
    box.put('answers', answers);
    box.put('page', currentPage.value);
  }

  void loadProgress() async {
    var surveybox = Hive.box<SurveyModel>(LocalConstant.surveyBox);
    debugPrint('surveybox.values.length: ${surveybox.values.length}');
    List<SurveyModel> surveyList =
        surveybox.values.toList().cast<SurveyModel>();
    bool isOfflineExist = surveyList.any(
      (element) => element.survey_id == surveyId && element.userId == userId,
    );
    // debugPrint(surveyList.toList());
    if (isOfflineExist) {
      var json = surveyList
          .singleWhere(
            (element) =>
                element.survey_id == surveyId && element.userId == userId,
          )
          .survey_json;

      log('Offline existed json is - $json');
      if (json != null) {
        questions.value = QuestionEntity.fromJson(jsonDecode(json),
                    surveyId: int.parse(surveyId), user_id: userId)
                .data ??
            [];

        if (questions.isNotEmpty) {
          isIntro.value = (questions.first.isShowIntro ?? 0) == 1;
        }
        final savedAnswers = box.get('answers');
        final savedPage = box.get('page');
        if (savedAnswers != null)
          answers.assignAll(Map<String, List<String>>.from(savedAnswers));
        if (savedPage != null) currentPage.value = savedPage;
      } else {
        await getSurveyDataFromApi(surveybox);
        await box.clear();
      }
    } else {
      await getSurveyDataFromApi(surveybox);
      await box.clear();
    }
  }

  Future<void> getSurveyDataFromApi(Box<SurveyModel> box) async {
    var response = await APIService()
        .getSurvey(surveyId: int.parse(surveyId), userID: userId);
    response.either(
      (left) {
        Get.back(result: false);
      },
      (right) {
        if (right.data?.any(
              (element) =>
                  element.msg != null &&
                  element.msg == 'Survey already submitted!!',
            ) ??
            false) {
          Get.back(result: false);
        } else {
          box.add(SurveyModel(
              survey_id: surveyId,
              completed: false,
              userId: userId,
              survey_json: jsonEncode(right.toJson())));

          questions.value = right.data ?? [];
          if (questions.isNotEmpty) {
            isIntro.value = (questions.first.isShowIntro ?? 0) == 1;
          }
        }
      },
    );
  }

  Padding showSubmitUI() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon(Icons.feedback, size: 48, color: kPrimaryLightColor),
          // SizedBox(height: 12),
          Lottie.asset(
            height: 150,
            'assets/json/kes_done.json',
            fit: BoxFit.contain,
          ),
          SizedBox(height: 8),
          Obx(
            () => Text(
              completedMessage.value,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Get.delete<FeedbackController>();
              box.delete('answers');
              box.delete('page');
              Get.back(result: true);
            },
            icon: Icon(Icons.arrow_forward),
            label: Text('Go to Home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryLightColor,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 48),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  void submitFeedback() async {
    // 1. Validate all mandatory selected answers and mandatory videos
    for (var i = 0; i < questions.length; i++) {
      final q = questions[i];
      final sel = answers[q.questionID?.toString()];

      // Check answers
      if ((q.isMandotry ?? false) && (sel == null || sel.isEmpty)) {
        ToastUtility.showErrorToast(
            'Please select an option for question ${i + 1}.');
        currentPage.value = i; // Navigate to the missed question
        return;
      }
    }

    // Check videos
    if (!allMandatoryVideosWatched) {
      ToastUtility.showErrorToast(
          'Please watch the complete video before Submitting the Survey');
      return;
    }

    // Get.log('All the answers - ${answers.toJson()}');
    setLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
    SurveyFirestore.addCompletedSurvey(surveyId: surveyId);
    var surveybox = Hive.box<SurveyModel>(LocalConstant.surveyBox);
    surveybox
        .add(SurveyModel(survey_id: surveyId, completed: true, userId: userId));

    SubmitSurveyEntity submitSurveyEntity = SubmitSurveyEntity(
        SurveyId: int.parse(surveyId),
        answers: answers.entries
            .expand((entry) => entry.value.map(
                  (ans) => Answer(questionId: entry.key, answer: ans),
                ))
            .toList(),
        userId: userId);
    var response =
        await APIService().sumbitSurvey(submitSurveyEntity: submitSurveyEntity);
    setLoading = false;
    response.either(
      (left) {
        Utility.showMessageSingle(Get.context!, left);
      },
      (right) {
        completedMessage.value = right['data'] ?? '$right';
        isCompleted.value = true;
        update();
        // Utility.showAlertDialogWithTap(
        //   Get.context!,
        //   right['data'] != null ? right['data'] : '$right',
        //   () {
        //     box.delete('answers');
        //     box.delete('page');
        //     Get.back(result: true);
        //   },
        // );
      },
    );
  }

  bool get allMandatoryVideosWatched {
    return questions.every((q) {
      if (q.mediaType?.toLowerCase() == 'video' &&
          (q.isMediaMandotry ?? false)) {
        return completedVideoQuestions.contains(q.questionID?.toString());
      }
      return true;
    });
  }
}
