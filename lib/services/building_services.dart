import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/buildings.dart';

class BuildingService {
  static const String _baseUrl = 'http://10.0.2.2:3000';

  Future<List<Buildings>> getBuildings({int page = 1}) async {
    try {
      final url = Uri.parse('$_baseUrl/api/all?page=$page');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List<dynamic> listaJson = data['buildings'];

        return listaJson.map((mapa) => Buildings.fromMap(mapa)).toList();
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar: $e');
    }
  }
}
