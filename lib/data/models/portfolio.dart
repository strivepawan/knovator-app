import 'portfolio_item.dart';

/// Represents the user's complete cryptocurrency portfolio
class Portfolio {
  /// List of cryptocurrency holdings in the portfolio
  final List<PortfolioItem> items;
  
  /// Timestamp of the last portfolio update
  final DateTime lastUpdated;

  const Portfolio({
    required this.items,
    required this.lastUpdated,
  });

  /// Calculates the total value of the entire portfolio
  double get totalValue {
    return items.fold(0.0, (sum, item) => sum + item.holdingValue);
  }

  /// Creates a Portfolio instance from JSON data
  factory Portfolio.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => PortfolioItem.fromJson(item as Map<String, dynamic>))
        .toList() ?? [];
    
    return Portfolio(
      items: itemsList,
      lastUpdated: DateTime.parse(json['lastUpdated'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Converts the Portfolio instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Creates a copy of this Portfolio with the given fields replaced
  Portfolio copyWith({
    List<PortfolioItem>? items,
    DateTime? lastUpdated,
  }) {
    return Portfolio(
      items: items ?? this.items,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Adds a new item to the portfolio or updates quantity if it already exists
  Portfolio addItem(PortfolioItem item) {
    final existingIndex = items.indexWhere((existing) => existing.coinId == item.coinId);
    
    if (existingIndex != -1) {
      // Update existing item by adding quantities
      final updatedItems = List<PortfolioItem>.from(items);
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + item.quantity,
      );
      return copyWith(items: updatedItems);
    } else {
      // Add new item
      return copyWith(items: [...items, item]);
    }
  }

  /// Removes an item from the portfolio by coin ID
  Portfolio removeItem(String coinId) {
    return copyWith(
      items: items.where((item) => item.coinId != coinId).toList(),
    );
  }

  /// Updates the current prices for all items in the portfolio
  Portfolio updatePrices(Map<String, double> prices) {
    final updatedItems = items.map((item) {
      final price = prices[item.coinId];
      return price != null ? item.copyWith(currentPrice: price) : item;
    }).toList();
    
    return copyWith(items: updatedItems);
  }
}
