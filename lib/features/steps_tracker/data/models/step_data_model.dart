import '../../domain/entities/step_data.dart';

class StepDataModel extends StepData {
  const StepDataModel({
    required super.date,
    required super.steps,
  });

  factory StepDataModel.fromEntity(StepData stepData) {
    return StepDataModel(
      date: stepData.date,
      steps: stepData.steps,
    );
  }

  StepData toEntity() {
    return StepData(
      date: date,
      steps: steps,
    );
  }
}