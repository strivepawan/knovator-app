import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/portfolio.dart';
import '../../data/services/api_service.dart';
import '../../data/services/storage_service.dart';
import '../../domain/events/portfolio_event.dart';
import '../../domain/states/portfolio_state.dart';

/// BLoC responsible for managing portfolio state and business logic
class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final ApiService _apiService;
  final StorageService _storageService;

  PortfolioBloc({
    required ApiService apiService,
    required StorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService,
        super(const PortfolioInitial()) {
    on<LoadPortfolio>(_onLoadPortfolio);
    on<RefreshPortfolio>(_onRefreshPortfolio);
    on<AddAsset>(_onAddAsset);
    on<RemoveAsset>(_onRemoveAsset);
    on<UpdatePrices>(_onUpdatePrices);
  }

  /// Handles loading the portfolio from local storage
  Future<void> _onLoadPortfolio(
    LoadPortfolio event,
    Emitter<PortfolioState> emit,
  ) async {
    try {
      emit(const PortfolioLoading());
      
      final portfolio = await _storageService.getPortfolio();
      
      if (portfolio != null && portfolio.items.isNotEmpty) {
        // Load current prices for existing portfolio
        final coinIds = portfolio.items.map((item) => item.coinId).toList();
        final prices = await _apiService.getCurrentPrices(coinIds);
        final updatedPortfolio = portfolio.updatePrices(prices);
        
        emit(PortfolioLoaded(portfolio: updatedPortfolio));
      } else {
        // Create empty portfolio
        final emptyPortfolio = Portfolio(
          items: [],
          lastUpdated: DateTime.now(),
        );
        emit(PortfolioLoaded(portfolio: emptyPortfolio));
      }
    } catch (e) {
      emit(PortfolioError('Failed to load portfolio: $e'));
    }
  }

  /// Handles refreshing the portfolio with latest prices
  Future<void> _onRefreshPortfolio(
    RefreshPortfolio event,
    Emitter<PortfolioState> emit,
  ) async {
    if (state is! PortfolioLoaded) return;

    final currentState = state as PortfolioLoaded;
    emit(PortfolioLoaded(
      portfolio: currentState.portfolio,
      isRefreshing: true,
    ));

    try {
      final coinIds = currentState.portfolio.items.map((item) => item.coinId).toList();
      final prices = await _apiService.getCurrentPrices(coinIds);
      final updatedPortfolio = currentState.portfolio.updatePrices(prices);
      
      await _storageService.savePortfolio(updatedPortfolio);
      emit(PortfolioLoaded(portfolio: updatedPortfolio));
    } catch (e) {
      emit(PortfolioError('Failed to refresh portfolio: $e'));
    }
  }

  /// Handles adding a new asset to the portfolio
  Future<void> _onAddAsset(
    AddAsset event,
    Emitter<PortfolioState> emit,
  ) async {
    if (state is! PortfolioLoaded) return;

    try {
      final currentState = state as PortfolioLoaded;
      final updatedPortfolio = currentState.portfolio.addItem(event.item);
      
      await _storageService.savePortfolio(updatedPortfolio);
      emit(PortfolioLoaded(portfolio: updatedPortfolio));
    } catch (e) {
      emit(PortfolioError('Failed to add asset: $e'));
    }
  }

  /// Handles removing an asset from the portfolio
  Future<void> _onRemoveAsset(
    RemoveAsset event,
    Emitter<PortfolioState> emit,
  ) async {
    if (state is! PortfolioLoaded) return;

    try {
      final currentState = state as PortfolioLoaded;
      final updatedPortfolio = currentState.portfolio.removeItem(event.coinId);
      
      await _storageService.savePortfolio(updatedPortfolio);
      emit(PortfolioLoaded(portfolio: updatedPortfolio));
    } catch (e) {
      emit(PortfolioError('Failed to remove asset: $e'));
    }
  }

  /// Handles updating prices for all assets in the portfolio
  Future<void> _onUpdatePrices(
    UpdatePrices event,
    Emitter<PortfolioState> emit,
  ) async {
    if (state is! PortfolioLoaded) return;

    try {
      final currentState = state as PortfolioLoaded;
      final coinIds = currentState.portfolio.items.map((item) => item.coinId).toList();
      final prices = await _apiService.getCurrentPrices(coinIds);
      final updatedPortfolio = currentState.portfolio.updatePrices(prices);
      
      await _storageService.savePortfolio(updatedPortfolio);
      emit(PortfolioLoaded(portfolio: updatedPortfolio));
    } catch (e) {
      emit(PortfolioError('Failed to update prices: $e'));
    }
  }
}
