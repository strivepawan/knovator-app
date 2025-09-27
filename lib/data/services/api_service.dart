import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coin.dart';

/// Service responsible for making API calls to CoinGecko
class ApiService {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';
  
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches the complete list of all cryptocurrencies from CoinGecko
  /// 
  /// Returns a list of all supported cryptocurrencies with their basic information
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

  /// Fetches current prices for the specified cryptocurrency IDs
  /// 
  /// [coinIds] - List of cryptocurrency IDs to fetch prices for
  /// Returns a map of coin ID to current USD price
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

  /// Searches for cryptocurrencies based on the given query
  /// 
  /// [query] - The search term to look for
  /// Returns a list of matching cryptocurrencies
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

  /// Disposes of the HTTP client to free up resources
  void dispose() {
    _client.close();
  }
}
