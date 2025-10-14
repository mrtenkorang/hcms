import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:hcms_revived2/screens/farmregistration/declaration/components/signature.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../main.dart';

class WitSignatureOptions extends StatefulWidget {
  final String? alreadyval;
  final onSelectImage;
  final String? profilePicture;

  WitSignatureOptions(this.onSelectImage, this.profilePicture,
      {this.alreadyval});

  @override
  WitSignatureOptionsState createState() => WitSignatureOptionsState();

  static WitSignatureOptionsState? of(BuildContext ctx) =>
      ctx.findAncestorStateOfType<WitSignatureOptionsState>();
}

class WitSignatureOptionsState extends State<WitSignatureOptions> {
  File? _storedImage;
  File? _newstoredImage;
  List<int> imageBytes = [];
  final imagePicker = ImagePicker();

  // var base64Sig;
  String? _predeclarationSig;
  String? _declarationSig;

  String _string = "";

  set string(String value) => setState(() => _string = value);

  // void setbase64Image() {
  //   regSP.setString('witnessbase64signature', base64Sig);
  // }

  void getSig() {
    _predeclarationSig = (regSP?.getString('witnessbase64signature') ?? "");
  }

  Future<void> _takePicture(ImageSource source) async {
    final pickedImage = await imagePicker.pickImage(
      source: source,
      maxHeight: 1080,
      maxWidth: 1080,
      imageQuality: 50,
    );

    setState(() {
      if (pickedImage != null && pickedImage.path != null) {
        print("Saving Working");
        _storedImage = File(pickedImage.path);
        print("Saving Working");
        _storedImage = File(pickedImage.path);

        GallerySaver.saveImage(_storedImage!.path, albumName: "HCMS APP");

        print("Saving Worked");

        print("Image saved path is ${_storedImage?.path}");
      }
    });

    _newstoredImage =
        await FlutterExifRotation.rotateImage(path: pickedImage!.path);
    imageBytes = await _newstoredImage!.readAsBytesSync();

    var base64Sig = await base64Encode(imageBytes);
    print("Imagebytes $imageBytes");
    print("Image converted to base64 successfully! $base64Sig");

    await regSP?.setString('witnessbase64signature', base64Sig);
    await widget.onSelectImage(_storedImage);
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
            child: Container(
              height: 200,
              // width: 270,
              child: Material(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0.0),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                        child: Center(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
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
                                  Text(
                                    "Signature options",
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
                                    onLongPress: () => Text("Close pop-up"),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    _takePicture(ImageSource.camera);
                                    Timer((Duration(seconds: 2)), () {
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: new Column(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: Container(
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
                                new Column(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: InkWell(
                                        onTap: () {
                                          _takePicture(ImageSource.gallery);
                                          Timer((Duration(seconds: 2)), () {
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Container(
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
                                new Column(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  SignaturePad(
                                                      callback: (val) =>
                                                          setState(() =>
                                                              _string = val)),
                                            ),
                                          );
                                        },
                                        child: Container(
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
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child:
                                          Text("Signature Pad".toUpperCase()),
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
  void initState() {
    super.initState();
    getSig();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    print("Stringus betus $_string");
    return Center(
      child: widget.profilePicture!.isNotEmpty
          ? Stack(
              children: [
                Container(
                  width: 170,
                  height: 170,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.memory(
                      base64.decode(widget.profilePicture!),
                      fit: BoxFit.fill,
                      colorBlendMode: BlendMode.color,
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
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                _storedImage != null
                    ? Container(
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
                    : widget.alreadyval!.trim().isNotEmpty
                        ? Container(
                            width: 170,
                            height: 170,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.memory(
                                  base64.decode(widget.alreadyval!),
                                  fit: BoxFit.contain,
                                  colorBlendMode: BlendMode.color,
                                )),
                          )
                        : Container(
                            width: 170,
                            height: 170,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset(
                                "lib/libassets/images/gallery.png",
                                // colorBlendMode: BlendMode.color,
                                // color: Colors.green,
                                fit: BoxFit.contain,
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
                      child: Icon(
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
