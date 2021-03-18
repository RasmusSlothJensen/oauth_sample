class AppRouteState {
  Map<String, String> callbackData;
  final bool isAuthorized;
  AppRouteState({
    this.isAuthorized,
    this.callbackData,
  });

  factory AppRouteState.home() => AppRouteState(isAuthorized: false);

  factory AppRouteState.authorized() => AppRouteState(isAuthorized: true);

  factory AppRouteState.handlingCallback(Map<String, String> parameters) =>
      AppRouteState(
        isAuthorized: false,
        callbackData: parameters,
      );
}
