import 'dart:io';

import 'package:ekidzee/api/request/bpms/franchisee_details_request.dart';
import 'package:ekidzee/api/request/bpms/getTaskDetailsRequest.dart';
import 'package:ekidzee/api/request/bpms/get_task_comments.dart';
import 'package:ekidzee/api/request/bpms/insert_attachment.dart';
import 'package:ekidzee/api/request/bpms/update_task.dart';
import 'package:ekidzee/api/request/celibration/celibration_request.dart';
import 'package:ekidzee/api/request/fcmRequest.dart';
import 'package:ekidzee/api/request/induction/franchisee/induction_approve_request.dart';
import 'package:ekidzee/api/request/induction/teacher/enroll_request.dart';
import 'package:ekidzee/api/request/induction/teacher/induction_status_request.dart';
import 'package:ekidzee/api/request/pentemind/myclass/day_calendar.dart';
import 'package:ekidzee/api/response/academic_year.dart';
import 'package:ekidzee/api/response/bpms/franchisee_details_response.dart';
import 'package:ekidzee/api/response/bpms/getTaskDetailsResponseModel.dart';
import 'package:ekidzee/api/response/bpms/get_comments_response.dart';
import 'package:ekidzee/api/response/bpms/insert_attachment_response.dart';
import 'package:ekidzee/api/response/bpms/update_task_response.dart';
import 'package:ekidzee/api/response/celibration/zll_celibration_response.dart';
import 'package:ekidzee/api/response/induction/franchisee/approval_response.dart';
import 'package:ekidzee/api/response/induction/franchisee/enrolled_teacher_response.dart';
import 'package:ekidzee/api/response/induction/teacher/EnrollmentResponse.dart';
import 'package:ekidzee/api/response/induction/teacher/induction_status_response.dart';
import 'package:ekidzee/api/response/pentemind/myclass/day_calender.dart';
import 'package:flutter/material.dart';

import '../iface/onResponse.dart';
import 'APIService.dart';

class ApiServiceHandler {
  static int API_ACADEMIC_YEARS = 1;
  static int API_APPROVE_RESPONSE = 2;
  static int API_INDUCTION_REQUEST = 3;

  void loadAcademicYears(onResponse response) {
    APIService apiService = APIService();
    response.onResponseStart();
    apiService.getAcademicYear().then((value) {
      if (value != null) {
        AcademicYearInfo academicYearInfo;
        academicYearInfo = value;
        response.onSuccess(academicYearInfo);
      } else {
        response.onError(API_ACADEMIC_YEARS,
            'Unable to get the Academic Years Please try again later');
      }
    });
  }

  void loadTaskDetails(
      GetTaskDetailsRequest requestModel, onResponse response) {
    APIService apiService = APIService();
    response.onResponseStart();
    apiService.getTaskDetails(requestModel).then((value) {
      if (value != null) {
        GetTaskDetailsResponseModel responseModel;
        if (value != null) {
          responseModel = value;
          response.onSuccess(responseModel);
        } else {
          response.onError(
              400, 'Unable to get the Task Details Please try again later');
        }
      } else {
        response.onError(
            400, 'Unable to get the Task Details Please try again later');
      }
    });
  }

  void updateTaskDetails(UpdateBpmsTaskRequest requestModel,
      bool isLoadingRequired, onResponse response) {
    APIService apiService = APIService();
    if (isLoadingRequired) {
      response.onResponseStart();
    }
    debugPrint(requestModel.status);
    apiService.updateTaskDetails(requestModel).then((value) {
      if (value != null) {
        //debugPrint(value);
        UpdateBpmsTaskResponse responseModel;
        if (value != null) {
          responseModel = value;
//           debugPrint('update bpms ${responseModel.toJson()}');
          response.onSuccess(responseModel);
        } else {
//           debugPrint('Unable to update Task');
          response.onError(
              400, 'Unable to update the Task Details Please try again later');
        }
      } else {
//         debugPrint('Unable to update Task else');
        response.onError(
            400, 'Unable to Update the Task Details Please try again later');
      }
    });
  }

  void getTaskComments(
      GetTaskCommentRequest requestModel, onResponse response) {
    APIService apiService = APIService();
    response.onResponseStart();
    apiService.getTaskComments(requestModel).then((value) {
      if (value != null) {
        GetCommentResponse responseModel;
        if (value != null) {
          responseModel = value;
          response.onSuccess(responseModel);
        } else {
          response.onError(
              400, 'Unable to update the Task Details Please try again later');
        }
      } else {
        response.onError(
            400, 'Unable to Update the Task Details Please try again later');
      }
    });
  }

  void insertTaskAttachment(
      InsertTaskAttachmentRequest requestModel, onResponse response) {
    APIService apiService = APIService();
    response.onResponseStart();
    apiService.insertTaskAttachment(requestModel).then((value) {
      if (value != null) {
        InsertTaskAttachmentResponse responseModel;
        if (value != null) {
          responseModel = value;
          response.onSuccess(responseModel);
        } else {
          response.onError(400,
              'Unable to update the Task File Upload Please try again later');
        }
      } else {
        response.onError(400,
            'Unable to Update the Task File Upload Please try again later');
      }
    });
  }

