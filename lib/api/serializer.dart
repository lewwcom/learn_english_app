abstract class Serializer<T> {
  T fromJsonContentKey(dynamic content);
}

class ListSerializer<T> implements Serializer<List<T>> {
  final Serializer<T> _serializer;

  ListSerializer(this._serializer);

  @override
  List<T> fromJsonContentKey(content) {
    return (content as List<dynamic>)
        .map((element) => _serializer.fromJsonContentKey(element))
        .toList();
  }
}
