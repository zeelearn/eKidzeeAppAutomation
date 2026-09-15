import 'package:bloc/bloc.dart';

import '../../../../api/response/pentemind/parent/myhomework.dart';

part 'pdf_homework_upload_state.dart';

class PdfHomeworkUploadCubit extends Cubit<PdfHomeworkUploadState> {
  PdfHomeworkUploadCubit() : super(PdfHomeworkUploadInitial());

  void updateHomework(
    String worksheetUrl,
    String title,
    String module,
    String filename,
    MyHomeworkModel? model,
  ) {
    emit(PdfHomeworkUploadUpdateState(
        worksheetUrl, title, module, filename, model));
  }
}
