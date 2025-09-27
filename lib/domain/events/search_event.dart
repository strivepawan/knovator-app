import 'package:equatable/equatable.dart';

/// Base class for all search-related events
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

/// Event when the search query changes
class SearchQueryChanged extends SearchEvent {
  /// The new search query
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

/// Event to clear the current search
class ClearSearch extends SearchEvent {
  const ClearSearch();
}
