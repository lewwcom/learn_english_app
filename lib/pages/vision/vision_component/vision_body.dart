// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/services/api_vision.dart';
import 'package:learn_english_app/size_config.dart';

import 'widget/vision_picture.dart';

// ignore: must_be_immutable
class VisionBody extends StatefulWidget {
  VisionBody({Key? key, required this.image, required this.content})
      : super(key: key);
  String image, content;

  @override
  State<VisionBody> createState() => _VisionBodyState();
}

class _VisionBodyState extends State<VisionBody> {
  PickedFile? _image;
  String? _content = "cat";
  APIVision apiVision = new APIVision();

  void callback() {
    apiVision
        .putImage(_VisionBottomSheetState._imagefile!.path)
        .then((value) => {
              setState(() {
                _image = _VisionBottomSheetState._imagefile;
                _content = value.content;
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return ListView(
      children: <Widget>[
        VisionPicture(
          image: _image == null
              ? AssetImage(widget.image) as ImageProvider
              : FileImage(File(_image!.path)),
        ),
        SizedBox(
          child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => VisionBottomSheet(
                        callback: callback,
                      )),
                );
              },
              child: Row(children: <Widget>[
                const Icon(Icons.camera_alt, color: kPrimaryColor, size: 33.0),
                Text(
                  "CHOOSE A PHOTO",
                  style: TextStyle(
                    fontSize: defaultSize * 2, //16
                    color: kTextLigntColor,
                  ),
                ),
              ])),
        ),
        Center(
          heightFactor: defaultSize * 0.3,
          child: Column(
            children: <Widget>[
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: defaultSize * 2.5,
                    color: kTitleTextColor,
                  ),
                  children: <TextSpan>[
                    const TextSpan(text: "this picture is about "),
                    TextSpan(
                        text: _content ?? widget.content,
                        style: TextStyle(
                          fontSize: defaultSize * 4,
                          color: kPrimaryColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // ignore: avoid_print
                            print("Next Words page");
                            // ignore: avoid_print
                            print('$_content');

                            context.push("/words/$_content");
                          }),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class VisionBottomSheet extends StatefulWidget {
  //const VisionBottomSheet({Key? key}) : super(key: key);
  final VoidCallback callback;

  const VisionBottomSheet({Key? key, required this.callback}) : super(key: key);

  @override
  State<VisionBottomSheet> createState() => _VisionBottomSheetState();
}

class _VisionBottomSheetState extends State<VisionBottomSheet> {
  static PickedFile? _imagefile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: const Icon(Icons.camera),
                label: const Text("Camera"),
              ),
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
    final pickedFile = await _picker.getImage(source: source);
    setState(() {
      _imagefile = pickedFile;
    });
    widget.callback();
  }
}
