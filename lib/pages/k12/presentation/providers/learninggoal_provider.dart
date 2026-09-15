import 'package:ekidzee/pages/k12/data/repository/learninggoal_repository_impl.dart';
import 'package:ekidzee/pages/k12/domain/usecases/learninggoal_usecase.dart';

import '../../data/data_sources/learninggoal_datasource.dart';

class LearninggoalProvider {

    static final _dataSource = LearninggoalRemoteDatasource();
    static final _repository = LearninggoalRepositoryImpl(_dataSource);

    static final getLearningMasters = LearninggoalUsecase(_repository).getLearningMasters;

    static final getLGObservations = LearninggoalUsecase(_repository).getObservations;

    static final studentList = LearninggoalUsecase(_repository).getCompetenciesStudentList;

    static final saveStudentRating = LearninggoalUsecase(_repository).saveStudentRating;
     
}