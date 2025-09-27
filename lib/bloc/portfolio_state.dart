import 'package:equatable/equatable.dart';
import '../models/portfolio.dart';

abstract class PortfolioState extends Equatable {
  const PortfolioState();

  @override
  List<Object?> get props => [];
}

class PortfolioInitial extends PortfolioState {
  const PortfolioInitial();
}

class PortfolioLoading extends PortfolioState {
  const PortfolioLoading();
}

class PortfolioLoaded extends PortfolioState {
  final Portfolio portfolio;
  final bool isRefreshing;

  const PortfolioLoaded({
    required this.portfolio,
    this.isRefreshing = false,
  });

  @override
  List<Object> get props => [portfolio, isRefreshing];
}

class PortfolioError extends PortfolioState {
  final String message;

  const PortfolioError(this.message);

  @override
  List<Object> get props => [message];
}
