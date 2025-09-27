import 'package:equatable/equatable.dart';
import '../models/portfolio_item.dart';

abstract class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object?> get props => [];
}

class LoadPortfolio extends PortfolioEvent {
  const LoadPortfolio();
}

class RefreshPortfolio extends PortfolioEvent {
  const RefreshPortfolio();
}

class AddAsset extends PortfolioEvent {
  final PortfolioItem item;

  const AddAsset(this.item);

  @override
  List<Object> get props => [item];
}

class RemoveAsset extends PortfolioEvent {
  final String coinId;

  const RemoveAsset(this.coinId);

  @override
  List<Object> get props => [coinId];
}

class UpdatePrices extends PortfolioEvent {
  const UpdatePrices();
}
