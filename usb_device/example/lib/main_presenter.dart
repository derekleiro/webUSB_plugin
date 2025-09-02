import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:usb_device/usb_device.dart';

import 'main.dart';
import 'main_viewmodel.dart';

class MainPresenter {
  final MainViewModel viewModel;
  final MainView viewInterface;
  final UsbDevice _usbDevice = UsbDevice();

  MainPresenter(
    this.viewModel,
    this.viewInterface,
  );

  MainPresenter init() {
    this.viewModel.isLoading = true;
    this.viewModel.fabIsVisible = false;
    return this;
  }

  void initServices() async {}

  void loadData() async {
    this.viewModel.isLoading = true;
    this.viewModel.isSupported = await this._usbDevice.isSupported();
    await this.getPairedDevice();
    this.viewModel.isLoading = false;
    this.viewInterface.refresh();
  }

  Future getPairedDevice() async {
    final devices = await this._usbDevice.pairedDevices;
    if (devices.length > 0) {
      this.viewModel.fabIsVisible = true;
      this.viewModel.pairedDevice = devices.first;
    }
  }

  Future startSession() async {
    if (this.viewModel.pairedDevice != null) {
      await this._usbDevice.open(this.viewModel.pairedDevice!);
      this.viewInterface.refresh();
    }
  }

  Future closeSession() async {
    if (this.viewModel.pairedDevice != null) {
      await this._usbDevice.close(this.viewModel.pairedDevice!);
      this.viewInterface.refresh();
    }
  }

  void requestDevices() async {
    this.viewModel.pairedDevice = await this._usbDevice.requestDevices([]);
    this.viewModel.fabIsVisible = true;
    this.viewInterface.refresh();
  }

  Map<String, dynamic> getPairedDeviceInfo() {
    var pairedDevice = this.viewModel.pairedDevice;
    final USBConfiguration? currentConfiguration =
    (pairedDevice as JSObject)["configuration"].dartify() == null
            ? null
            : _getCurrentUSBConfigurationInfo(
                (pairedDevice)["configuration"].dartify() as dynamic);
    final List<USBConfiguration> configurations =
        _getAvailableUSBConfigurations(
            (pairedDevice)["configurations"].dartify() as List<dynamic>);

    try {
      return <String, dynamic>{
        'usbVersionMajor': (pairedDevice)["usbVersionMajor"].dartify(),
        'usbVersionMinor': (pairedDevice)["usbVersionMinor"].dartify(),
        'usbVersionSubminor': (pairedDevice)["usbVersionSubminor"].dartify(),
        'deviceClass': (pairedDevice)["deviceClass"].dartify(),
        'deviceSubclass': (pairedDevice)["deviceSubclass"].dartify(),
        'deviceProtocol': (pairedDevice)["deviceProtocol"].dartify(),
        'vendorId': (pairedDevice)["vendorId"].dartify(),
        'productId': (pairedDevice)["productId"].dartify(),
        'deviceVersionMajor': (pairedDevice)["deviceVersionMajor"].dartify(),
        'deviceVersionMinor': (pairedDevice)["deviceVersionMinor"].dartify(),
        'deviceVersionSubminor':
            (pairedDevice)["deviceVersionSubminor"].dartify(),
        'manufacturerName': (pairedDevice)["manufacturerName"].dartify(),
        'productName': (pairedDevice)["productName"].dartify(),
        'serialNumber': (pairedDevice)["serialNumber"].dartify(),
        'opened': (pairedDevice)["opened"].dartify(),
        'configurations': configurations,
        'actualConfiguration': currentConfiguration.toString()
      };
    } catch (e) {
      return <String, dynamic>{'Error:': 'Failed to get paired device info.'};
    }
  }

  List<USBConfiguration> _getAvailableUSBConfigurations(
      List<dynamic> configurations) {
    return configurations
        .map((e) => USBConfiguration.fromConfiguration(e))
        .toList();
  }

  USBConfiguration _getCurrentUSBConfigurationInfo(dynamic configuration) {
    return USBConfiguration.fromConfiguration(configuration);
  }

  bool isDeviceOpen() {
    var pairedDevice = this.viewModel.pairedDevice;
    if (pairedDevice != null) {
      return (pairedDevice as JSObject)["opened"].dartify() as bool;
    }
    return false;
  }

  void dispose() {}
}
