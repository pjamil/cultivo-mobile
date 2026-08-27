mixin EntidadeSerializavel {
  Map<String, dynamic> toJson();

  Map<String, dynamic> toCreateJson() => toJson();

  Map<String, dynamic> toUpdateJson() => toJson();
}
