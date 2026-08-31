import 'dart:io';

class NetworkUtils {
  NetworkUtils._();

  static const String loopbackAddress = '127.0.0.1';

  /// Best-effort lookup of this machine's LAN IPv4 address, so the server
  /// url is reachable from other devices on the same network. Falls back
  /// to the loopback address when no suitable interface is found.
  static Future<String> getLocalIpAddress() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
        includeLinkLocal: false,
      );
      for (final interface in interfaces) {
        for (final address in interface.addresses) {
          if (!address.isLoopback) {
            return address.address;
          }
        }
      }
    } catch (_) {
      // fall through to loopback
    }
    return loopbackAddress;
  }
}
