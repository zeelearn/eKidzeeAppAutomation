// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StatusModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StatusModelAdapter extends TypeAdapter<StatusModel> {
  @override
  final int typeId = 11;

  @override
  StatusModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StatusModel(
      programID: fields[0] as int,
      classID: fields[1] as String,
      day: fields[2] as int,
      logbookStatus: fields[3] as bool,
      className: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StatusModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.programID)
      ..writeByte(1)
      ..write(obj.classID)
      ..writeByte(2)
      ..write(obj.day)
      ..writeByte(3)
      ..write(obj.logbookStatus)
      ..writeByte(4)
      ..write(obj.className);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatusModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
