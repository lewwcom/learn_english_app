import 'package:learn_english_app/models/serializer.dart';

class Definition {
  final String lexicalCategory;
  final String meaning;
  final String? example;

  Definition(this.lexicalCategory, this.meaning, this.example);
}

class DefinitionSerializer implements Serializer<Definition> {
  @override
  Definition fromJson(Map<String, dynamic> json) =>
      Definition(json["lexical_category"], json["meaning"], json["example"]);
}
