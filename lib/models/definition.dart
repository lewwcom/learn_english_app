import 'package:learn_english_app/api/serializer.dart';

class Definition {
  final int? id;
  String lexicalCategory;
  String meaning;
  String? _example;

  Definition(this.id, this.lexicalCategory, this.meaning, this._example);

  String? get example => _example;

  set example(String? example) =>
      _example = (example != null && example.isNotEmpty) ? example : null;

  static Map<String, String> toJson(Definition definition) => {
        "lexical_category": definition.lexicalCategory,
        "meaning": definition.meaning,
        if (definition.example != null) "example": definition.example!,
      };
}

class DefinitionSerializer implements Serializer<Definition> {
  @override
  Definition fromJsonContentKey(dynamic content) => Definition(content["id"],
      content["lexical_category"], content["meaning"], content["example"]);
}
