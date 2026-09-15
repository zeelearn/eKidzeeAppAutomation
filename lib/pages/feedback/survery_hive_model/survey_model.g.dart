// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SurveyModelAdapter extends TypeAdapter<SurveyModel> {
  @override
  final int typeId = 10;

  @override
  SurveyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SurveyModel(
      survey_id: fields[0] as String,
      completed: fields[1] as bool,
      survey_json: fields[3] as String?,
      completed_date: fields[2] as String?,
      userId: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SurveyModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.survey_id)
      ..writeByte(1)
      ..write(obj.completed)
      ..writeByte(2)
      ..write(obj.completed_date)
      ..writeByte(3)
      ..write(obj.survey_json)
      ..writeByte(4)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurveyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
