import 'package:auto_route/auto_route.dart';
import 'package:farm_setu_demo/routes.gr.dart' as route;


@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends route.$AppRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page:route.ChartData.page,initial: true),
    AutoRoute(page: route.TableViewRoute.page),
  ];
}