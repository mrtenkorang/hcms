import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/main.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:signature/signature.dart';

class SignaturePad extends StatefulWidget {
  final StringCallback? callback;

  SignaturePad({this.callback});

  @override
  _SignaturePadState createState() => _SignaturePadState();
}

typedef void StringCallback(String val);

class _SignaturePadState extends State<SignaturePad> {
  SignatureController? controller;

  String? _base64Sig;
  void setbase64Image() {
    regSP?.setString('witnessbase64signature', _base64Sig!);
  }

  @override
  void initState() {
    super.initState();

    controller = SignatureController(
      penColor: Colors.white,
      penStrokeWidth: 5,
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext contxt) {
    return Scaffold(
      body: Column(
        children: [
          Signature(
            controller: controller!,
            backgroundColor: Colors.black,
          ),
          buildButtons(context),
        ],
      ),
    );
  }

  Widget buildButtons(BuildContext context) => Container(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            signatureApprove(context),
            signatureDisapprove(),
          ],
        ),
      );
  Widget signatureApprove(BuildContext context) {
    return IconButton(
      iconSize: 36,
      icon: Icon(
        Icons.check,
        color: fPrimaryColour,
      ),
      onPressed: () async {
        if (controller!.isNotEmpty) {
          final signature = await exportSignature();

          await saveSignature(context, signature);

          // WitSignatureOptions.of(context).string = "_base64Sig";

          controller?.clear();
          Navigator.pop(context);
        }
      },
    );
  }

  Widget signatureDisapprove() {
    return IconButton(
      iconSize: 36,
      icon: Icon(
        Icons.clear,
        color: Colors.red,
      ),
      onPressed: () => controller?.clear(),
    );
  }

  Future<Uint8List> exportSignature() async {
    final exportController = SignatureController(
      penColor: Colors.black,
      penStrokeWidth: 2,
      exportBackgroundColor: Colors.white,
      points: controller?.points,
    );

    final signature = await exportController.toPngBytes();
    _base64Sig = base64.encode(signature!);

    print("Base base: $_base64Sig");
    exportController.dispose();

    return signature;
  }

  Future saveSignature(BuildContext context, signature) async {
    final status = await Permission.storage.status;

    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', ':')
        .replaceAll(':', '-');
    final name = 'signature_$time.png';

    // final result = await ImageGallerySaver.saveImage(signature, name: name);
    final result = await GallerySaver.saveImage(signature);
    final isSuccess = result;
    // final String filePath = result['filePath'];
    debugPrint(name);
    // debugPrint(filePath);

    if (isSuccess!) {
      overlayNotification(
          'Signature saved successfully! Please tap on the image'
              ' icon and select "Gallery" to locate your signature.',
          "positive");
    } else {
      overlayNotification('Failed to save signature', "negative");
    }
  }
}
