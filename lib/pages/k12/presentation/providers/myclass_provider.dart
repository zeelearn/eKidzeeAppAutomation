import 'package:ekidzee/pages/k12/data/repository/myclass_repository_impl.dart';
import 'package:ekidzee/pages/k12/data/repository/report_repository_impl.dart';

class MyClassProvider {

static final _repository = MyclassRepositoryImpl();

static final terms = _repository.getTerms;


static final studentAttandance = _repository.getStudentAttendance;

static final attandanceCalender = _repository.getAttandanceCalender;

static final saveAttandacne = _repository.saveAttendance;

}