import 'package:bloc/bloc.dart';
import 'package:ekidzee/api/APIService.dart';
import 'package:ekidzee/pages/tracker_indent/model/TrackerIndent.dart';
import 'package:ekidzee/pages/tracker_indent/model/TrackerRequest.dart';
import 'package:equatable/equatable.dart';

part 'tracker_order_state.dart';

class TrackerOrderCubit extends Cubit<TrackerOrderState> {
  TrackerOrderCubit() : super(TrackerOrderInitial());

  void getTrackerIndent(TrackerRequest trackerRequest) async {
    emit(TrackerOrderLoadingState());
    var response = await APIService().getTrackerIndent(trackerRequest);
    if (response.error != null) {
      emit(TrackerOrderErrorState(error: response.error!));
    } else {
      emit(TrackerOrderSuccessState(trackerIndent: response));
    }
  }

  void getTrackerIndentDetails(String indentNo) async {
    emit(IndentOrderDetailLoadingState());
    var response = await APIService().getIndentDetails(indentNo);
    if (response.error != null) {
      emit(IndentOrderDetailErrorState(error: response.error!));
    } else {
      emit(IndentOrderDetailSuccessState(indents: response));
    }
  }
}
