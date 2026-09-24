import 'package:flutter/material.dart';
import '../../metadata/lobby_metadata.dart';
import 'generic_chart_element.dart';
import 'generic_counter_element.dart';
import 'generic_indicator_element.dart';
import 'generic_link_element.dart';

class GenericLobbyElement extends StatelessWidget {
  final LobbyElementMetadata metadata;

  const GenericLobbyElement({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    switch (metadata.type) {
      case LobbyElementType.counter:
        return GenericCounterElement(metadata: metadata);
      case LobbyElementType.indicator:
        return GenericIndicatorElement(metadata: metadata);
      case LobbyElementType.barChart:
      case LobbyElementType.lineChart:
        return GenericChartElement(metadata: metadata);
      case LobbyElementType.linkTile:
        return GenericLinkElement(metadata: metadata);
      case LobbyElementType.list:
      case LobbyElementType.unknown:
        return GenericLinkElement(metadata: metadata);
    }
  }
}
