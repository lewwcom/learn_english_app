import '../api/serializer.dart';

class VisionRespone {
  String? content;

  VisionRespone({this.content});

  VisionRespone.fromJson(Map<String, dynamic> json) {
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    return data;
  }
}

class VisionSerializer implements Serializer<VisionRespone> {
  @override
  VisionRespone fromJsonContentKey(content) {
    print(content.toString());
    VisionRespone visionRespone = VisionRespone(content: content.toString());
    //print(visionRespone.toJson());
    return visionRespone;
  }
}

