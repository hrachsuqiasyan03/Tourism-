import 'dart:convert';
import 'dart:math' as math;

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

  static const List<LatLng> _mainArmeniaWaypoints = [
    LatLng(40.1776, 44.5126), // Yerevan
    LatLng(40.2989, 44.3611), // Ashtarak
    LatLng(40.7900, 43.8500), // Gyumri
    LatLng(40.8120, 44.4900), // Vanadzor
    LatLng(40.7410, 44.8640), // Dilijan
    LatLng(40.8700, 44.6300), // Ijevan
    LatLng(40.4970, 44.7660), // Hrazdan
    LatLng(40.5490, 45.0090), // Sevan
    LatLng(40.1540, 44.0480), // Armavir
    LatLng(39.7630, 45.1840), // Yeghegnadzor
    LatLng(39.8410, 45.6720), // Jermuk
    LatLng(39.5120, 46.3380), // Goris
    LatLng(39.2010, 46.4050), // Kapan
    LatLng(38.9020, 46.2440), // Meghri
  ];

  static const List<LatLng> _armeniaBoundary = [
    LatLng(41.3000, 43.4500),
    LatLng(41.3000, 46.1000),
    LatLng(40.9000, 46.5500),
    LatLng(39.8600, 46.5500),
    LatLng(38.8500, 46.5500),
    LatLng(38.8500, 45.5000),
    LatLng(39.1800, 44.8000),
    LatLng(39.6000, 43.9000),
    LatLng(40.1000, 43.4700),
    LatLng(40.8000, 43.4000),
  ];

  static bool _isInArmenia(LatLng point) {
    var inside = false;
    for (
      var i = 0, j = _armeniaBoundary.length - 1;
      i < _armeniaBoundary.length;
      j = i++
    ) {
      final a = _armeniaBoundary[i];
      final b = _armeniaBoundary[j];
      final intersects =
          ((a.longitude > point.longitude) !=
              (b.longitude > point.longitude)) &&
          (point.latitude <
              (b.latitude - a.latitude) *
                      (point.longitude - a.longitude) /
                      (b.longitude - a.longitude) +
                  a.latitude);
      if (intersects) inside = !inside;
    }
    return inside;
  }

  static bool _geometryStaysInArmenia(List<LatLng> geometry) =>
      geometry.isNotEmpty && geometry.every(_isInArmenia);

  static double _distance(LatLng first, LatLng second) {
    const earthRadiusKm = 6371.0;
    final lat1 = first.latitude * math.pi / 180;
    final lat2 = second.latitude * math.pi / 180;
    final deltaLat = (second.latitude - first.latitude) * math.pi / 180;
    final deltaLon = (second.longitude - first.longitude) * math.pi / 180;
    final a =
        math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(deltaLon / 2) *
            math.sin(deltaLon / 2);
    return earthRadiusKm * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  static const Map<int, List<int>> _safeCorridorEdges = {
    0: [1, 6, 8, 9, 11],
    1: [0, 2],
    2: [1, 3],
    3: [2, 4, 5],
    4: [3, 5, 6, 7],
    5: [3, 4],
    6: [0, 4, 7],
    7: [4, 6],
    8: [0],
    9: [0, 10, 11],
    10: [9],
    11: [0, 9, 12],
    12: [11, 13],
    13: [12],
  };

  static Future<RouteResult> getArmeniaDrivingRoute(
    LatLng start,
    LatLng end,
  ) async {
    if (!_isInArmenia(start) || !_isInArmenia(end)) {
      throw const FormatException('A trip destination is outside Armenia.');
    }

    final direct = await getDrivingRoute([start, end]);
    if (_geometryStaysInArmenia(direct.geometry)) {
      return direct;
    }

    final via = _safeArmeniaWaypoints(start, end);
    final geometry = <LatLng>[];
    var distance = 0.0;
    var duration = 0.0;

    for (var i = 0; i < via.length - 1; i++) {
      final segment = await getDrivingRoute([via[i], via[i + 1]]);
      final inside = segment.geometry.where(_isInArmenia).toList();
      if (inside.length < 2) {
        throw const FormatException(
          'No route through Armenia was found for these destinations.',
        );
      }
      distance += segment.distanceMeters;
      duration += segment.durationSeconds;
      if (geometry.isEmpty) {
        geometry.addAll(inside);
      } else if (geometry.last == inside.first) {
        geometry.addAll(inside.skip(1));
      } else {
        geometry.addAll(inside);
      }
    }

    return RouteResult(
      geometry: geometry,
      distanceMeters: distance,
      durationSeconds: duration,
    );
  }

  static List<LatLng> _safeArmeniaWaypoints(LatLng start, LatLng end) {
    final startIndex = _nearestWaypointIndex(start);
    final endIndex = _nearestWaypointIndex(end);
    final distances = List<double>.filled(
      _mainArmeniaWaypoints.length,
      double.infinity,
    );
    final previous = List<int>.filled(_mainArmeniaWaypoints.length, -1);
    final visited = List<bool>.filled(_mainArmeniaWaypoints.length, false);
    distances[startIndex] = 0;

    while (true) {
      var current = -1;
      var smallest = double.infinity;
      for (var i = 0; i < distances.length; i++) {
        if (!visited[i] && distances[i] < smallest) {
          smallest = distances[i];
          current = i;
        }
      }
      if (current == -1) break;
      visited[current] = true;
      if (current == endIndex) break;
      for (final next in _safeCorridorEdges[current] ?? const <int>[]) {
        if (visited[next]) continue;
        final candidate =
            distances[current] +
            _distance(
              _mainArmeniaWaypoints[current],
              _mainArmeniaWaypoints[next],
            );
        if (candidate < distances[next]) {
          distances[next] = candidate;
          previous[next] = current;
        }
      }
    }

    var chain = <LatLng>[];
    var at = endIndex;
    while (at != -1) {
      chain.add(_mainArmeniaWaypoints[at]);
      if (at == startIndex) break;
      at = previous[at];
    }
    chain = chain.reversed.toList();
    if (!chain.contains(_mainArmeniaWaypoints[startIndex])) {
      chain
        ..clear()
        ..add(_mainArmeniaWaypoints[startIndex])
        ..add(_mainArmeniaWaypoints[endIndex]);
    }
    chain
      ..insert(0, start)
      ..add(end);
    return chain;
  }

  static int _nearestWaypointIndex(LatLng point) {
    var nearest = 0;
    var nearestDistance = double.infinity;
    for (var i = 0; i < _mainArmeniaWaypoints.length; i++) {
      final candidate = _distance(point, _mainArmeniaWaypoints[i]);
      if (candidate < nearestDistance) {
        nearestDistance = candidate;
        nearest = i;
      }
    }
    return nearest;
  }

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
