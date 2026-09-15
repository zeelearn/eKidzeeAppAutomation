import 'dart:convert';

class SubmitSurveyEntity {
  String userId;
  int SurveyId;
  List<Answer> answers;

  SubmitSurveyEntity(
      {required this.userId, required this.SurveyId, required this.answers});

  String toMap() => jsonEncode({
        'UserID': userId,
        'SurveyID': SurveyId,
        'Answers': answers
            .map(
              (e) => {'questionId': e.questionId, 'answer': e.answer},
            )
            .toList()
      });
}

class Answer {
  String questionId;
  String answer;
  Answer({required this.questionId, required this.answer});
}
