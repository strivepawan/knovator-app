import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/portfolio.dart';

/// Service responsible for local data persistence using SharedPreferences
class StorageService {
  static const String _portfolioKey = 'portfolio';
  static const String _coinsListKey = 'coins_list';
  static const String _lastFetchKey = 'last_coins_fetch';

  /// Loads the user's portfolio from local storage
  /// 
  /// Returns the saved portfolio or null if none exists
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

  /// Saves the user's portfolio to local storage
  /// 
  /// [portfolio] - The portfolio to save
  Future<void> savePortfolio(Portfolio portfolio) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final portfolioJson = json.encode(portfolio.toJson());
      await prefs.setString(_portfolioKey, portfolioJson);
    } catch (e) {
      throw Exception('Error saving portfolio: $e');
    }
  }

  /// Clears the user's portfolio from local storage
  Future<void> clearPortfolio() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_portfolioKey);
    } catch (e) {
      throw Exception('Error clearing portfolio: $e');
    }
  }

  /// Loads the cached coins list from local storage
  /// 
  /// Returns the cached coins list or null if none exists
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

  /// Saves the coins list to local storage for offline search
  /// 
  /// [coinsList] - The list of coins to cache
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

  /// Gets the timestamp of the last coins list fetch
  /// 
  /// Returns the last fetch timestamp or null if never fetched
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

  /// Determines if the coins list should be refreshed based on age
  /// 
  /// Returns true if the cached data is older than 24 hours
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
