# Portfolio Management Feature

## Purpose
This feature manages the user's cryptocurrency portfolio, including adding, removing, and updating assets with real-time price data.

## Architecture

### Domain Layer
- **Events**: `PortfolioEvent` - Defines all portfolio-related events
- **States**: `PortfolioState` - Manages portfolio state transitions
- **Models**: `Portfolio`, `PortfolioItem` - Core business entities

### Data Layer
- **Services**: `ApiService`, `StorageService` - Handle external data and persistence
- **Models**: Data transfer objects for API and storage

### Presentation Layer
- **BLoC**: `PortfolioBloc` - Manages portfolio business logic
- **Screens**: `PortfolioScreen` - UI for portfolio display
- **Widgets**: Private widget classes for UI components

## Key Features

### Portfolio Operations
- **Load Portfolio**: Retrieves saved portfolio from local storage
- **Add Asset**: Adds new cryptocurrency to portfolio
- **Remove Asset**: Removes cryptocurrency from portfolio
- **Update Prices**: Fetches latest prices for all holdings
- **Refresh Portfolio**: Manual refresh with pull-to-refresh

### Data Persistence
- **Local Storage**: Uses SharedPreferences for portfolio persistence
- **JSON Serialization**: Converts portfolio objects to/from JSON
- **Error Handling**: Graceful handling of storage failures

### Real-time Updates
- **Price Fetching**: Optimized API calls for owned cryptocurrencies only
- **Background Updates**: Automatic price updates on app launch
- **Manual Refresh**: User-triggered price updates

## Usage

### Adding Assets
```dart
context.read<PortfolioBloc>().add(AddAsset(portfolioItem));
```

### Removing Assets
```dart
context.read<PortfolioBloc>().add(RemoveAsset(coinId));
```

### Refreshing Portfolio
```dart
context.read<PortfolioBloc>().add(const RefreshPortfolio());
```

## State Management

### States
- `PortfolioInitial`: Initial state before loading
- `PortfolioLoading`: Loading portfolio data
- `PortfolioLoaded`: Portfolio successfully loaded
- `PortfolioError`: Error occurred during operation

### Events
- `LoadPortfolio`: Load portfolio from storage
- `RefreshPortfolio`: Refresh with latest prices
- `AddAsset`: Add new asset to portfolio
- `RemoveAsset`: Remove asset from portfolio
- `UpdatePrices`: Update prices for all assets

## Error Handling

### API Errors
- Network connectivity issues
- API rate limiting
- Invalid responses

### Storage Errors
- JSON serialization failures
- Storage permission issues
- Corrupted data

### User Input Errors
- Invalid quantity values
- Duplicate asset additions
- Missing required fields

## Performance Optimizations

### Efficient API Calls
- Only fetch prices for owned cryptocurrencies
- Batch API requests for multiple coins
- Cache API responses locally

### Memory Management
- Dispose of controllers and focus nodes
- Limit search results to prevent memory issues
- Efficient data structures for large coin lists

## Testing

### Unit Tests
- Portfolio model operations
- BLoC event handling
- Service layer functionality

### Widget Tests
- UI component rendering
- User interaction handling
- State-based UI updates

### Integration Tests
- End-to-end portfolio workflows
- API integration testing
- Storage persistence testing
