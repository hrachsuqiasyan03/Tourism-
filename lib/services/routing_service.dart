import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RouteResult {
  const RouteResult({
    required this.geometry,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  final List<LatLng> geometry;
  final double distanceMeters;
  final double durationSeconds;
}

class RoutingService {
  RoutingService._();

  static Future<RouteResult> getDrivingRoute(List<LatLng> waypoints) async {
    if (waypoints.length < 2) {
      throw ArgumentError('At least two waypoints are required.');
    }

    final coordinates = waypoints
        .map((point) => '${point.longitude},${point.latitude}')
        .join(';');
    final uri = Uri.https(
      'router.project-osrm.org',
      '/route/v1/driving/$coordinates',
      const {
        'overview': 'full',
        'geometries': 'geojson',
        'steps': 'false',
        'alternatives': 'false',
      },
    );
    try {
      final response = await http
          .get(uri, headers: const {'User-Agent': 'ArmTravel/1.0'})
          .timeout(const Duration(seconds: 20));
      if (response.statusCode != 200) {
        throw http.ClientException(
          'Routing service returned ${response.statusCode}.',
        );
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException(
          'The routing service returned an invalid response.',
        );
      }
      if (decoded['code'] != 'Ok') {
        throw const FormatException(
          'No driving route was found for these destinations.',
        );
      }

      final routes = decoded['routes'];
      if (routes is! List || routes.isEmpty || routes.first is! Map) {
        throw const FormatException(
          'The routing service returned no usable route.',
        );
      }
      final route = routes.first as Map;
      final geometry = route['geometry'];
      final coordinates = geometry is Map ? geometry['coordinates'] : null;
      if (coordinates is! List || coordinates.isEmpty) {
        throw const FormatException(
          'The routing service returned invalid route geometry.',
        );
      }
      final points = coordinates.map((coordinate) {
        if (coordinate is! List ||
            coordinate.length < 2 ||
            coordinate[0] is! num ||
            coordinate[1] is! num) {
          throw const FormatException(
            'The routing service returned invalid route coordinates.',
          );
        }
        final longitude = (coordinate[0] as num).toDouble();
        final latitude = (coordinate[1] as num).toDouble();
        if (!latitude.isFinite ||
            !longitude.isFinite ||
            latitude < -90 ||
            latitude > 90 ||
            longitude < -180 ||
            longitude > 180) {
          throw const FormatException(
            'The routing service returned invalid coordinates.',
          );
        }
        return LatLng(latitude, longitude);
      }).toList();
      if (points.length < 2) {
        throw const FormatException(
          'The routing service returned incomplete route geometry.',
        );
      }
      final distance = route['distance'];
      final duration = route['duration'];
      if (distance is! num ||
          duration is! num ||
          !distance.isFinite ||
          !duration.isFinite ||
          distance < 0 ||
          duration < 0) {
        throw const FormatException(
          'The routing service returned invalid route measurements.',
        );
      }

      return RouteResult(
        geometry: points,
        distanceMeters: distance.toDouble(),
        durationSeconds: duration.toDouble(),
      );
    } on FormatException {
      rethrow;
    } on http.ClientException {
      rethrow;
    } catch (error) {
      throw http.ClientException('Could not calculate the road route: $error');
    }
  }
}
