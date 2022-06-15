import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/size_config.dart';
import 'package:learn_english_app/api/api_client.dart' as api_client;

class Info extends StatefulWidget {
  const Info({
    Key? key,
    required this.image,
  }) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  final image;

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  void callback() {
    setState(() {
      _BottomSheetState._imagefile = _BottomSheetState._imagefile;
    });
  }

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return SizedBox(
      height: defaultSize * 24,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShape(),
            child: Container(
              height: defaultSize * 15,
              color: kPrimaryColor,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: defaultSize * 14,
                  width: defaultSize * 14, //140
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: defaultSize * 0.8,
                    ),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _BottomSheetState._imagefile == null
                            ? NetworkImage(widget.image) as ImageProvider
                            : FileImage(
                                File(_BottomSheetState._imagefile!.path))),
                  ),
                ),
                SizedBox(
                  height: defaultSize * 4, //40
                ),
              ],
            ),
          ),
          Positioned(
            top: 160,
            right: 140,
            child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: ((builder) =>
                        BottomSheet(callback: this.callback)),
                  );
                },
                child: const Icon(Icons.camera_alt,
                    color: kPrimaryColor, size: 33.0)),
          ),
          Positioned(
            top: 180,
            right: 40,
            child: ButtonTheme(
              minWidth: 20,
              height: 20,
              // ignore: deprecated_member_use
              child: RaisedButton(
                onPressed: () {
                  api_client.putImage(
                      "PUT",
                      "/users/profile",
                      _BottomSheetState._imagefile!.path,
                      api_client.DiscardResponseContentSerializer());
                },
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class BottomSheet extends StatefulWidget {
  final VoidCallback callback;
  const BottomSheet({Key? key, required this.callback}) : super(key: key);

  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  static PickedFile? _imagefile;

  final ImagePicker _picker = ImagePicker();

  void callback() {
    setState(() {
      _imagefile = _BottomSheetState._imagefile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // ignore: deprecated_member_use
              FlatButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: const Icon(Icons.camera),
                label: const Text("Camera"),
              ),
              // ignore: deprecated_member_use
              FlatButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon: const Icon(Icons.image),
                label: const Text("Gallery"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    // ignore: deprecated_member_use
    final pickedFile = await _picker.getImage(source: source);
    setState(() {
      _imagefile = pickedFile;
    });
    widget.callback();
  }
}
