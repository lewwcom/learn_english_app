import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/size_config.dart';

class Info extends StatelessWidget {

  const Info({
    Key? key,
    required this.name,
    required this.image ,
  }) : super(key: key);

  final String name, image;

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
                          image: _BottomSheetState._imagefile== null ? AssetImage(image) as ImageProvider: FileImage(File(_BottomSheetState._imagefile!.path) )
                      ),
                    ),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: defaultSize * 2.2, //22
                      color: kTextColor,
                    ),
                  ),
                  SizedBox(
                    height: defaultSize / 2, //5
                  )
                ],
              ),
            ),
            Positioned(
              top: 150,
              right: 140,

              child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: ((builder)=> BottomSheet()),
                    );
                  },
                  child:
                  Icon(Icons.camera_alt, color: kPrimaryColor, size: 33.0)),
            ),
          ],
        )
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
  const BottomSheet({Key? key}) : super(key: key);

  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  static PickedFile ? _imagefile ;
  final ImagePicker _picker =ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Container(height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text(
            "Choose profile photo",
            style: TextStyle(
              fontSize: 20.0,

            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton.icon(
                onPressed:(){
                  takePhoto(ImageSource.camera);
                },
                icon: Icon(Icons.camera),
                label: Text("Camera"),
              ),
              FlatButton.icon(
                onPressed:(){
                  takePhoto(ImageSource.gallery);
                },
                icon: Icon(Icons.image),
                label: Text("Gallery"),
              ),
            ],
          ),
        ],
      ),
    );
  }
  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
        source: source
    );
    setState(() {
      _imagefile=pickedFile;
    });
  }
}



