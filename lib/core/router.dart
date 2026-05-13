import 'package:go_router/go_router.dart';
import '../presentation/screens/catalog_screen.dart';
import '../presentation/screens/cart_screen.dart';
import '../presentation/screens/favorites_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const CatalogScreen(),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
  ],
);