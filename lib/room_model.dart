import 'package:json_annotation/json_annotation.dart';

part 'room_model.g.dart';

int _parseInt(dynamic value) {
  if (value == null) return 0;
  return int.tryParse(value.toString()) ?? 0;
}

String _parseString(dynamic value) {
  return value?.toString() ?? '';
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  return double.tryParse(value.toString()) ?? 0.0;
}

@JsonSerializable()
class RoomModel {
  @JsonKey(name: 'listing_id', fromJson: _parseInt) // Sửa thành listing_id
  final int id;

  @JsonKey(fromJson: _parseString)
  final String title;

  @JsonKey(fromJson: _parseString)
  final String address;

  @JsonKey(fromJson: _parseDouble) // Sửa thành double
  final double price;

  @JsonKey(name: 'image_url', fromJson: _parseString)
  final String imageUrl;

  RoomModel({
    required this.id,
    required this.title,
    required this.address,
    required this.price,
    required this.imageUrl,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => _$RoomModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoomModelToJson(this);
}