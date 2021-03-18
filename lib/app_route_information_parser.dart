import 'package:flutter/widgets.dart';
import 'package:oauth_sample/app_route_state.dart';

class AppRouteInformationParser extends RouteInformationParser<AppRouteState> {
  @override
  Future<AppRouteState> parseRouteInformation(
      RouteInformation routeInformation) async {
    if (routeInformation.location == null) {
      return AppRouteState.home();
    }
    final uri = Uri.parse(routeInformation.location);
    if (uri.pathSegments.length == 0) {
      return AppRouteState.home();
    }
    if (uri.pathSegments[0] == 'profile') {
      return AppRouteState.authorized();
    }
    if (uri.pathSegments[0] == 'callback') {
      return AppRouteState.handlingCallback(uri.queryParameters);
    }
    return AppRouteState.home();
  }

  @override
  RouteInformation restoreRouteInformation(AppRouteState path) {
    if (path.isAuthorized) {
      return RouteInformation(location: '/profile');
    } else if (path.callbackData != null) {
      return RouteInformation(
        location: '/callback',
        state: path.callbackData,
      );
    } else {
      return RouteInformation(location: '/');
    }
  }
}
