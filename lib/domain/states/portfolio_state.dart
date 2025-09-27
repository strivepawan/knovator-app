import 'package:equatable/equatable.dart';
import '../../data/models/portfolio.dart';

/// Base class for all portfolio-related states
abstract class PortfolioState extends Equatable {
  const PortfolioState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the portfolio has not been loaded yet
class PortfolioInitial extends PortfolioState {
  const PortfolioInitial();
}

/// State when the portfolio is being loaded
class PortfolioLoading extends PortfolioState {
  const PortfolioLoading();
}

/// State when the portfolio has been successfully loaded
class PortfolioLoaded extends PortfolioState {
  /// The loaded portfolio data
  final Portfolio portfolio;
  
  /// Whether the portfolio is currently being refreshed
  final bool isRefreshing;

  const PortfolioLoaded({
    required this.portfolio,
    this.isRefreshing = false,
  });

  @override
  List<Object> get props => [portfolio, isRefreshing];
}

/// State when an error occurs while loading the portfolio
class PortfolioError extends PortfolioState {
  /// The error message to display
  final String message;

  const PortfolioError(this.message);

  @override
  List<Object> get props => [message];
}
