import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../shared/constants/app_colors.dart';

class AppLocation {
  final Location location = Location();
  PermissionStatus? _permissionGranted;

  Future<LocationData?> determinePosition(BuildContext context) async {
    bool serviceEnabled;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      if (!context.mounted) return null;
      await showDialog<bool?>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext c) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
          content: OpenLocationSettingDialog(
            onPressed: () async {
              Navigator.of(c).pop();
              await AppSettings.openAppSettings(type: AppSettingsType.location);
            },
          ),
        ),
      );
      if (!serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted == PermissionStatus.deniedForever) {
        if (!context.mounted) return null;
        await showDialog<bool?>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext c) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
            content: OpenLocationSettingDialog(
              onPressed: () async {
                Navigator.of(c).pop();
                await AppSettings.openAppSettings(
                    type: AppSettingsType.location);
              },
            ),
          ),
        );

        return null;
      } else if (_permissionGranted == PermissionStatus.denied) {
        return null;
      }
    }

    if (_permissionGranted == PermissionStatus.granted ||
        _permissionGranted == PermissionStatus.grantedLimited) {
      return location.getLocation();
    }
    return null;
  }
}

class OpenLocationSettingDialog extends StatelessWidget {
  const OpenLocationSettingDialog({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.location_on_outlined,
          color: primaryColor,
        ),
        const SizedBox(height: 10),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            children: [
              TextSpan(text: "Allow ".tr()),
              const TextSpan(
                text: "UFC",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: " to access this \ndevice's location?".tr()),
            ],
          ),
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: onPressed,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            height: 50,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFdde1ff),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
              ),
            ),
            child: Text(
              "Allow".tr(),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                color: Color(0xFF46464e),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 3),
        InkWell(
          onTap: () => Navigator.of(context).pop(false),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            height: 50,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFdde1ff),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(13),
                bottomRight: Radius.circular(13),
              ),
            ),
            child: Text(
              "Don't allow".tr(),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                color: Color(0xFF46464e),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
