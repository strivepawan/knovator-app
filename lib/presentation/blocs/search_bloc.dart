import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/coin.dart';
import '../../data/services/api_service.dart';
import '../../data/services/storage_service.dart';
import '../../domain/events/search_event.dart';
import '../../domain/states/search_state.dart';

/// BLoC responsible for managing search state and business logic
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiService _apiService;
  final StorageService _storageService;
  List<Coin> _allCoins = [];

  SearchBloc({
    required ApiService apiService,
    required StorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService,
        super(const SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<ClearSearch>(_onClearSearch);
  }

  /// Handles search query changes and performs local filtering
  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    try {
      emit(const SearchLoading());

      // Load coins list if not already loaded
      if (_allCoins.isEmpty) {
        await _loadCoinsList();
      }

      // Filter coins based on query
      final filteredCoins = _allCoins.where((coin) {
        final query = event.query.toLowerCase();
        return coin.name.toLowerCase().contains(query) ||
               coin.symbol.toLowerCase().contains(query);
      }).take(20).toList();

      emit(SearchLoaded(coins: filteredCoins));
    } catch (e) {
      emit(SearchError('Failed to search coins: $e'));
    }
  }

  /// Handles clearing the current search
  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<SearchState> emit,
  ) async {
    emit(const SearchInitial());
  }

  /// Loads the coins list from local storage or API
  Future<void> _loadCoinsList() async {
    try {
      // Check if we should refresh the coins list
      final shouldRefresh = await _storageService.shouldRefreshCoinsList();
      
      if (!shouldRefresh) {
        // Try to load from local storage first
        final localCoins = await _storageService.getCoinsList();
        if (localCoins != null) {
          _allCoins = localCoins.map((json) => Coin.fromJson(json)).toList();
          return;
        }
      }

      // Fetch from API
      _allCoins = await _apiService.getCoinsList();
      
      // Save to local storage
      final coinsJson = _allCoins.map((coin) => coin.toJson()).toList();
      await _storageService.saveCoinsList(coinsJson);
    } catch (e) {
      // If API fails, try to load from local storage
      final localCoins = await _storageService.getCoinsList();
      if (localCoins != null) {
        _allCoins = localCoins.map((json) => Coin.fromJson(json)).toList();
      } else {
        rethrow;
      }
    }
  }
}
