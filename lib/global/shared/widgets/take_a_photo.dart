import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_widgets/custom_text.dart';

class TakeAPhoto extends StatefulWidget {
  const TakeAPhoto({super.key, this.purpose});
  final String? purpose;
  @override
  State<TakeAPhoto> createState() => _TakeAPhotoState();
}

class _TakeAPhotoState extends State<TakeAPhoto> {
  bool settingUp = true;
  CameraController? controller;
  @override
  void initState() {
    super.initState();
    takeAPhoto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: controller != null
          ? widget.purpose != null
              ? InkWell(
                  onTap: () async {
                    final img = await controller!.takePicture();
                    if (!context.mounted) return;
                    Navigator.of(context).pop(File(img.path));
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CustomText(text: widget.purpose ?? ''),
                    ),
                  ),
                )
              : InkResponse(
                  onTap: () async {
                    final img = await controller!.takePicture();
                    if (!context.mounted) return;
                    Navigator.of(context).pop(File(img.path));
                  },
                  child: const CircleAvatar(
                    radius: 40,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white,
                    ),
                  ),
                )
          : null,
      body: settingUp
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : controller == null
              ? Center(
                  child: CustomText(text: "Unable to initialize the camera"),
                )
              : CameraPreview(
                  controller!,
                ),
    );
  }

  Future<void> takeAPhoto() async {
    List<CameraDescription> cameras = await availableCameras();
    settingUp = false;
    if (cameras.isEmpty) {
      setState(() {});
      return;
    }
    controller = CameraController(cameras.first, ResolutionPreset.medium,
        enableAudio: false);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
