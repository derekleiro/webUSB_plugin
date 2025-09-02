import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:usb_device_platform_interface/models/configurations/usb_endpoint.dart';

class USBAlternateInterface {
  final int alternateSetting;
  final List<USBEndpoint>? endpoints;

  USBAlternateInterface(
      {required this.alternateSetting, required this.endpoints});

  static List<USBAlternateInterface> fromAlternateInterfaces(
      List<dynamic> alternateInterfaces) {
    return alternateInterfaces
        .map((e) => USBAlternateInterface(
              alternateSetting: (e as JSObject)['alternateSetting'].dartify() as int,
              endpoints: (e)['endpoints'].dartify() == null
                  ? null
                  : USBEndpoint.fromEndpoints((e)['endpoints'].dartify() as List<dynamic>),
            ))
        .toList();
  }

  @override
  String toString() =>
      'USBAlternateInterface(alternateSetting: $alternateSetting, endpoints: $endpoints)';
}
