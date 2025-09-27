/// Represents a single cryptocurrency holding in the user's portfolio
class PortfolioItem {
  /// Unique identifier for the cryptocurrency
  final String coinId;
  
  /// Symbol of the cryptocurrency (e.g., 'BTC', 'ETH')
  final String symbol;
  
  /// Full name of the cryptocurrency
  final String name;
  
  /// Quantity of the cryptocurrency owned
  final double quantity;
  
  /// Current market price per unit
  final double? currentPrice;
  
  /// URL to the cryptocurrency's image/logo
  final String? image;

  const PortfolioItem({
    required this.coinId,
    required this.symbol,
    required this.name,
    required this.quantity,
    this.currentPrice,
    this.image,
  });

  /// Calculates the total value of this holding (quantity × current price)
  double get holdingValue {
    if (currentPrice == null) return 0.0;
    return quantity * currentPrice!;
  }

  /// Creates a PortfolioItem instance from JSON data
  factory PortfolioItem.fromJson(Map<String, dynamic> json) {
    return PortfolioItem(
      coinId: json['coinId'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      quantity: (json['quantity'] ?? 0.0).toDouble(),
      currentPrice: json['currentPrice']?.toDouble(),
      image: json['image'],
    );
  }

  /// Converts the PortfolioItem instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'coinId': coinId,
      'symbol': symbol,
      'name': name,
      'quantity': quantity,
      'currentPrice': currentPrice,
      'image': image,
    };
  }

  /// Creates a copy of this PortfolioItem with the given fields replaced
  PortfolioItem copyWith({
    String? coinId,
    String? symbol,
    String? name,
    double? quantity,
    double? currentPrice,
    String? image,
  }) {
    return PortfolioItem(
      coinId: coinId ?? this.coinId,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      currentPrice: currentPrice ?? this.currentPrice,
      image: image ?? this.image,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PortfolioItem && other.coinId == coinId;
  }

  @override
  int get hashCode => coinId.hashCode;
}
