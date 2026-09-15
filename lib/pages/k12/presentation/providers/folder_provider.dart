import 'package:ekidzee/pages/k12/data/data_sources/folder_remote_data_source.dart';
import 'package:ekidzee/pages/k12/data/repository/directory_repository_impl.dart';
import 'package:ekidzee/pages/k12/domain/usecases/get_folders_usecase.dart';

class FolderStructureProvider {

static final _dataSource = FolderRemoteDataSource();
  static final _repository = FolderRepositoryImpl();

  static final getFolders = GetFoldersUseCase(_repository).getFolders;

  static final subjectMaster = GetFoldersUseCase(_repository).getClassesAndSubjects;

}