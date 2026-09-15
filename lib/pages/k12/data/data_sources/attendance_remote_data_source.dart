class AttendanceRemoteDataSource {
  Future<List<String>> fetchTerms() async {
    // Simulate network call
    await Future.delayed(Duration(seconds: 1));
    return ['Term 1', 'Term 2', 'Term 3'];
  }

  Future<List<String>> fetchMonths() async {
    // Simulate network call
    await Future.delayed(Duration(seconds: 1));
    return ['January', 'February', 'March'];
  }

  Future<Map<String, bool>> fetchAttendanceDays(String term, String month) async {
    // Simulate network call
    await Future.delayed(Duration(seconds: 1));
    return {
      '2024-01-01': true,
      '2024-01-02': false,
      // More dates...
    };
  }

  Future<Map<String, bool>> fetchStudentAttendance(String date) async {
    // Simulate network call
    await Future.delayed(Duration(seconds: 1));
    return {
      'Student 1': true,
      'Student 2': false,
      // More students...
    };
  }
}