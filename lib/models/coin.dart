class Coin {
  final String id;
  final String symbol;
  final String name;
  final String? image;
  final double? currentPrice;
  final double? marketCap;
  final double? priceChange24h;
  final double? priceChangePercentage24h;

  const Coin({
    required this.id,
    required this.symbol,
    required this.name,
    this.image,
    this.currentPrice,
    this.marketCap,
    this.priceChange24h,
    this.priceChangePercentage24h,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      image: json['image'],
      currentPrice: json['current_price']?.toDouble(),
      marketCap: json['market_cap']?.toDouble(),
      priceChange24h: json['price_change_24h']?.toDouble(),
      priceChangePercentage24h: json['price_change_percentage_24h']?.toDouble(),
    );
  }

  factory Coin.fromSimpleJson(Map<String, dynamic> json, String coinId) {
    final priceData = json[coinId];
    return Coin(
      id: coinId,
      symbol: priceData?['symbol'] ?? '',
      name: priceData?['name'] ?? '',
      currentPrice: priceData?['usd']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': image,
      'current_price': currentPrice,
      'market_cap': marketCap,
      'price_change_24h': priceChange24h,
      'price_change_percentage_24h': priceChangePercentage24h,
    };
  }

  Coin copyWith({
    String? id,
    String? symbol,
    String? name,
    String? image,
    double? currentPrice,
    double? marketCap,
    double? priceChange24h,
    double? priceChangePercentage24h,
  }) {
    return Coin(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      image: image ?? this.image,
      currentPrice: currentPrice ?? this.currentPrice,
      marketCap: marketCap ?? this.marketCap,
      priceChange24h: priceChange24h ?? this.priceChange24h,
      priceChangePercentage24h: priceChangePercentage24h ?? this.priceChangePercentage24h,
    );
  }
}
