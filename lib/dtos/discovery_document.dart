class DiscoveryDocument {
  final Uri authorizationEndpoint;
  final Uri tokenEndpoint;
  final List<String> supportedScopes;
  final Uri userinfoEndpoint;
  DiscoveryDocument(this.authorizationEndpoint, this.tokenEndpoint,
      this.supportedScopes, this.userinfoEndpoint);

  DiscoveryDocument.fromJson(Map<String, dynamic> json)
      : authorizationEndpoint = Uri.parse(json['authorization_endpoint']),
        tokenEndpoint = Uri.parse(json['token_endpoint']),
        supportedScopes = List.from(json['scopes_supported']),
        userinfoEndpoint = Uri.parse(json['userinfo_endpoint']);
}
