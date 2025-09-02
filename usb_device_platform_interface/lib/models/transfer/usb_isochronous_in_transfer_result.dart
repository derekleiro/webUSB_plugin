import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

class USBIsochronousInTransferResult {
  final Uint8List data;
  final dynamic packets;

  USBIsochronousInTransferResult({
    required this.data,
    required this.packets,
  });

  static USBIsochronousInTransferResult fromDataJS(dynamic dataJS) {
    var data = (dataJS as JSObject)['data'] as JSObject;
    return USBIsochronousInTransferResult(
        data: Uint8List.view((data)['buffer'].dartify() as ByteBuffer),
        packets: (dataJS)['packets'].dartify() as dynamic);
  }
}
