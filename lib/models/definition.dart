import 'package:learn_english_app/api/serializer.dart';

class Definition {
  final String lexicalCategory;
  final String meaning;
  final String? example;

  Definition(this.lexicalCategory, this.meaning, this.example);
}

class DefinitionSerializer implements Serializer<Definition> {
  @override
  Definition fromJsonContentKey(dynamic content) => Definition(
      content["lexical_category"], content["meaning"], content["example"]);
}
