import 'package:flutter/material.dart';
import '../../metadata/lobby_metadata.dart';
import 'lobby_chart_tile.dart';
import 'lobby_counter_tile.dart';
import 'lobby_indicator_tile.dart';
import 'lobby_link_tile.dart';

class LobbyElementTile extends StatelessWidget {
  final LobbyElementMetadata metadata;

  const LobbyElementTile({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    switch (metadata.type) {
      case LobbyElementType.counter:
        return LobbyCounterTile(metadata: metadata);
      case LobbyElementType.indicator:
        return LobbyIndicatorTile(metadata: metadata);
      case LobbyElementType.barChart:
      case LobbyElementType.lineChart:
        return LobbyChartTile(metadata: metadata);
      case LobbyElementType.linkTile:
        return LobbyLinkTile(metadata: metadata);
      case LobbyElementType.list:
      case LobbyElementType.unknown:
        return LobbyLinkTile(metadata: metadata);
    }
  }
}
