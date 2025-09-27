/// Enum representing the different states of search operations
enum SearchStatus {
  initial,
  loading,
  loaded,
  error,
}

/// Extension providing boolean getters for SearchStatus enum
extension SearchStatusX on SearchStatus {
  /// Returns true if the search is in initial state
  bool get isInitial => this == SearchStatus.initial;
  
  /// Returns true if the search is currently loading
  bool get isLoading => this == SearchStatus.loading;
  
  /// Returns true if the search has been successfully loaded
  bool get isLoaded => this == SearchStatus.loaded;
  
  /// Returns true if the search is in error state
  bool get isError => this == SearchStatus.error;
}
