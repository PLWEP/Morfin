import 'package:flutter/material.dart';
import '../../metadata/lobby_metadata.dart';
import 'lobby_element_tile.dart';

class LobbyGrid extends StatelessWidget {
  final List<LobbyElementMetadata> elements;

  const LobbyGrid({super.key, required this.elements});

  @override
  Widget build(BuildContext context) {
    if (elements.isEmpty) return const SizedBox.shrink();

    final widgets = <Widget>[];
    int i = 0;

    while (i < elements.length) {
      final current = elements[i];

      // If full width (col span >= 2 or charts by default)
      if (current.span.col >= 2 ||
          current.type == LobbyElementType.barChart ||
          current.type == LobbyElementType.lineChart) {
        widgets.add(LobbyElementTile(metadata: current));
        widgets.add(const SizedBox(height: 12));
        i++;
      } else {
        // Pair two 1-column items side-by-side (e.g. Counter and Indicator)
        if (i + 1 < elements.length &&
            elements[i + 1].span.col < 2 &&
            elements[i + 1].type != LobbyElementType.barChart &&
            elements[i + 1].type != LobbyElementType.lineChart) {
          final next = elements[i + 1];
          widgets.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: LobbyElementTile(metadata: current)),
                  const SizedBox(width: 12),
                  Expanded(child: LobbyElementTile(metadata: next)),
                ],
              ),
            ),
          );
          widgets.add(const SizedBox(height: 12));
          i += 2;
        } else {
          // Single element in row
          widgets.add(LobbyElementTile(metadata: current));
          widgets.add(const SizedBox(height: 12));
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
