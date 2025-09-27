import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coin.dart';

class ApiService {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';
  
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Coin>> getCoinsList() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/coins/list'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Coin.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load coins list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching coins list: $e');
    }
  }

  Future<Map<String, double>> getCurrentPrices(List<String> coinIds) async {
    try {
      if (coinIds.isEmpty) return {};

      final ids = coinIds.join(',');
      final response = await _client.get(
        Uri.parse('$_baseUrl/simple/price?ids=$ids&vs_currencies=usd'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final Map<String, double> prices = {};
        
        jsonData.forEach((coinId, data) {
          if (data is Map<String, dynamic> && data['usd'] != null) {
            prices[coinId] = (data['usd'] as num).toDouble();
          }
        });
        
        return prices;
      } else {
        throw Exception('Failed to load prices: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching prices: $e');
    }
  }

  Future<List<Coin>> searchCoins(String query) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/search?query=$query'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> coinsList = jsonData['coins'] ?? [];
        return coinsList.map((json) => Coin.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search coins: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching coins: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
