import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';

class ProfileImageInput extends StatefulWidget {
  final String? alreadyPic;
  final Function? onSelectImage;
  final String? profilePicture;

  const ProfileImageInput(this.onSelectImage,
      {super.key, this.profilePicture, this.alreadyPic = ""});

  @override
  ProfileImageInputState createState() => ProfileImageInputState();
}

class ProfileImageInputState extends State<ProfileImageInput> {
  File? _storedImage;
  File? _newstoredImage;
  List<int> imageBytes = [];
  final imagePicker = ImagePicker();

  // var base64Image;

  // void setbase64Image() {
  //   regSP.setString('base64Image', base64Image);
  // }

  Future<void> _takePicture(ImageSource source) async {
    final pickedImage = await imagePicker.pickImage(
      source: source,
      maxHeight: 1080,
      maxWidth: 1080,
      imageQuality: 50,
    );

    setState(() {
      if (pickedImage != null && pickedImage.path.isNotEmpty) {
        debugPrint("Saving Working");
        _storedImage = File(pickedImage.path);

        GallerySaver.saveImage(_storedImage!.path, albumName: "HCMS APP");

        debugPrint("Saving Worked");

        debugPrint("Image saved path is ${_storedImage?.path}");
      }
    });

    _newstoredImage =
        await FlutterExifRotation.rotateImage(path: pickedImage!.path);
    imageBytes = await _newstoredImage!.readAsBytesSync();

    var base64Image = await base64Encode(imageBytes);
    debugPrint("Imagebytes $imageBytes");
    debugPrint("Image converted to base64 successfully! $base64Image");

    await regSP?.setString('base64Image', base64Image);
    await widget.onSelectImage!(_storedImage);
  }

