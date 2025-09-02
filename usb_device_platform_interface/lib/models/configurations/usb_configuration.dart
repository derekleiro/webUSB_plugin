import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:usb_device_platform_interface/models/configurations/usb_interface.dart';

class USBConfiguration {
  final String? configurationName;
  final int? configurationValue;
  final List<USBInterface>? usbInterfaces;

  USBConfiguration(
      {required this.configurationName,
      required this.configurationValue,
      required this.usbInterfaces});

  static USBConfiguration fromConfiguration(dynamic configuration) {
    return USBConfiguration(
      configurationName:
          (configuration as JSObject)["configurationName"].dartify() as String,
      configurationValue:
          (configuration)["configurationValue"].dartify() as int,
      usbInterfaces: (configuration)["interfaces"] == null
          ? null
          : USBInterface.fromInterfaces(
              (configuration)["interfaces"].dartify() as List<dynamic>),
    );
  }

  @override
  String toString() =>
      'USBConfiguration(configurationName: $configurationName, configurationValue: $configurationValue, usbInterfaces: $usbInterfaces)';
}
