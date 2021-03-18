import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oauth_sample/dtos/discovery_document.dart';
import 'package:oauth2/oauth2.dart';
import 'package:oauth_sample/open_location/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_route_state.dart';

class AppRouterDelegate extends RouterDelegate<AppRouteState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRouteState> {
  AppRouteState routeState = AppRouteState.home();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  String displayName;

  final clientID = 'spa.digitalid';

  final scopes = ['openid', 'profile'];

  final redirectUri = Uri.parse('http://localhost:4200/#/callback');

  final discoveryUri =
      Uri.parse('https:/idp.digitalid.local/.well-known/openid-configuration');

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: ValueKey("SplashPage"),
          child: Scaffold(
            body: Center(
              child: TextButton(
                onPressed: authorize,
                child: Text('BEGIN'),
              ),
            ),
          ),
        ),
        if (routeState.isAuthorized)
          MaterialPage(
            key: ValueKey("ProfilePage"),
            child: Scaffold(
              body: Center(
                child: Text('Welcome $displayName!'),
              ),
            ),
          ),
        if (routeState.callbackData != null)
          MaterialPage(
            key: ValueKey("Loading"),
            child: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        // Update the list of pages by setting _selectedBook to null
        // _selectedBook = null;
        // show404 = false;
        notifyListeners();

        return true;
      },
    );
  }

  AppRouteState get currentConfiguration {
    return routeState;
  }

  @override
  Future<void> setNewRoutePath(AppRouteState configuration) async {
    routeState = configuration;

    if (routeState.callbackData != null) {
      handleCallback(routeState.callbackData);
    }
  }

  Future<void> handleCallback(Map<String, dynamic> callbackData) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final grant = AuthorizationCodeGrant.fromJson(
        jsonDecode(sharedPreferences.getString('grant')));
    final client = await grant.handleAuthorizationResponse(
      callbackData,
    );
    final discoveryDocument = await getDiscoveryDocument();
    final response = await client.get(discoveryDocument.userinfoEndpoint);
    displayName = jsonDecode(response.body)['name'];
    routeState = AppRouteState.authorized();
    notifyListeners();
  }

  Future<void> authorize() async {
    final discoveryDocument = await getDiscoveryDocument();
    await redirectToIdentityProvider(
      clientID,
      discoveryDocument.authorizationEndpoint,
      discoveryDocument.tokenEndpoint,
      scopes,
      redirectUri,
    );
  }

  Future<void> redirectToIdentityProvider(
    String clientID,
    Uri authorizationEndpoint,
    Uri tokenEndpoint,
    List<String> scopes,
    Uri redirectUri,
  ) async {
    final grant = AuthorizationCodeGrant(
      clientID,
      authorizationEndpoint,
      tokenEndpoint,
    );
    final sharedPreferences = await SharedPreferences.getInstance();
    final authorizationUrl =
        grant.getAuthorizationUrl(redirectUri, scopes: scopes);
    final String json = jsonEncode(
      grant.toJson(),
    );
    await sharedPreferences.setString('grant', json);
    openLocation(authorizationUrl);
  }

  Future<DiscoveryDocument> getDiscoveryDocument() async {
    final httpclient = http.Client();
    final response = await httpclient.get(discoveryUri);
    final json = jsonDecode(response.body);
    return DiscoveryDocument.fromJson(json);
  }
}
