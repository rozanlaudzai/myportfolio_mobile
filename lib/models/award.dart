import 'package:json_annotation/json_annotation.dart';

part 'award.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Award {
  const Award({
    this.id,
    required this.title,
    required this.issuer,
    required this.description,
    required this.awardedAt,
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = '',
  });

  factory Award.fromJson(Map<String, dynamic> json) => _$AwardFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;
  final String title;
  final String issuer;
  final String description;

  /// DRF DateField uses a calendar date (YYYY-MM-DD).
  final String awardedAt;

  @JsonKey(includeToJson: false, defaultValue: 0)
  final int starCount;
  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isStarred;
  @JsonKey(includeToJson: false, defaultValue: '')
  final String starredByNames;

  Map<String, dynamic> toJson() => _$AwardToJson(this);
}
