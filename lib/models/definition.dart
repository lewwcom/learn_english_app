import 'package:learn_english_app/api/serializer.dart';

class Definition {
  final int? id;
  String? _lexicalCategory;
  String meaning;
  String? _example;

  Definition(this._lexicalCategory, this.meaning, this._example, {this.id});

  String? get lexicalCategory => _lexicalCategory;
  String? get example => _example;

  set lexicalCategory(String? lexicalCategory) =>
      _lexicalCategory = (lexicalCategory != null && lexicalCategory.isNotEmpty)
          ? lexicalCategory
          : null;

  set example(String? example) =>
      _example = (example != null && example.isNotEmpty) ? example : null;

  static Map<String, String> toJson(Definition definition) => {
        if (definition.lexicalCategory != null)
          "lexical_category": definition.lexicalCategory!,
        "meaning": definition.meaning,
        if (definition.example != null) "example": definition.example!,
      };
}

class DefinitionSerializer implements Serializer<Definition> {
  @override
  Definition fromJsonContentKey(dynamic content) => Definition(
      content["lexical_category"], content["meaning"], content["example"],
      id: content["id"]);
}
