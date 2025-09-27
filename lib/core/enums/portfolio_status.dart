/// Enum representing the different states of portfolio operations
enum PortfolioStatus {
  initial,
  loading,
  loaded,
  error,
  refreshing,
}

/// Extension providing boolean getters for PortfolioStatus enum
extension PortfolioStatusX on PortfolioStatus {
  /// Returns true if the portfolio is in initial state
  bool get isInitial => this == PortfolioStatus.initial;
  
  /// Returns true if the portfolio is currently loading
  bool get isLoading => this == PortfolioStatus.loading;
  
  /// Returns true if the portfolio has been successfully loaded
  bool get isLoaded => this == PortfolioStatus.loaded;
  
  /// Returns true if the portfolio is in error state
  bool get isError => this == PortfolioStatus.error;
  
  /// Returns true if the portfolio is currently refreshing
  bool get isRefreshing => this == PortfolioStatus.refreshing;
}
