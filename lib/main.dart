import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/blocs/portfolio_bloc.dart';
import 'presentation/blocs/search_bloc.dart';
import 'data/services/api_service.dart';
import 'data/services/storage_service.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/portfolio/portfolio_screen.dart';
import 'presentation/screens/add_asset/add_asset_screen.dart';
import 'core/theme/app_theme.dart';

/// Main entry point of the Crypto Portfolio Tracker application
void main() {
  runApp(const CryptoPortfolioApp());
}

/// Root widget of the application
class CryptoPortfolioApp extends StatelessWidget {
  const CryptoPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PortfolioBloc>(
          create: (context) => PortfolioBloc(
            apiService: ApiService(),
            storageService: StorageService(),
          ),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(
            apiService: ApiService(),
            storageService: StorageService(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Crypto Portfolio Tracker',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/portfolio': (context) => const PortfolioScreen(),
          '/add-asset': (context) => const AddAssetScreen(),
        },
      ),
    );
  }
}