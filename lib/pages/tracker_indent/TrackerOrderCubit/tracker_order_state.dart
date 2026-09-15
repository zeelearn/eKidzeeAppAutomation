// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'tracker_order_cubit.dart';

class TrackerOrderState extends Equatable {
  const TrackerOrderState();

  @override
  List<Object> get props => [];
}

class TrackerOrderInitial extends TrackerOrderState {}

class TrackerOrderLoadingState extends TrackerOrderState {}

class TrackerOrderErrorState extends TrackerOrderState {
  final String error;
  const TrackerOrderErrorState({
    required this.error,
  });
}

class TrackerOrderSuccessState extends TrackerOrderState {
  final TrackerIndent trackerIndent;
  const TrackerOrderSuccessState({
    required this.trackerIndent,
  });
}

class IndentOrderDetailLoadingState extends TrackerOrderState {}

class IndentOrderDetailSuccessState extends TrackerOrderState {
  final Indents indents;

  const IndentOrderDetailSuccessState({required this.indents});
}

class IndentOrderDetailErrorState extends TrackerOrderState {
  final String error;

  const IndentOrderDetailErrorState({required this.error});
}
