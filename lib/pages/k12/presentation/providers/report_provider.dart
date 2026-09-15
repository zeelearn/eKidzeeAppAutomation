import 'package:ekidzee/pages/k12/data/repository/report_repository_impl.dart';

class ReportProvider {

static final _repository = ReportRepositoryImpl();

static final phases = _repository.getPhases;

static final studentList = _repository.getStudents;

static final kesCertificaet = _repository.fetchKesCertificate;

static final getStudentProfile = _repository.getStudentProfile;

static final insertStudentProfile = _repository.insertStudentProfile;

static final submitReport = _repository.insertReportAccess;
}