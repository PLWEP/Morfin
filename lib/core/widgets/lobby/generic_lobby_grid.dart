import 'package:flutter/material.dart';
import '../../metadata/lobby_metadata.dart';
import 'generic_lobby_element.dart';

class GenericLobbyGrid extends StatelessWidget {
  final List<LobbyElementMetadata> elements;

  const GenericLobbyGrid({super.key, required this.elements});

  @override
  Widget build(BuildContext context) {
    if (elements.isEmpty) return const SizedBox.shrink();

    final widgets = <Widget>[];
    int i = 0;

    while (i < elements.length) {
      final current = elements[i];

      // If full width (col span >= 2 or charts/indicators by default)
      if (current.span.col >= 2 || current.type == LobbyElementType.barChart || current.type == LobbyElementType.lineChart) {
        widgets.add(GenericLobbyElement(metadata: current));
        widgets.add(const SizedBox(height: 10));
        i++;
      } else {
        // Check if there is a next element that can share a 2-column row
        if (i + 1 < elements.length && elements[i + 1].span.col < 2 && elements[i + 1].type == LobbyElementType.counter) {
          final next = elements[i + 1];
          widgets.add(
            Row(
              children: [
                Expanded(child: GenericLobbyElement(metadata: current)),
                const SizedBox(width: 10),
                Expanded(child: GenericLobbyElement(metadata: next)),
              ],
            ),
          );
          widgets.add(const SizedBox(height: 10));
          i += 2;
        } else {
          // Single element in row
          widgets.add(GenericLobbyElement(metadata: current));
          widgets.add(const SizedBox(height: 10));
          i++;
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }
}