  void pickSource() {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 100),
        pageBuilder: (BuildContext context, Animation animation,
            Animation newAnimation) {
          return Center(
              child: Center(
            child: SizedBox(
              height: 200,
              width: 270,
              child: Material(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0.0),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                        child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            width: 270,
                            height: 40.0,
                            child: Container(
                              // height: 200,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25.0,
                              ),

                              color: Colors.red,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  const Text(
                                    "Select Image",
                                    style: TextStyle(
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                  InkWell(
                                    child: Image.asset(
                                      "lib/libassets/images/close.png",
                                      color: Colors.red,
                                      colorBlendMode: BlendMode.color,
                                    ),
                                    onTap: () => Navigator.pop(context),
                                    onLongPress: () => const Text("Close pop-up"),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    _takePicture(ImageSource.camera);
                                    Timer((const Duration(seconds: 2)), () {
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: SizedBox(
                                          // color: Colors.red[400],
                                          height: 50,
                                          width: 50,
                                          child: Image.asset(
                                            "lib/libassets/images/camera.png",
                                            height: 30.00,
                                            width: 30.00,
                                            // colorBlendMode: BlendMode.color,
                                            // color: Colors.orange,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text("Camera".toUpperCase()),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: InkWell(
                                        onTap: () {
                                          _takePicture(ImageSource.gallery);
                                          Timer((const Duration(seconds: 2)), () {
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: SizedBox(
                                          // color: Colors.red[500],
                                          height: 50,
                                          width: 50,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30.00),
                                            child: Image.asset(
                                              "lib/libassets/images/gallery.png",
                                              height: 30.00,
                                              width: 30.00,
                                              // colorBlendMode: BlendMode.color,
                                              // color: Colors.orange,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text("Gallery".toUpperCase()),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                  ),
                ),
              ),
            ),
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Stack(
        children: [
          _storedImage != null
              ? SizedBox(
                  width: 170,
                  height: 170,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.file(
                      _storedImage!,
                      fit: BoxFit.fill,
                      colorBlendMode: BlendMode.color,
                    ),
                  ),
                )
              : widget.alreadyPic!.trim().isNotEmpty
                  ? SizedBox(
                      width: 170,
                      height: 170,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.memory(
                          base64.decode(widget.alreadyPic!),
                          fit: BoxFit.fill,
                          colorBlendMode: BlendMode.color,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 170,
                      height: 170,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          "lib/libassets/images/newUser.png",
                          colorBlendMode: BlendMode.color,
                          color: primaryColour.withOpacity(.2),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 4,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                color: Colors.green,
              ),
              child: InkWell(
                onTap: () => pickSource(),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SpeciesImage extends StatefulWidget {
  final String? alreadyPic;
  final Function? onSelectImage;
  final String? profilePicture;

  const SpeciesImage(this.onSelectImage, {super.key, this.profilePicture, this.alreadyPic = ""});

  @override
  SpeciesImageState createState() => SpeciesImageState();
}

class SpeciesImageState extends State<SpeciesImage> {
  File? _storedImage;
  File? _newstoredImage;
  List<int> imageBytes = [];
  final imagePicker = ImagePicker();

  // var base64Image;

  // void setbase64Image() {
  //   regSP.setString('base64Image', base64Image);
  // }

  Future<void> _takePicture(ImageSource source) async {
    final pickedImage = await imagePicker.pickImage(
      source: source,
      maxHeight: 1080,
      maxWidth: 1080,
      imageQuality: 50,
    );

    setState(() {
      if (pickedImage != null && pickedImage.path.isNotEmpty) {
        debugPrint("Saving Working");
        _storedImage = File(pickedImage.path);

        GallerySaver.saveImage(_storedImage!.path, albumName: "HCMS APP");

        debugPrint("Saving Worked");

        debugPrint("Image saved path is ${_storedImage?.path}");
      }
    });

    if (pickedImage != null && pickedImage.path != null) {
      _newstoredImage =
          await FlutterExifRotation.rotateImage(path: pickedImage.path);
      imageBytes = await _newstoredImage!.readAsBytesSync();

      var speciesbase64Image = await base64Encode(imageBytes);
      debugPrint("Imagebytes $imageBytes");
      debugPrint("Image converted to base64 successfully! $speciesbase64Image");

      await regSP?.setString('speciesbase64Image', speciesbase64Image);
    }

    await widget.onSelectImage!(_storedImage);
  }

  void pickSource() {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 100),
        pageBuilder: (BuildContext context, Animation animation,
            Animation newAnimation) {
          return Center(
              child: Center(
            child: SizedBox(
              height: 200,
              width: 270,
              child: Material(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0.0),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                        child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            width: 270,
                            height: 40.0,
                            child: Container(
                              // height: 200,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25.0,
                              ),

                              color: Colors.red,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  const Text(
                                    "Select Image",
                                    style: TextStyle(
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                  InkWell(
                                    child: Image.asset(
                                      "lib/libassets/images/close.png",
                                      color: Colors.red,
                                      colorBlendMode: BlendMode.color,
                                    ),
                                    onTap: () => Navigator.pop(context),
                                    onLongPress: () => const Text("Close pop-up"),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    _takePicture(ImageSource.camera);
                                    Timer((const Duration(seconds: 2)), () {
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: SizedBox(
                                          // color: Colors.red[400],
                                          height: 50,
                                          width: 50,
                                          child: Image.asset(
                                            "lib/libassets/images/camera.png",
                                            height: 30.00,
                                            width: 30.00,
                                            // colorBlendMode: BlendMode.color,
                                            // color: Colors.orange,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text("Camera".toUpperCase()),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: InkWell(
                                        onTap: () {
                                          _takePicture(ImageSource.gallery);
                                          Timer((const Duration(seconds: 2)), () {
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: SizedBox(
                                          // color: Colors.red[500],
                                          height: 50,
                                          width: 50,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30.00),
                                            child: Image.asset(
                                              "lib/libassets/images/gallery.png",
                                              height: 30.00,
                                              width: 30.00,
                                              // colorBlendMode: BlendMode.color,
                                              // color: Colors.orange,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text("Gallery".toUpperCase()),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                  ),
                ),
              ),
            ),
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: InkWell(
        child: Stack(
          children: [
            _storedImage != null
                ? SizedBox(
                    width: 70,
                    height: 70,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.file(
                        _storedImage!,
                        fit: BoxFit.fill,
                        // colorBlendMode: BlendMode.color,
                      ),
                    ),
                  )
                : widget.alreadyPic!.trim().isNotEmpty
                    ? SizedBox(
                        width: 70,
                        height: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.memory(
                            base64.decode(widget.alreadyPic!),
                            fit: BoxFit.fill,
                            // colorBlendMode: BlendMode.color,
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          "lib/libassets/images/camera.png",
                          colorBlendMode: BlendMode.color,
                          color: Colors.green,
                          fit: BoxFit.fill,
                        ),
                      ),
          ],
        ),
        onTap: () => pickSource(),
      ),
    );
  }
}
