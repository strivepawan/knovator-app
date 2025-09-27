# Search Functionality Feature

## Purpose
This feature provides efficient cryptocurrency search capabilities for adding new assets to the portfolio.

## Architecture

### Domain Layer
- **Events**: `SearchEvent` - Defines search-related events
- **States**: `SearchState` - Manages search state transitions
- **Models**: `Coin` - Represents cryptocurrency data

### Data Layer
- **Services**: `ApiService`, `StorageService` - Handle search data
- **Caching**: Local storage for offline search capabilities

### Presentation Layer
- **BLoC**: `SearchBloc` - Manages search business logic
- **Screens**: `AddAssetScreen` - UI for asset search and selection
- **Widgets**: Private widget classes for search components

## Key Features

### Search Operations
- **Real-time Search**: Search as user types
- **Local Filtering**: Fast client-side filtering
- **Offline Search**: Cached coin list for offline functionality
- **Smart Suggestions**: Name and symbol matching

### Data Management
- **Coins List Caching**: Stores thousands of cryptocurrencies locally
- **Efficient Storage**: JSON serialization for fast access
- **Cache Invalidation**: 24-hour cache refresh policy
- **Memory Optimization**: Lazy loading and efficient filtering

### User Experience
- **Instant Results**: No API calls during search
- **Debounced Input**: Prevents excessive filtering
- **Visual Feedback**: Loading states and animations
- **Error Handling**: Graceful error recovery

## Usage

### Starting Search
```dart
context.read<SearchBloc>().add(SearchQueryChanged(query));
```

### Clearing Search
```dart
context.read<SearchBloc>().add(const ClearSearch());
```

### Selecting Coin
```dart
void _onCoinSelected(Coin coin) {
  // Handle coin selection
}
```

## State Management

### States
- `SearchInitial`: No search performed
- `SearchLoading`: Search in progress
- `SearchLoaded`: Search results available
- `SearchError`: Error occurred during search

### Events
- `SearchQueryChanged`: User typed in search field
- `ClearSearch`: Clear current search results

## Search Algorithm

### Filtering Logic
```dart
final filteredCoins = _allCoins.where((coin) {
  final query = event.query.toLowerCase();
  return coin.name.toLowerCase().contains(query) ||
         coin.symbol.toLowerCase().contains(query);
}).take(20).toList();
```

### Performance Optimizations
- **Case-insensitive search**: Convert to lowercase for comparison
- **Partial matching**: Use `contains()` for flexible matching
- **Result limiting**: Limit to 20 results for performance
- **Efficient filtering**: Use `where()` for fast filtering

## Data Flow

### Initial Load
1. Check if coins list needs refresh (24-hour policy)
2. Load from local storage if available
3. Fetch from API if needed
4. Cache results locally

### Search Process
1. User types in search field
2. Trigger `SearchQueryChanged` event
3. Filter cached coins list
4. Emit `SearchLoaded` state with results
5. Display results in UI

### Error Handling
1. API failure: Fall back to cached data
2. Storage failure: Show error message
3. Network issues: Use offline cache
4. Invalid data: Clear and retry

## Caching Strategy

### Cache Keys
- `coins_list`: Cached coins list
- `last_coins_fetch`: Timestamp of last fetch

### Cache Policies
- **Refresh Interval**: 24 hours
- **Storage Method**: SharedPreferences
- **Data Format**: JSON serialization
- **Size Limit**: No explicit limit (handles thousands of coins)

### Cache Invalidation
```dart
Future<bool> shouldRefreshCoinsList() async {
  final lastFetch = await getLastCoinsFetch();
  if (lastFetch == null) return true;
  return DateTime.now().difference(lastFetch).inHours > 24;
}
```

## Performance Considerations

### Memory Usage
- **Lazy Loading**: Load coins list only when needed
- **Efficient Filtering**: Use stream operations
- **Result Limiting**: Cap results to prevent memory issues
- **Garbage Collection**: Proper disposal of resources

### Search Performance
- **Local Filtering**: No network calls during search
- **Optimized Algorithms**: Efficient string matching
- **Debounced Input**: Prevent excessive filtering
- **Cached Results**: Reuse previous search results

### Network Optimization
- **Batch Loading**: Load all coins at once
- **Offline Support**: Work without internet connection
- **Smart Refresh**: Only refresh when necessary
- **Error Recovery**: Graceful fallback to cache

## Testing

### Unit Tests
- Search filtering logic
- Cache management
- BLoC event handling
- Error scenarios

### Widget Tests
- Search input handling
- Result display
- User interactions
- Loading states

### Integration Tests
- End-to-end search workflow
- Cache persistence
- API integration
- Error handling

## Future Enhancements

### Advanced Search
- **Fuzzy Matching**: Handle typos and variations
- **Weighted Results**: Prioritize by popularity
- **Search History**: Remember previous searches
- **Favorites**: Mark frequently used coins

### Performance Improvements
- **Indexing**: Create search indexes for faster lookup
- **Pagination**: Load results in batches
- **Virtual Scrolling**: Handle large result sets
- **Background Updates**: Update cache in background
