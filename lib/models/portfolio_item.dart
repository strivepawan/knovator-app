class PortfolioItem {
  final String coinId;
  final String symbol;
  final String name;
  final double quantity;
  final double? currentPrice;
  final String? image;

  const PortfolioItem({
    required this.coinId,
    required this.symbol,
    required this.name,
    required this.quantity,
    this.currentPrice,
    this.image,
  });

  double get holdingValue {
    if (currentPrice == null) return 0.0;
    return quantity * currentPrice!;
  }

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
}
