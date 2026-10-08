import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/utils/column_config_parser.dart';

void main() {
  group('ColumnConfigParser', () {
    test('parses null or empty string into default empty ColumnConfig', () {
      final c1 = ColumnConfig.parse(null);
      expect(c1.titleField, '');
      expect(c1.subtitleField, isNull);
      expect(c1.detailFields, isEmpty);

      final c2 = ColumnConfig.parse('');
      expect(c2.titleField, '');
      expect(c2.subtitleField, isNull);
      expect(c2.detailFields, isEmpty);
    });

    test('parses standard IFS caret-delimited column config', () {
      const raw = 'TITLE=PartNo^SUBTITLE=Description^COL1=Contract^COL2=Qty^COL3=UnitMeas^';
      final cfg = ColumnConfig.parse(raw);

      expect(cfg.titleField, 'PartNo');
      expect(cfg.subtitleField, 'Description');
      expect(cfg.detailFields, ['Contract', 'Qty', 'UnitMeas']);
    });

    test('ignores non-contiguous or empty COL entries', () {
      const raw = 'TITLE=OrderNo^COL1=Customer^COL3=TotalAmount^COL5=Status^';
      final cfg = ColumnConfig.parse(raw);

      expect(cfg.titleField, 'OrderNo');
      expect(cfg.subtitleField, isNull);
      expect(cfg.detailFields, ['Customer', 'TotalAmount', 'Status']);
    });
  });
}
