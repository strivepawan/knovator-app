/// Represents a cryptocurrency with its basic information
class Coin {
  /// Unique identifier for the coin
  final String id;
  
  /// Symbol of the coin (e.g., 'BTC', 'ETH')
  final String symbol;
  
  /// Full name of the coin (e.g., 'Bitcoin', 'Ethereum')
  final String name;
  
  /// URL to the coin's image/logo
  final String? image;
  
  /// Current market price in USD
  final double? currentPrice;
  
  /// Market capitalization
  final double? marketCap;
  
  /// Price change in the last 24 hours
  final double? priceChange24h;
  
  /// Price change percentage in the last 24 hours
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

  /// Creates a Coin instance from JSON data
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

  /// Creates a Coin instance from simplified price JSON data
  factory Coin.fromSimpleJson(Map<String, dynamic> json, String coinId) {
    final priceData = json[coinId];
    return Coin(
      id: coinId,
      symbol: priceData?['symbol'] ?? '',
      name: priceData?['name'] ?? '',
      currentPrice: priceData?['usd']?.toDouble(),
    );
  }

  /// Converts the Coin instance to JSON
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

  /// Creates a copy of this Coin with the given fields replaced
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Coin && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
