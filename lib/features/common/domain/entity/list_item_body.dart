import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_item_body.g.dart';

@JsonSerializable()
class ListItemBody {
  Object value;
  String label;

  ListItemBody(this.value, this.label);

  String listItemAsString() {
    return label;
  }

  bool isEqual(ListItemBody listItem) {
    return value == listItem.value;
  }

  @override
  String toString() => label;

  factory ListItemBody.fromJson(Map<String, dynamic> json) =>
      _$ListItemBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ListItemBodyToJson(this);
}
