@JS()
library usb_device_web;

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:usb_device_platform_interface/usb_device_platform_interface.dart';

import 'import_js/import_js_library.dart';

class WebUSBPlugin extends UsbDevicePlatform {
  late final WebUsbJS _webUsbJS;

  WebUSBPlugin() : this._webUsbJS = WebUsbJS();

  /// Factory method that initializes the Web device plugin platform with an instance
  /// of the plugin for the web.
  static void registerWith(Registrar registrar) async {
    await importJsLibrary(
        url: "./assets/webusb.js", flutterPluginName: "usb_device_web");
    UsbDevicePlatform.instance = WebUSBPlugin();
  }

  @override
  Future<bool> isSupported() {
    return Future.value(this._webUsbJS.isSupported());
  }

  @override
  Future<List<dynamic>> get pairedDevices async {
    final jsPromise = this._webUsbJS.getPairedDevices() as JSPromise;
    final result = await jsPromise.toDart;
    return result as List<dynamic>;
  }

  @override
  Future<dynamic> requestDevices(List<DeviceFilter> filters) async {
    List<DeviceFilterJS> filtersJS = [];
    for (var deviceFilter in filters) {
      filtersJS.add(DeviceFilterJS(
          vendorId: deviceFilter.vendorId, productId: deviceFilter.productId));
    }
    final promise = this._webUsbJS.requestDevice(filtersJS) as JSPromise;
    return await promise.toDart;
  }

  @override
  Future open(dynamic device) async {
    final promise = this._webUsbJS.open(device) as JSPromise;
    return await promise.toDart;
    // No return value needed for void function
  }

  @override
  Future close(dynamic device) async {
    final promise = this._webUsbJS.close(device) as JSPromise;
    return await promise.toDart;
  }

  @override
  Future claimInterface(dynamic device, int interfaceNumber) async {
    final promise =
        this._webUsbJS.claimInterface(device, interfaceNumber) as JSPromise;
    return await promise.toDart;
  }

  @override
  Future releaseInterface(dynamic device, int interfaceNumber) async {
    final promise =
        this._webUsbJS.releaseInterface(device, interfaceNumber) as JSPromise;
    return await promise.toDart;
  }

  @override
  Future reset(dynamic device) async {
    final promise = this._webUsbJS.reset(device) as JSPromise;
    return await promise.toDart;
  }

  @override
  Future selectConfiguration(dynamic device, int configurationValue) async {
    final promise = this
        ._webUsbJS
        .selectConfiguration(device, configurationValue) as JSPromise;
    return await promise.toDart;
  }

  @override
  Future clearHalt(dynamic device, String direction, int endpointNumber) async {
    final promise = this._webUsbJS.clearHalt(device, direction, endpointNumber)
        as JSPromise;
    return await promise.toDart;
  }

  @override
  Future<USBInTransferResult> controlTransferIn(
      dynamic device, SetupParam setup,
      {int? length}) async {
    var promise = this._webUsbJS.controlTransferIn(
        device,
        SetupParamJS(
            requestType: setup.requestType,
            recipient: setup.recipient,
            request: setup.request,
            value: setup.value,
            index: setup.index),
        length) as JSPromise;

    final result = await promise.toDart;
    return USBInTransferResult.fromDataJS(result);
  }

  @override
  Future<USBOutTransferResult> controlTransferOut(
      dynamic device, SetupParam setup,
      {dynamic data}) async {
    var promise = this._webUsbJS.controlTransferOut(
        device,
        SetupParamJS(
            requestType: setup.requestType,
            recipient: setup.recipient,
            request: setup.request,
            value: setup.value,
            index: setup.index),
        data) as JSPromise;
    final result = await promise.toDart;
    return USBOutTransferResult.fromDataJS(result);
  }

