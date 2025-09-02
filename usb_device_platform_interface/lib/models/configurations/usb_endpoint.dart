import 'dart:js_interop';
import 'dart:js_interop_unsafe';

class USBEndpoint {
  final String direction;
  final int endpointNumber;
  final int packetSize;
  final String type;

  USBEndpoint(
      {required this.direction,
      required this.endpointNumber,
      required this.packetSize,
      required this.type});

  static List<USBEndpoint> fromEndpoints(List<dynamic> endpoints) {
    return endpoints
        .map((endpoint) => USBEndpoint(
            direction: (endpoint as JSObject)['direction'].dartify() as String,
            endpointNumber: (endpoint)['endpointNumber'].dartify() as int,
            packetSize: (endpoint)['packetSize'].dartify() as int,
            type: (endpoint)['type'].dartify() as String))
        .toList();
  }

  @override
  String toString() =>
      'USBEndpoint(direction: $direction, endpointNumber: $endpointNumber, packetSize: $packetSize, type: $type )';
}