  void getFranchiseeDetails(
      GetFranchiseeDetailsRequest requestModel, onResponse response) {
    APIService apiService = APIService();
    response.onResponseStart();
//     debugPrint('getFranchiseeDetails......');
    apiService.getFranDetails(requestModel).then((value) {
//       debugPrint('getFranDetails....$value..');
      if (value != null && value is GetFranchiseeDetailsResponse) {
        GetFranchiseeDetailsResponse responseModel;
        responseModel = value;
        response.onSuccess(responseModel);
//         debugPrint('SUCCESS it\'s  working......');
      } else {
        response.onError(400,
            'Unable to Update the Task File Upload Please try again later');
      }
    });
  }

  void getCalendarDay(GetDayCalenderRequest requestModel, onResponse response) {
    APIService apiService = APIService();
    response.onResponseStart();
    apiService.getDayCalendar(requestModel).then((value) {
      if (value != null) {
        DayCalenderResponse responseModel;
        if (value != null) {
          responseModel = value;
          response.onSuccess(responseModel);
        } else {
          response.onError(
              400, 'Unable to get the Data, plese try again later');
        }
      } else {
        response.onError(400,
            'Unable to Update the Task File Upload Please try again later');
      }
    });
  }

  void updateFCM(UpdateFcmRequest requestModel, onResponse response) {
    debugPrint(
        'in UPDATE FCM token response 181 ${requestModel.toJson().toString()}');
    APIService apiService = APIService();
    response.onResponseStart();
    apiService.updateFCM(requestModel).then((value) {
      if (value != null) {
        debugPrint('in UPDATE FCM token response 186 ${value.toString()}');
        String responseModel;
        if (value != null) {
          try {
            responseModel = value;
            response.onSuccess(responseModel);
          } catch (e) {}
        } else {
          response.onError(
              400, 'Unable to get the Data, plese try again later');
        }
      } else {
        response.onError(400,
            'Unable to Update the Task File Upload Please try again later');
      }
    });
  }

  /// This API use to get list to avaliable induction requests
  /// It may be already approve/reject or the status is pending
  ///
  void loadInductionRequests(
      onResponse response, String franchinseeId, String year) {
    //debugPrint('load Induction');
    APIService apiService = APIService();
    response.onResponseStart();
    apiService.loadInductionRequests(franchinseeId, year).then((value) {
      if (value != null) {
        //debugPrint('in serviceHandler ${value.toString()}');
        //debugPrint(value.toJson());
        //inductionRequestList = value as List<InductionListResponseModel>;
        EnrolledTeacherList inductionResponse = value;
        //debugPrint(inductionResponse.toJson());
        response.onSuccess(inductionResponse);
      } else {
        response.onError(API_INDUCTION_REQUEST,
            'Unable to get the Induction List Please try again later');
      }
    });
  }

  void approveInduction(
      ApproveInductionRequestModel requestModel, onResponse response) {
    //debugPrint('load Induction');
    APIService apiService = APIService();
    response.onResponseStart();
    //debugPrint(requestModel.getJson());
    apiService.approveInduction(requestModel).then((value) {
      if (value != null) {
        //debugPrint('in serviceHandler ${value.toString()}');
        //debugPrint(value.toJson());
        //inductionRequestList = value as List<InductionListResponseModel>;
        InductionApprovalResponse approvalResponse = value;
        //debugPrint(approvalResponse.toJson());
        response.onSuccess(approvalResponse);
      } else {
        response.onError(API_APPROVE_RESPONSE,
            'Unable to get the Induction List Please try again later');
      }
    });
  }

  void enrollmentStatus(
      InductionStatusRequest requestModel, onResponse response) {
    //debugPrint('load Induction');
    APIService apiService = APIService();
    response.onResponseStart();
    //debugPrint(requestModel.getJson());
    apiService.enrollmentStatus(requestModel).then((value) {
      if (value != null) {
        //debugPrint('in serviceHandler ${value.toString()}');
        //debugPrint(value.toJson());
        //inductionRequestList = value as List<InductionListResponseModel>;
        InductionStatusResponse approvalResponse = value;
        //debugPrint(approvalResponse.toJson());
        response.onSuccess(approvalResponse);
      } else {
        response.onError(API_APPROVE_RESPONSE,
            'Unable to get the Induction List Please try again later');
      }
    });
  }

