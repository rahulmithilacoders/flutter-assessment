import 'package:equatable/equatable.dart';

class StepData extends Equatable {
  final DateTime date;
  final int steps;

  const StepData({
    required this.date,
    required this.steps,
  });

  @override
  List<Object> get props => [date, steps];
}