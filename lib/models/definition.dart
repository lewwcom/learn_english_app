import 'package:collection/collection.dart';
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

class DefinitionEquality implements Equality<Definition> {
  @override
  bool equals(Definition? d1, Definition? d2) =>
      (d1 == d2) ||
      (d1 != null &&
          d2 != null &&
          d1.id == d2.id &&
          d1._lexicalCategory == d2._lexicalCategory &&
          d1.meaning == d2.meaning &&
          d1._example == d2._example);

  @override
  int hash(Definition? definition) => definition != null
      ? definition.id.hashCode +
          definition._lexicalCategory.hashCode +
          definition.meaning.hashCode +
          definition._example.hashCode
      : 0;

  @override
  bool isValidKey(Object? o) => o is Definition?;
}
