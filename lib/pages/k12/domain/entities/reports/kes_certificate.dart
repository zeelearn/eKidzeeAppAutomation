class KESCertificate {
  final String data;

  KESCertificate({required this.data});

  factory KESCertificate.fromJson(Map<String, dynamic> json) {
    return KESCertificate(
      data: json['data'],
    );
  }
}
