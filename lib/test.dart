/*
Future<void> putImage<T>(String method, String path, String filepath,
    Serializer<T> serializer) async {
  await _init();

  final http.MultipartRequest request =
  http.MultipartRequest(method, Uri.parse(kApiBaseUrl + path));
  request.fields['file']='file';
  request.headers.addAll(_makeHeader());
  var picture=http.MultipartFile.fromPath('file', filepath);
  request.files.add(await picture);

  var respond = await request.send();
  var respondData = await respond.stream.toBytes();
  var result = String.fromCharCodes(respondData);
  debugPrint(result);

}

 */