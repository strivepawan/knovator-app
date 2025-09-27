import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../domain/events/search_event.dart';
import '../../../domain/states/search_state.dart';
import '../../../domain/events/portfolio_event.dart';
import '../../../presentation/blocs/search_bloc.dart';
import '../../../presentation/blocs/portfolio_bloc.dart';
import '../../../data/models/coin.dart';
import '../../../data/models/portfolio_item.dart';

/// Screen for adding new cryptocurrency assets to the portfolio
class AddAssetScreen extends StatefulWidget {
  const AddAssetScreen({super.key});

  @override
  State<AddAssetScreen> createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends State<AddAssetScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _quantityFocusNode = FocusNode();
  Coin? _selectedCoin;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _quantityController.dispose();
    _searchFocusNode.dispose();
    _quantityFocusNode.dispose();
    super.dispose();
  }

  /// Handles search query changes
  void _onSearchChanged(String query) {
    context.read<SearchBloc>().add(SearchQueryChanged(query));
  }

  /// Handles coin selection from search results
  void _onCoinSelected(Coin coin) {
    setState(() {
      _selectedCoin = coin;
    });
    _searchController.text = '${coin.name} (${coin.symbol.toUpperCase()})';
    _quantityFocusNode.requestFocus();
    context.read<SearchBloc>().add(const ClearSearch());
  }

  /// Adds the selected asset to the portfolio
  void _addAsset() {
    if (_selectedCoin == null) {
      _showErrorDialog('Please select a cryptocurrency');
      return;
    }

    final quantity = double.tryParse(_quantityController.text);
    if (quantity == null || quantity <= 0) {
      _showErrorDialog('Please enter a valid quantity');
      return;
    }

    final portfolioItem = PortfolioItem(
      coinId: _selectedCoin!.id,
      symbol: _selectedCoin!.symbol,
      name: _selectedCoin!.name,
      quantity: quantity,
    );

    context.read<PortfolioBloc>().add(AddAsset(portfolioItem));
    Navigator.of(context).pop();
  }

  /// Shows error dialog with the given message
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const _AppBar(),
      body: Column(
        children: [
          _SearchSection(
            searchController: _searchController,
            quantityController: _quantityController,
            searchFocusNode: _searchFocusNode,
            quantityFocusNode: _quantityFocusNode,
            onSearchChanged: _onSearchChanged,
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchInitial) {
                  return const _InitialState();
                }

                if (state is SearchLoading) {
                  return const _LoadingState();
                }

                if (state is SearchError) {
                  return _ErrorState(message: state.message);
                }

                if (state is SearchLoaded) {
                  return _SearchResults(
                    coins: state.coins,
                    onCoinSelected: _onCoinSelected,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// App bar for the add asset screen
class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Add Asset'),
      centerTitle: true,
      actions: [
        FilledButton(
          onPressed: () {
            // This will be handled by the parent widget
            final parentState = context.findAncestorStateOfType<_AddAssetScreenState>();
            parentState?._addAsset();
          },
          child: const Text('Save'),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Search section with input fields
class _SearchSection extends StatelessWidget {
  final TextEditingController searchController;
  final TextEditingController quantityController;
  final FocusNode searchFocusNode;
  final FocusNode quantityFocusNode;
  final Function(String) onSearchChanged;

  const _SearchSection({
    required this.searchController,
    required this.quantityController,
    required this.searchFocusNode,
    required this.quantityFocusNode,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search for a cryptocurrency',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: searchController,
            focusNode: searchFocusNode,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Enter coin name or symbol (e.g., Bitcoin, BTC)',
              prefixIcon: const Icon(Icons.search_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Enter quantity',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: quantityController,
            focusNode: quantityFocusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: '0.00000000',
              prefixIcon: const Icon(Icons.account_balance_wallet_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }
}

/// Initial state when no search has been performed
class _InitialState extends StatelessWidget {
  const _InitialState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Search for cryptocurrencies',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Type the name or symbol of the coin you want to add',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Loading state during search
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

/// Error state when search fails
class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// Search results list
class _SearchResults extends StatelessWidget {
  final List<Coin> coins;
  final Function(Coin) onCoinSelected;

  const _SearchResults({
    required this.coins,
    required this.onCoinSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (coins.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No coins found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: coins.length,
      itemBuilder: (context, index) {
        final coin = coins[index];
        return _CoinItem(
          coin: coin,
          index: index,
          onTap: () => onCoinSelected(coin),
        );
      },
    );
  }
}

/// Individual coin item in search results
class _CoinItem extends StatelessWidget {
  final Coin coin;
  final int index;
  final VoidCallback onTap;

  const _CoinItem({
    required this.coin,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      coin.symbol.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coin.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        coin.symbol.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.add_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: (index * 50).ms).fadeIn(duration: 300.ms).slideX(begin: 0.3, end: 0);
  }
}
