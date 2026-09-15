import 'package:ekidzee/pages/k12/domain/entities/reports/phase.dart';

class LogbookUsecase {
  final LogbookUsecase repository;

  LogbookUsecase(this.repository);

  Future<List<ReportPhase>> getLogbook(String date) {
    return repository.getLogbook(date);
  }
}
