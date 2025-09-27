import 'package:equatable/equatable.dart';
import '../../data/models/portfolio_item.dart';

/// Base class for all portfolio-related events
abstract class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load the user's portfolio from local storage
class LoadPortfolio extends PortfolioEvent {
  const LoadPortfolio();
}

/// Event to refresh the portfolio with latest prices
class RefreshPortfolio extends PortfolioEvent {
  const RefreshPortfolio();
}

/// Event to add a new asset to the portfolio
class AddAsset extends PortfolioEvent {
  /// The portfolio item to add
  final PortfolioItem item;

  const AddAsset(this.item);

  @override
  List<Object> get props => [item];
}

/// Event to remove an asset from the portfolio
class RemoveAsset extends PortfolioEvent {
  /// The ID of the coin to remove
  final String coinId;

  const RemoveAsset(this.coinId);

  @override
  List<Object> get props => [coinId];
}

/// Event to update prices for all assets in the portfolio
class UpdatePrices extends PortfolioEvent {
  const UpdatePrices();
}
