import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:usb_device_platform_interface/models/transfer/response/status_response.dart';

class USBOutTransferResult {
  final int bytesWritten;
  final StatusResponse status;

  USBOutTransferResult({
    required this.bytesWritten,
    required this.status,
  });

  static USBOutTransferResult fromDataJS(dynamic res) {
    StatusResponse status =
        StatusResponseHelper.fromString((res as JSObject)['status'].dartify() as String);
    return USBOutTransferResult(
        bytesWritten: (res)['bytesWritten'].dartify() as int, status: status);
  }
}
