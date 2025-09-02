import 'dart:js_interop';
import 'dart:js_interop_unsafe';

class USBIsochronousOutTransferResult {
  final dynamic packets;

  USBIsochronousOutTransferResult({
    required this.packets,
  });

  static USBIsochronousOutTransferResult fromDataJS(dynamic dataJS) {
    return USBIsochronousOutTransferResult(
        packets: (dataJS as JSObject)['packets'].dartify() as dynamic);
  }
}
