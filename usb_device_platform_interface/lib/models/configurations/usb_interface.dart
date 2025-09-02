import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:usb_device_platform_interface/models/configurations/usb_alternate_interface.dart';

class USBInterface {
  final int interfaceNumber;
  final bool claimed;
  final List<USBAlternateInterface>? alternatesInterface;

  USBInterface(
      {required this.interfaceNumber,
      required this.claimed,
      required this.alternatesInterface});

  static List<USBInterface> fromInterfaces(List<dynamic> interfaces) {
    return interfaces
        .map((interface) => USBInterface(
            interfaceNumber:
                (interface as JSObject)['interfaceNumber'].dartify() as int,
            claimed: (interface)['claimed'].dartify() as bool,
            alternatesInterface: (interface)['alternates'].dartify() == null
                ? null
                : USBAlternateInterface.fromAlternateInterfaces(
                    (interface)['alternates'].dartify() as List<dynamic>)))
        .toList();
  }

  @override
  String toString() =>
      'USBInterface(interfaceNumber: $interfaceNumber, claimed: $claimed, alternatesInterface: $alternatesInterface )';
}
