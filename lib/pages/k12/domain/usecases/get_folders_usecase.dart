

import 'package:ekidzee/pages/k12/data/models/directory/class_subject_model.dart';
import 'package:ekidzee/pages/k12/data/models/directory/folder_model.dart';
import 'package:ekidzee/pages/k12/domain/repositories/directory_repository.dart';

class GetFoldersUseCase {
  final FolderRepository repository;

  GetFoldersUseCase(this.repository);

  Future<FoldersStructureModel> getFolders(String classId, int? subjectId,String parentFolderName ,projectId,String userName) async {
    return await repository.getFolders(classId, subjectId,parentFolderName, projectId,userName);
  }

   Future<ClassSubjectMasterModel> getClassesAndSubjects(String businessId, String partnerId) async {
    return await repository.getClassesAndSubjects(businessId, partnerId);
  }
}
