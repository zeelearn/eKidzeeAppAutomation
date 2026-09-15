// lib/presentation/providers/certificate_provider.dart

import 'package:ekidzee/pages/k12/domain/entities/reports/kes_certificate.dart';
import 'package:ekidzee/pages/k12/domain/usecases/reports_usecase.dart';
import 'package:flutter/material.dart';


class CertificateProvider with ChangeNotifier {
  final ReportsUsecase usecase;
  KESCertificate? _certificate;
  bool _isLoading = false;
  String _errorMessage = '';

  CertificateProvider({required this.usecase});

  KESCertificate? get certificate => _certificate;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> loadCertificate(int sectionId, int studentId, String phaseId, int isHtml) async {
    _isLoading = true;
    notifyListeners();

    try {
      _certificate = await usecase.getKesCertificate(sectionId, studentId, phaseId, isHtml);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _certificate = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
