import 'package:jaspr_router/jaspr_router.dart';

import 'route_names.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/leader_board/leader_board_page.dart';
import '../features/order/order_page.dart';
import '../features/bio_data/bio_data_page.dart';
import '../features/common/coming_soon_page.dart';
import '../features/common/error_page.dart';

/// Singleton Route Manager that maps RouteNames to Jaspr Components.
/// Extends programmatic routing to all sidebar features (with coming-soon fallbacks).
class RouterManager {
  static final RouterManager _singleton = RouterManager._internal();
  RouterManager._internal();
  static RouterManager get instance => _singleton;
  static RouterManager get getInstance => _singleton;

  List<Route> get routes => [
        Route(
          path: RouteName.initialView,
          title: 'Dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
        Route(
          path: RouteName.leaderBoard,
          title: 'Leader Board',
          builder: (context, state) => const LeaderBoardPage(),
        ),
        Route(
          path: RouteName.order,
          title: 'Orders',
          builder: (context, state) => const OrderPage(),
        ),
        Route(
          path: RouteName.games,
          title: 'Games',
          builder: (context, state) => const ComingSoonPage(title: 'Games', icon: '🎮'),
        ),
        Route(
          path: RouteName.massage,
          title: 'Massage',
          builder: (context, state) => const ComingSoonPage(title: 'Massage', icon: '💆'),
        ),
        Route(
          path: RouteName.orderDetails,
          title: 'Order Details',
          builder: (context, state) => const ComingSoonPage(title: 'Order Details', icon: '📦'),
        ),
        Route(
          path: RouteName.settings,
          title: 'Settings',
          builder: (context, state) => const ComingSoonPage(title: 'Settings', icon: '⚙️'),
        ),
        Route(
          path: RouteName.bioData,
          title: 'Bio Data',
          builder: (context, state) => const BioDataPage(),
        ),
        Route(
          path: RouteName.ticTacToe,
          title: 'Tic Tac Toe',
          builder: (context, state) => const ComingSoonPage(title: 'Tic Tac Toe', icon: '❌⭕'),
        ),
        Route(
          path: RouteName.colorMatch,
          title: 'Color Match',
          builder: (context, state) => const ComingSoonPage(title: 'Color Match', icon: '🎨'),
        ),
        Route(
          path: RouteName.snakeGame,
          title: 'Snake Game',
          builder: (context, state) => const ComingSoonPage(title: 'Snake Game', icon: '🐍'),
        ),
        Route(
          path: RouteName.reactionTime,
          title: 'Reaction Time',
          builder: (context, state) => const ComingSoonPage(title: 'Reaction Time', icon: '⚡'),
        ),
        Route(
          path: RouteName.openStreetMap,
          title: 'Open Street Map',
          builder: (context, state) => const ComingSoonPage(title: 'Open Street Map', icon: '🗺️'),
        ),
        Route(
          path: RouteName.error,
          title: 'Error',
          builder: (context, state) => const ErrorPage(),
        ),
      ];
}
