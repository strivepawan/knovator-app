import 'package:equatable/equatable.dart';
import '../../data/models/coin.dart';

/// Base class for all search-related states
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// Initial state when no search has been performed
class SearchInitial extends SearchState {
  const SearchInitial();
}

/// State when the search is being performed
class SearchLoading extends SearchState {
  const SearchLoading();
}

/// State when the search has been completed successfully
class SearchLoaded extends SearchState {
  /// The list of coins found in the search
  final List<Coin> coins;

  const SearchLoaded({required this.coins});

  @override
  List<Object> get props => [coins];
}

/// State when an error occurs during search
class SearchError extends SearchState {
  /// The error message to display
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}