  @override
  Future<USBInTransferResult> transferIn(
      dynamic device, int endpointNumber, int length) async {
    try {
      var promise = this._webUsbJS.transferIn(device, endpointNumber, length)
          as JSPromise;
      final response =
          await promise.toDart.timeout(Duration(milliseconds: 3000));

      return USBInTransferResult.fromDataJS(response);
    } on TimeoutException {
      return USBInTransferResult(
          data: Uint8List(0), status: StatusResponse.empty_data);
    } on Error catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<USBOutTransferResult> transferOut(
      dynamic device, int endpointNumber, dynamic data) async {
    var promise =
        this._webUsbJS.transferOut(device, endpointNumber, data) as JSPromise;
    final result = await promise.toDart;
    return USBOutTransferResult.fromDataJS(result);
  }

  @override
  Future<USBIsochronousInTransferResult> isochronousTransferIn(
      dynamic device, int endpointNumber, List<int> packetLengths) async {
    var promise = this._webUsbJS.isochronousTransferIn(
        device, endpointNumber, packetLengths) as JSPromise;
    final result = await promise.toDart;
    return USBIsochronousInTransferResult.fromDataJS(result);
  }

  @override
  Future<USBIsochronousOutTransferResult> isochronousTransferOut(
      dynamic device, int endpointNumber, dynamic data) async {
    var promise = this
        ._webUsbJS
        .isochronousTransferOut(device, endpointNumber, data) as JSPromise;
    var result = await promise.toDart;
    return USBIsochronousOutTransferResult.fromDataJS(result);
  }

  @override
  Future<void> setOnConnectCallback(Function(dynamic) onConnect) async {
    this._webUsbJS.setOnConnectCallback(
          ((JSAny device) {
            onConnect(device.dartify());
          }).toJS,
        );
  }

  @override
  Future<void> setOnDisconnectCallback(Function(dynamic) onDisconnect) async {
    this._webUsbJS.setOnDisconnectCallback(
          ((JSAny device) {
            onDisconnect(device.dartify());
          }).toJS,
        );
  }

  @override
  Future<USBConfiguration?> getSelectedConfiguration(
      dynamic pairedDevice) async {
    final USBConfiguration? currentConfiguration =
        (pairedDevice as JSObject)["configuration"].dartify() == null
            ? null
            : _getCurrentUSBConfigurationInfo(
                (pairedDevice)["configuration"].dartify() as dynamic);
    return currentConfiguration;
  }

  @override
  Future<List<USBConfiguration>> getAvailableConfigurations(
      dynamic pairedDevice) async {
    final List<USBConfiguration> configurations =
        _getAvailableUSBConfigurations(
            (pairedDevice as JSObject)["configurations"].dartify()
                as List<dynamic>);
    return configurations;
  }

  /// Get info of paired device
  @override
  Future<USBDeviceInfo> getPairedDeviceInfo(dynamic pairedDevice) async {
    return USBDeviceInfo.fromDeviceJS(pairedDevice);
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
}

// JS
@JS("WebUsbJS")
extension type WebUsbJS._(JSObject _) implements JSObject {
  external factory WebUsbJS();

  external bool isSupported();

  // Pair device
  external Promise getPairedDevices();

  external Promise requestDevice(List<DeviceFilterJS> filters);

  external setOnConnectCallback(JSFunction callback);

  external setOnDisconnectCallback(JSFunction callback);

  /// Session setup
  external Promise open(JSAny device);

  external Promise close(JSAny device);

  external Promise claimInterface(JSAny device, int interfaceNumber);

  external Promise releaseInterface(JSAny device, int interfaceNumber);

  external Promise reset(JSAny device);

  external Promise selectConfiguration(JSAny device, int configurationValue);

  external Promise clearHalt(
      JSAny device, String direction, int endpointNumber);

  /// Data transfer
  external Promise controlTransferIn(
      JSAny device, SetupParamJS setup, int? length);

  external Promise controlTransferOut(
      JSAny device, SetupParamJS setup, JSAny data);

  external Promise transferIn(JSAny device, int endpointNumber, int length);

  external Promise transferOut(JSAny device, int endpointNumber, JSAny data);

  external Promise isochronousTransferIn(
      JSAny device, int endpointNumber, List<int> packetLengths);

  external Promise isochronousTransferOut(
      JSAny device, int endpointNumber, JSAny data);
}

// Convert to extension type
@JS()
extension type Promise._(JSObject _) implements JSObject {
  external void then(JSFunction onFulfilled, JSFunction onRejected);
}

// Convert to extension type
@JS()
extension type DeviceFilterJS._(JSObject _) implements JSObject {
  external factory DeviceFilterJS({int vendorId, int productId});
}

// Convert to extension type
@JS()
extension type SetupParamJS._(JSObject _) implements JSObject {
  external factory SetupParamJS({
    String requestType,
    String recipient,
    int request,
    int value,
    int index,
  });
}
