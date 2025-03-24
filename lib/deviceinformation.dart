// import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/services.dart';
// import 'SharedPreference.dart';
// import 'globals.dart';
//
// class deviceInfo {
//   static Map<String, dynamic> deviceData = {};
//   static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
//   static String? deviceId = "";
//   static String? deviceModel = "";
//   static String? deviceBrand = "";
//   static String? deviceManufacturer = "";
//   static String? deviceOSVersion = "";
//   static String? deviceOS = "";
//   static String? codename = "";
//
//   static Future<void> readDeviceInfo() async {
//     try {
//       if (Platform.isAndroid) {
//         _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
//       } else if (Platform.isIOS) {
//         _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
//       }
//     } on PlatformException {
//       deviceData = <String, dynamic>{
//         'Error:': 'Failed to get platform version.'
//       };
//     }
//   }
//
//   _getCodenameFromRelease(String release) {
//     switch (release) {
//       case '10':
//         return 'Android 10';
//       case '11':
//         return 'Android 11';
//       case '12':
//         return 'Snow Cone (Android 12)';
//       case '13':
//         return 'Tiramisu (Android 13)';
//       case '14':
//         return 'Upside Down Cake (Android 14)';
//       default:
//         return 'Unknown';
//     }
//   }
//
//   static Map<String, dynamic>? _readAndroidBuildData(AndroidDeviceInfo build) {
//     deviceId = build.id;
//     deviceModel = build.model;
//     deviceBrand = build.brand;
//     deviceManufacturer = build.manufacturer;
//     deviceOSVersion = build.version.release;
//     deviceOS = "android";
//     _getCodenameFromRelease(String release) {
//       switch (release) {
//         case '7':
//           return 'Nougat ';
//         case '8':
//           return 'Oreo ';
//         case '9':
//           return 'Pie';
//         case '10':
//           return 'Android 10';
//         case '11':
//           return 'Android 11';
//         case '12':
//           return 'Snow Cone ';
//         case '13':
//           return 'Tiramisu ';
//         case '14':
//           return 'Upside Down Cake ';
//         default:
//           return 'Unknown';
//       }
//     }
//
//     codename = _getCodenameFromRelease(build.version.release);
//     deviceData = <String, dynamic>{
//       'version.securityPatch': build.version.securityPatch,
//       'version.sdkInt': build.version.sdkInt,
//       'version.release': build.version.release,
//       'version.previewSdkInt': build.version.previewSdkInt,
//       'version.incremental': build.version.incremental,
//       'version.codename': build.version.codename,
//       'version.baseOS': build.version.baseOS,
//       'board': build.board,
//       'bootloader': build.bootloader,
//       'brand': build.brand,
//       'device': build.device,
//       'display': build.display,
//       'fingerprint': build.fingerprint,
//       'hardware': build.hardware,
//       'host': build.host,
//       'id': build.id,
//       'manufacturer': build.manufacturer,
//       'model': build.model,
//       'product': build.product,
//       'supported32BitAbis': build.supported32BitAbis,
//       'supported64BitAbis': build.supported64BitAbis,
//       'supportedAbis': build.supportedAbis,
//       'tags': build.tags,
//       'type': build.type,
//       'isPhysicalDevice': build.isPhysicalDevice,
//       'deviceId': build.id,
//       'systemFeatures': build.systemFeatures,
//     };
//   }
//
//   static Map<String, dynamic>? _readIosDeviceInfo(IosDeviceInfo data) {
//     deviceId = data.identifierForVendor;
//     deviceModel = data.model;
//     deviceBrand = data.name;
//     deviceManufacturer = data.name;
//     deviceOSVersion = data.systemVersion;
//     deviceOS = "IOS";
//     deviceData = <String, dynamic>{
//       'name': data.name,
//       'systemName': data.systemName,
//       'systemVersion': data.systemVersion,
//       'model': data.model,
//       'localizedModel': data.localizedModel,
//       'deviceId': data.identifierForVendor,
//       'isPhysicalDevice': data.isPhysicalDevice,
//       'utsname.sysname:': data.utsname.sysname,
//       'utsname.nodename:': data.utsname.nodename,
//       'utsname.release:': data.utsname.release,
//       'utsname.version:': data.utsname.version,
//       'utsname.machine:': data.utsname.machine,
//     };
//   }
//
//   static Future<void> SaveDatainsp() async {
//     await readDeviceInfo();
//     await saveData("DEVICE_ID", deviceId, SharedPreferenceIOType.STRING);
//     await saveData("DEVICE_MODEL", deviceModel, SharedPreferenceIOType.STRING);
//     await saveData("DEVICE_BRAND", deviceBrand, SharedPreferenceIOType.STRING);
//     await saveData("DEVICE_MANUFACTURER", deviceManufacturer,
//         SharedPreferenceIOType.STRING);
//     await saveData(
//         "DEVICE_OS_VERSION", deviceOSVersion, SharedPreferenceIOType.STRING);
//     await saveData("deviceOS", deviceOS, SharedPreferenceIOType.STRING);
//     await saveData("codename", codename, SharedPreferenceIOType.STRING);
//     deviceInformation["DEVICE_ID"] =
//         await getData("DEVICE_ID", SharedPreferenceIOType.STRING);
//     deviceInformation["DEVICE_MODEL"] =
//         await getData("DEVICE_MODEL", SharedPreferenceIOType.STRING);
//     deviceInformation["DEVICE_BRAND"] =
//         await getData("DEVICE_BRAND", SharedPreferenceIOType.STRING);
//     deviceInformation["DEVICE_MANUFACTURER"] =
//         await getData("DEVICE_MANUFACTURER", SharedPreferenceIOType.STRING);
//     deviceInformation["DEVICE_OS_VERSION"] =
//         await getData("DEVICE_OS_VERSION", SharedPreferenceIOType.STRING);
//     deviceInformation["deviceOS"] =
//         await getData("deviceOS", SharedPreferenceIOType.STRING);
//     deviceInformation["codename"] =
//         await getData("codename", SharedPreferenceIOType.STRING);
//     deviceInformation["udf5"] = {
//       "os": {
//         "name": deviceInformation["deviceOS"],
//         "version": deviceInformation["deviceOSVersion"],
//         "versionName": deviceInformation["codename"]
//       }
//     };
//   }
// }
