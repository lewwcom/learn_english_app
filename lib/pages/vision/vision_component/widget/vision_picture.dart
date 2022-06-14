import 'package:flutter/material.dart';
import 'package:learn_english_app/size_config.dart';

class VisionPicture extends StatelessWidget {
  const VisionPicture({
    Key? key,
    required this.image,
  }) : super(key: key);

  final dynamic image;

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return SizedBox(
      height: defaultSize * 35,
      child: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: defaultSize * 30,
                  width: defaultSize * 40, //140
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.white,
                      width: defaultSize * 0.8,
                    ),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        //image: _VisionBottomSheetState._imagefile== null ? AssetImage(image) as ImageProvider: FileImage(File(_VisionBottomSheetState._imagefile!.path) )
                        image: image),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
