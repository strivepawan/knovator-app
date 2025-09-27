# Crypto Portfolio Tracker - Architecture Guide

## Overview
This document outlines the architecture and coding patterns used in the Crypto Portfolio Tracker Flutter application, following senior-level development practices and clean architecture principles.

## Architecture Pattern

### Clean Architecture Implementation
The application follows Clean Architecture with clear separation of concerns across three main layers:

1. **Domain Layer** - Business logic and entities
2. **Data Layer** - External data sources and persistence
3. **Presentation Layer** - UI and user interactions

## Directory Structure

```
lib/
├── core/                 # Core functionality
│   ├── enums/           # Application enums with extensions
│   └── theme/           # App theming and design system
├── data/                # Data layer
│   ├── models/          # Data transfer objects
│   └── services/        # External data services
├── domain/              # Domain layer
│   ├── events/          # BLoC events
│   └── states/          # BLoC states
├── presentation/        # Presentation layer
│   ├── blocs/           # BLoC implementations
│   └── screens/         # UI screens with private widgets
└── docs/                # Feature documentation
```

## Coding Conventions

### Widget Architecture
- **Private Widget Classes**: All widgets are implemented as private classes within their screen directories
- **No Function Widgets**: Avoid function-based widgets like `Widget _someWidget() => Container()`
- **File Organization**: Each screen has its own directory with private widget files
- **Widget Naming**: Use descriptive names with underscore prefix for private widgets

### File Structure Examples
```
lib/presentation/screens/portfolio/
├── portfolio_screen.dart          # Main screen
├── widgets/
│   ├── _app_bar.dart              # Private app bar widget
│   ├── _portfolio_header.dart     # Private header widget
│   └── _portfolio_list.dart       # Private list widget
```

### Method Conventions
- **Getters**: Use getters for methods that don't take parameters and return values
- **Documentation**: Use `///` comments focusing on "why", not "how"
- **Method Length**: No single function should exceed 30-50 lines
- **Refactoring**: Break large methods into smaller helper methods

### Enum Usage
- **Enum Extensions**: Create boolean extension getters for all enums
- **Type Safety**: Use enums instead of strings where appropriate
- **Naming**: Use descriptive enum names with clear values

```dart
enum PortfolioStatus {
  initial,
  loading,
  loaded,
  error,
}

extension PortfolioStatusX on PortfolioStatus {
  bool get isInitial => this == PortfolioStatus.initial;
  bool get isLoading => this == PortfolioStatus.loading;
  bool get isLoaded => this == PortfolioStatus.loaded;
  bool get isError => this == PortfolioStatus.error;
}
```

## State Management

### BLoC Pattern Implementation
- **Events**: Define all user actions and system events
- **States**: Represent the current state of the application
- **BLoC**: Handle business logic and state transitions
- **Separation**: Clear separation between UI and business logic

### Event-Driven Architecture
```dart
// Events define what can happen
abstract class PortfolioEvent extends Equatable {
  const PortfolioEvent();
}

// States define the current condition
abstract class PortfolioState extends Equatable {
  const PortfolioState();
}

// BLoC handles the business logic
class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  // Implementation
}
```

## Data Layer

### Service Pattern
- **API Service**: Handles external API calls
- **Storage Service**: Manages local data persistence
- **Error Handling**: Comprehensive error management
- **Caching**: Efficient data caching strategies

### Model Design
- **Immutable Models**: All models are immutable with copyWith methods
- **JSON Serialization**: Proper serialization/deserialization
- **Validation**: Input validation and error handling
- **Equality**: Proper equality implementation

## Presentation Layer

### Screen Organization
- **Screen Files**: Main screen files under 200-250 lines
- **Private Widgets**: Break down into smaller private widget classes
- **Part/Part of**: Use part/part of for large files when needed
- **Widget Variants**: Use enums for widget variants, not strings

### UI Components
- **Material 3**: Full Material 3 design system compliance
- **Responsive Design**: Mobile-first with tablet support
- **Accessibility**: Proper contrast ratios and touch targets
- **Animations**: Smooth transitions and micro-interactions

## Documentation

### Feature Documentation
- **Purpose**: Clear explanation of feature purpose
- **Architecture**: Technical architecture details
- **Usage**: Code examples and usage patterns
- **Testing**: Testing strategies and examples

### Code Documentation
- **Function Comments**: Use `///` for public APIs
- **Why Not How**: Focus on business purpose, not implementation
- **Examples**: Provide usage examples where helpful
- **Maintenance**: Keep documentation updated with code changes

## Testing Strategy

### Unit Tests
- **BLoC Testing**: Test business logic and state transitions
- **Service Testing**: Test data layer functionality
- **Model Testing**: Test data models and serialization

### Widget Tests
- **Component Testing**: Test individual UI components
- **Interaction Testing**: Test user interactions
- **State Testing**: Test UI state changes

### Integration Tests
- **End-to-End**: Test complete user workflows
- **API Integration**: Test external service integration
- **Storage Testing**: Test data persistence

## Performance Considerations

### Memory Management
- **Disposal**: Proper disposal of controllers and resources
- **Lazy Loading**: Load data only when needed
- **Efficient Filtering**: Use stream operations for large datasets
- **Caching**: Implement smart caching strategies

### Network Optimization
- **Batch Requests**: Combine multiple API calls
- **Offline Support**: Work without internet connection
- **Error Recovery**: Graceful handling of network failures
- **Rate Limiting**: Respect API rate limits

## Security Considerations

### Data Protection
- **Local Storage**: Secure local data storage
- **API Keys**: Proper API key management
- **Input Validation**: Validate all user inputs
- **Error Handling**: Don't expose sensitive information in errors

## Future Enhancements

### Architecture Improvements
- **Dependency Injection**: Implement proper DI container
- **Repository Pattern**: Add repository layer for data abstraction
- **Use Cases**: Implement use case pattern for business logic
- **Testing**: Add comprehensive test coverage

### Feature Additions
- **Offline Support**: Full offline functionality
- **Real-time Updates**: WebSocket integration
- **Advanced Analytics**: Portfolio performance metrics
- **Multi-language**: Internationalization support

## Best Practices Summary

1. **Clean Architecture**: Clear separation of concerns
2. **Private Widgets**: Use private widget classes, not function widgets
3. **Enum Extensions**: Create boolean getters for all enums
4. **Documentation**: Document the "why", not the "how"
5. **File Organization**: Keep files under 200-250 lines
6. **Method Length**: Keep methods under 30-50 lines
7. **Type Safety**: Use enums instead of strings
8. **Error Handling**: Comprehensive error management
9. **Testing**: Write tests for all business logic
10. **Performance**: Optimize for memory and network usage
