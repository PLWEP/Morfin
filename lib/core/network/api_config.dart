import '../../features/login/models/server_config.dart';

class ApiConfig {
  static final ApiConfig instance = ApiConfig._();
  ApiConfig._();

  ServerConfig activeServer = const ServerConfig(
    id: '',
    name: '',
    baseUrl: '',
    realm: 'ifs',
    clientId: '',
    clientSecret: '',
  );

  bool get isServerConfigured => activeServer.baseUrl.isNotEmpty;

  String? accessToken;
  String? refreshToken;
  DateTime? tokenExpiry;

  bool get isAuthenticated => accessToken != null && accessToken!.isNotEmpty;

  void setServer(ServerConfig server) {
    activeServer = server;
  }

  void setTokens({
    required String access,
    String? refresh,
    int? expiresInSeconds,
  }) {
    accessToken = access;
    refreshToken = refresh;
    if (expiresInSeconds != null) {
      tokenExpiry = DateTime.now().add(Duration(seconds: expiresInSeconds));
    }
  }

  void clearTokens() {
    accessToken = null;
    refreshToken = null;
    tokenExpiry = null;
  }

  String get projectionBaseUrl {
    final base = activeServer.baseUrl.replaceAll(RegExp(r'/+$'), '');
    return '$base/main/ifsapplications/projection/v1';
  }

  String get tokenEndpoint {
    final base = activeServer.baseUrl.replaceAll(RegExp(r'/+$'), '');
    final realm = activeServer.realm.trim().isNotEmpty ? activeServer.realm.trim() : 'ifs';
    return '$base/auth/realms/$realm/protocol/openid-connect/token';
  }
}
