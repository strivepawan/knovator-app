import 'package:flutter_test/flutter_test.dart';
import 'package:crypto_portfolio_tracker/models/portfolio.dart';
import 'package:crypto_portfolio_tracker/models/portfolio_item.dart';

void main() {
  group('Portfolio Tests', () {
    test('should create empty portfolio', () {
      final portfolio = Portfolio(
        items: [],
        lastUpdated: DateTime.now(),
      );
      
      expect(portfolio.items.length, 0);
      expect(portfolio.totalValue, 0.0);
    });

    test('should add item to portfolio', () {
      final portfolio = Portfolio(
        items: [],
        lastUpdated: DateTime.now(),
      );
      
      final item = PortfolioItem(
        coinId: 'bitcoin',
        symbol: 'btc',
        name: 'Bitcoin',
        quantity: 0.5,
        currentPrice: 50000.0,
      );
      
      final updatedPortfolio = portfolio.addItem(item);
      
      expect(updatedPortfolio.items.length, 1);
      expect(updatedPortfolio.totalValue, 25000.0);
    });

    test('should handle duplicate coins by adding quantities', () {
      final portfolio = Portfolio(
        items: [],
        lastUpdated: DateTime.now(),
      );
      
      final item1 = PortfolioItem(
        coinId: 'bitcoin',
        symbol: 'btc',
        name: 'Bitcoin',
        quantity: 0.5,
        currentPrice: 50000.0,
      );
      
      final item2 = PortfolioItem(
        coinId: 'bitcoin',
        symbol: 'btc',
        name: 'Bitcoin',
        quantity: 0.3,
        currentPrice: 50000.0,
      );
      
      final updatedPortfolio = portfolio.addItem(item1).addItem(item2);
      
      expect(updatedPortfolio.items.length, 1);
      expect(updatedPortfolio.items.first.quantity, 0.8);
    });

    test('should remove item from portfolio', () {
      final item = PortfolioItem(
        coinId: 'bitcoin',
        symbol: 'btc',
        name: 'Bitcoin',
        quantity: 0.5,
        currentPrice: 50000.0,
      );
      
      final portfolio = Portfolio(
        items: [item],
        lastUpdated: DateTime.now(),
      );
      
      final updatedPortfolio = portfolio.removeItem('bitcoin');
      
      expect(updatedPortfolio.items.length, 0);
    });

    test('should update prices correctly', () {
      final item = PortfolioItem(
        coinId: 'bitcoin',
        symbol: 'btc',
        name: 'Bitcoin',
        quantity: 0.5,
        currentPrice: 50000.0,
      );
      
      final portfolio = Portfolio(
        items: [item],
        lastUpdated: DateTime.now(),
      );
      
      final prices = {'bitcoin': 60000.0};
      final updatedPortfolio = portfolio.updatePrices(prices);
      
      expect(updatedPortfolio.items.first.currentPrice, 60000.0);
      expect(updatedPortfolio.totalValue, 30000.0);
    });
  });

  group('PortfolioItem Tests', () {
    test('should calculate holding value correctly', () {
      final item = PortfolioItem(
        coinId: 'bitcoin',
        symbol: 'btc',
        name: 'Bitcoin',
        quantity: 0.5,
        currentPrice: 50000.0,
      );
      
      expect(item.holdingValue, 25000.0);
    });

    test('should handle null current price', () {
      final item = PortfolioItem(
        coinId: 'bitcoin',
        symbol: 'btc',
        name: 'Bitcoin',
        quantity: 0.5,
      );
      
      expect(item.holdingValue, 0.0);
    });
  });
}
