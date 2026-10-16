import 'package:url_launcher/url_launcher.dart';

class MapService {
  static Future<bool> openOpenStreetMap({
    required double latitude,
    required double longitude,
  }) => _open(
    Uri.https('www.openstreetmap.org', '/', {
      'mlat': '$latitude',
      'mlon': '$longitude',
      'zoom': '16',
    }),
  );

  static Future<bool> openDirections({
    required double latitude,
    required double longitude,
  }) => _open(
    Uri(
      scheme: 'https',
      host: 'www.openstreetmap.org',
      path: '/directions',
      queryParameters: {'to': '$latitude,$longitude'},
      fragment: 'map=14/$latitude/$longitude',
    ),
  );

  static Future<bool> openAttribution() =>
      _open(Uri.parse('https://www.openstreetmap.org/copyright'));

  static Future<bool> _open(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}
