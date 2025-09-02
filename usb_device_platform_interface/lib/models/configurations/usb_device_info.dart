import 'dart:js_interop';
import 'dart:js_interop_unsafe';

class USBDeviceInfo {
  final int usbVersionMajor;
  final int usbVersionMinor;
  final int usbVersionSubMinor;
  final int deviceClass;
  final int deviceSubClass;
  final int deviceProtocol;
  final int vendorId;
  final int productId;
  final int deviceVersionMajor;
  final int deviceVersionMinor;
  final int deviceVersionSubMinor;
  final String manufacturerName;
  final String productName;
  final String serialNumber;
  final bool opened;

  USBDeviceInfo(
      this.usbVersionMajor,
      this.usbVersionMinor,
      this.usbVersionSubMinor,
      this.deviceClass,
      this.deviceSubClass,
      this.deviceProtocol,
      this.vendorId,
      this.productId,
      this.deviceVersionMajor,
      this.deviceVersionMinor,
      this.deviceVersionSubMinor,
      this.manufacturerName,
      this.productName,
      this.serialNumber,
      this.opened);

  static USBDeviceInfo fromDeviceJS(dynamic pairedDevice) {
    return USBDeviceInfo(
      (pairedDevice as JSObject)['usbVersionMajor'].dartify() as int,
      (pairedDevice)['usbVersionMinor'].dartify() as int,
      (pairedDevice)['usbVersionSubminor'].dartify() as int,
      (pairedDevice)['deviceClass'].dartify() as int,
      (pairedDevice)['deviceSubclass'].dartify() as int,
      (pairedDevice)['deviceProtocol'].dartify() as int,
      (pairedDevice)['vendorId'].dartify() as int,
      (pairedDevice)['productId'].dartify() as int,
      (pairedDevice)['deviceVersionMajor'].dartify() as int,
      (pairedDevice)['deviceVersionMinor'].dartify() as int,
      (pairedDevice)['deviceVersionSubminor'].dartify() as int,
      (pairedDevice)['manufacturerName'].dartify() as String,
      (pairedDevice)['productName'].dartify() as String,
      (pairedDevice)['serialNumber'].dartify() as String,
      (pairedDevice)['opened'].dartify() as bool,
    );
  }
}