  void enroll(EnrollRequest requestModel, onResponse response) {
    //debugPrint('load Induction enroll');
    APIService apiService = APIService();
    response.onResponseStart();
    //debugPrint(requestModel.getJson());
    apiService.enrollRequest(requestModel).then((value) {
      if (value != null) {
        //debugPrint('in serviceHandler ${value.toString()}');
        //debugPrint(value.toJson());
        //inductionRequestList = value as List<InductionListResponseModel>;
        EnrollmentResponse approvalResponse = value;
        approvalResponse.Status = 'SUCCESS';
        //debugPrint(approvalResponse.toJson());
        response.onSuccess(approvalResponse);
      } else {
        response.onError(API_APPROVE_RESPONSE,
            'Unable to get the Induction List Please try again later');
      }
    });
  }

  void getInductionDetail(String userId, onResponse response) {
    //debugPrint('load Induction enroll');
    APIService apiService = APIService();
    response.onResponseStart();
    apiService.getInductionDetail(userId).then((value) {
      if (value != null) {
        //debugPrint('in serviceHandler ${value.toString()}');
        //debugPrint(value.toJson());
        response.onSuccess(value);
      } else {
        response.onError(API_APPROVE_RESPONSE,
            'Unable to get the Induction List Please try again later');
      }
    });
  }

  void getInductionStatus(String userId, onResponse response) {
    //debugPrint('load Induction enroll');
    APIService apiService = APIService();
    response.onResponseStart();
    apiService.getInductionStatus(userId).then((value) {
      if (value != null) {
        //debugPrint('in serviceHandler ${value.toString()}');
        //debugPrint(value.toJson());
        response.onSuccess(value);
      } else {
        response.onError(API_APPROVE_RESPONSE,
            'Unable to get the Induction List Please try again later');
      }
    });
  }

  void GetInductionProgramDayModules(
      String userId, int day, onResponse response) {
    //debugPrint('load Induction enroll');
    APIService apiService = APIService();
    response.onResponseStart();
    apiService.getInductionDayModule(userId, day).then((value) {
      if (value != null) {
        //debugPrint('in serviceHandler ${value.toString()}');
        //debugPrint(value.toJson());
        response.onSuccess(value);
      } else {
        response.onError(API_APPROVE_RESPONSE,
            'Unable to get the Induction List Please try again later');
      }
    });
  }

  void getContent(String userId, int day, int module, onResponse response) {
    //debugPrint('load Induction enroll');
    APIService apiService = APIService();
    response.onResponseStart();
    apiService.getInductionContnet(userId, day, module).then((value) {
      if (value != null) {
        //debugPrint('in serviceHandler ${value.toString()}');
        //debugPrint(value.toJson());
        response.onSuccess(value);
      } else {
        response.onError(API_APPROVE_RESPONSE,
            'Unable to get the Induction List Please try again later');
      }
    });
  }

  void insertInductionAccessLog(
      String userId, String contentId, String type, onResponse response) {
    //debugPrint('load Induction enroll ${userId} ${contentId} ${type}');
    APIService apiService = APIService();
    response.onResponseStart();
    apiService.getInductionContnetView(userId, contentId, type).then((value) {
      if (value != null) {
        //debugPrint('in serviceHandler ${value.toString()}');
        //debugPrint(value.toJson());
        response.onSuccess(value);
      } else {
        response.onError(API_APPROVE_RESPONSE,
            'Unable to get the Induction List Please try again later');
      }
    });
  }

  // void getNews(GetNewsRequest request, onResponse response) {
  //   APIService apiService = APIService();
  //   response.onStart();
  //   apiService.getNews(request).then((value) {
  //     if (value != null) {
  //       //debugPrint('in news serviceHandler ${value.toString()}');
  //       //debugPrint(value.toJson());
  //       response.onSuccess(value);
  //     } else {
  //       response.onError(API_APPROVE_RESPONSE, 'Unable to get the News');
  //     }
  //   });
  // }

  void getCelibration(CelibrationRequest request, onResponse response) {
    APIService apiService = APIService();
    response.onResponseStart();
    debugPrint('in getCelibration');
    apiService.getCelibrationEvents(request).then((value) {
      if (value != null) {
        debugPrint('in getCelibration respons e');
        debugPrint(value);
        ZllResourceResponse responseModel;
        if (value != null) {
          responseModel = value;
          response.onSuccess(responseModel);
        } else {
          response.onError(
              400, 'Unable to get the Data, plese try again later');
        }
      } else {
        response.onError(400,
            'Unable to Update the Task File Upload Please try again later');
      }
    });
  }

  // void getHelpdek(HelpdeskRequest request, onResponse response) {
  //   APIService apiService = APIService();
  //   response.onStart();
  //   apiService.getHelpdeskList(request).then((value) {
  //     if (value != null) {
  //       //debugPrint('in getHelpdek serviceHandler ${value.toString()}');
  //       //debugPrint(value.toJson());
  //       response.onSuccess(value);
  //     } else {
  //       response.onError(API_APPROVE_RESPONSE, 'Unable to get the Helpdek');
  //     }
  //   });
  // }
}

//import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);

    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      return true; // ⚠️ Development only
    };

    return client;
  }
}
