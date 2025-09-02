import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'dart:typed_data';

import 'package:usb_device_platform_interface/models/transfer/response/status_response.dart';

class USBInTransferResult {
  final Uint8List data;
  final StatusResponse status;

  USBInTransferResult({
    required this.data,
    required this.status,
  });

  static USBInTransferResult fromDataJS(dynamic dataJS) {
    var data = (dataJS as JSObject)['data'] as JSObject;
    StatusResponse status =
        StatusResponseHelper.fromString((dataJS)['status'].dartify() as String);
    return USBInTransferResult(
        data: Uint8List.view((data)['buffer'].dartify() as ByteBuffer),
        status: status);
  }
}
