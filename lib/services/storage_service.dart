import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/portfolio.dart';

class StorageService {
  static const String _portfolioKey = 'portfolio';
  static const String _coinsListKey = 'coins_list';
  static const String _lastFetchKey = 'last_coins_fetch';

  Future<Portfolio?> getPortfolio() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final portfolioJson = prefs.getString(_portfolioKey);
      
      if (portfolioJson != null) {
        final Map<String, dynamic> jsonData = json.decode(portfolioJson);
        return Portfolio.fromJson(jsonData);
      }
      return null;
    } catch (e) {
      throw Exception('Error loading portfolio: $e');
    }
  }

  Future<void> savePortfolio(Portfolio portfolio) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final portfolioJson = json.encode(portfolio.toJson());
      await prefs.setString(_portfolioKey, portfolioJson);
    } catch (e) {
      throw Exception('Error saving portfolio: $e');
    }
  }

  Future<void> clearPortfolio() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_portfolioKey);
    } catch (e) {
      throw Exception('Error clearing portfolio: $e');
    }
  }

  Future<List<Map<String, dynamic>>?> getCoinsList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final coinsJson = prefs.getString(_coinsListKey);
      
      if (coinsJson != null) {
        final List<dynamic> jsonList = json.decode(coinsJson);
        return jsonList.cast<Map<String, dynamic>>();
      }
      return null;
    } catch (e) {
      throw Exception('Error loading coins list: $e');
    }
  }

  Future<void> saveCoinsList(List<Map<String, dynamic>> coinsList) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final coinsJson = json.encode(coinsList);
      await prefs.setString(_coinsListKey, coinsJson);
      await prefs.setString(_lastFetchKey, DateTime.now().toIso8601String());
    } catch (e) {
      throw Exception('Error saving coins list: $e');
    }
  }

  Future<DateTime?> getLastCoinsFetch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastFetchString = prefs.getString(_lastFetchKey);
      
      if (lastFetchString != null) {
        return DateTime.parse(lastFetchString);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> shouldRefreshCoinsList() async {
    try {
      final lastFetch = await getLastCoinsFetch();
      if (lastFetch == null) return true;
      
      // Refresh if last fetch was more than 24 hours ago
      return DateTime.now().difference(lastFetch).inHours > 24;
    } catch (e) {
      return true;
    }
  }
}
