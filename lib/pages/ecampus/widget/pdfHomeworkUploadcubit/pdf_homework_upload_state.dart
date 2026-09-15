// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'pdf_homework_upload_cubit.dart';

class PdfHomeworkUploadState {
  const PdfHomeworkUploadState();
}

class PdfHomeworkUploadInitial extends PdfHomeworkUploadState {}

class PdfHomeworkUploadUpdateState extends PdfHomeworkUploadState {
  String worksheetUrl;
  String title;
  String module;
  String filename;
  MyHomeworkModel? model;
  PdfHomeworkUploadUpdateState(
    this.worksheetUrl,
    this.title,
    this.module,
    this.filename,
    this.model,
  );
}
