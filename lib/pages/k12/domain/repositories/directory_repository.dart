import 'package:ekidzee/pages/k12/data/models/directory/class_subject_model.dart';
import 'package:ekidzee/pages/k12/data/models/directory/folder_model.dart';

abstract class FolderRepository {

  Future<FoldersStructureModel> getFolders(String classId, int? subjectId, String ParentFolderName, int projectId,String userName);

  Future<ClassSubjectMasterModel> getClassesAndSubjects(String businessId, String partnerId);
}