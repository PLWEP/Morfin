import 'package:flutter/foundation.dart';

@immutable
class ServerConfig {
  final String id;
  final String name;
  final String baseUrl;
  final String realm;
  final String clientId;
  final String clientSecret;

  const ServerConfig({
    required this.id,
    required this.name,
    required this.baseUrl,
    required this.realm,
    required this.clientId,
    required this.clientSecret,
  });

  ServerConfig copyWith({
    String? id,
    String? name,
    String? baseUrl,
    String? realm,
    String? clientId,
    String? clientSecret,
  }) {
    return ServerConfig(
      id: id ?? this.id,
      name: name ?? this.name,
      baseUrl: baseUrl ?? this.baseUrl,
      realm: realm ?? this.realm,
      clientId: clientId ?? this.clientId,
      clientSecret: clientSecret ?? this.clientSecret,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'baseUrl': baseUrl,
        'realm': realm,
        'clientId': clientId,
        'clientSecret': clientSecret,
      };

  factory ServerConfig.fromJson(Map<String, dynamic> json) => ServerConfig(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        baseUrl: json['baseUrl'] as String? ?? '',
        realm: json['realm'] as String? ?? '',
        clientId: json['clientId'] as String? ?? '',
        clientSecret: json['clientSecret'] as String? ?? '',
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerConfig &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
