import '../repositories/attendance_repository.dart';

class GetTerms {
  final AttendanceRepository repository;

  GetTerms(this.repository);

  Future<List<String>> call() async {
    return await repository.getTerms();
  }
}
