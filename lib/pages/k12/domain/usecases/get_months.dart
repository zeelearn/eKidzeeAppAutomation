import '../repositories/attendance_repository.dart';

class GetMonths {
  final AttendanceRepository repository;

  GetMonths(this.repository);

  Future<List<String>> call() async {
    try {
      // Fetch the list of months from the repository
      final months = await repository.getMonths();
      return months;
    } catch (e) {
      // Handle any errors that may occur and rethrow or return a default value
      // For example, you might rethrow the error or handle it accordingly
      throw Exception('Failed to get months: $e');
    }
  }
}
