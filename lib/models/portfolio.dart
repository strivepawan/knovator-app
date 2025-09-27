import 'portfolio_item.dart';

class Portfolio {
  final List<PortfolioItem> items;
  final DateTime lastUpdated;

  const Portfolio({
    required this.items,
    required this.lastUpdated,
  });

  double get totalValue {
    return items.fold(0.0, (sum, item) => sum + item.holdingValue);
  }

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => PortfolioItem.fromJson(item as Map<String, dynamic>))
        .toList() ?? [];
    
    return Portfolio(
      items: itemsList,
      lastUpdated: DateTime.parse(json['lastUpdated'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  Portfolio copyWith({
    List<PortfolioItem>? items,
    DateTime? lastUpdated,
  }) {
    return Portfolio(
      items: items ?? this.items,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Portfolio addItem(PortfolioItem item) {
    final existingIndex = items.indexWhere((existing) => existing.coinId == item.coinId);
    
    if (existingIndex != -1) {
      // Update existing item
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

  Portfolio removeItem(String coinId) {
    return copyWith(
      items: items.where((item) => item.coinId != coinId).toList(),
    );
  }

  Portfolio updatePrices(Map<String, double> prices) {
    final updatedItems = items.map((item) {
      final price = prices[item.coinId];
      return price != null ? item.copyWith(currentPrice: price) : item;
    }).toList();
    
    return copyWith(items: updatedItems);
  }
}
