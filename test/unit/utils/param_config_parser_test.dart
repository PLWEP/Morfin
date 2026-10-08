import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/utils/param_config_parser.dart';

void main() {
  group('ParamConfigParser Unit Tests', () {
    test('parses null or empty config into empty structures', () {
      final (defaults, hidden, explicit, mandatory, optional) = ParamConfigParser.parse(null);
      expect(defaults.isEmpty, true);
      expect(hidden.isEmpty, true);
      expect(explicit.isEmpty, true);
      expect(mandatory.isEmpty, true);
      expect(optional.isEmpty, true);

      final (d2, h2, e2, m2, o2) = ParamConfigParser.parse('');
      expect(d2.isEmpty, true);
      expect(h2.isEmpty, true);
    });

    test('parses caret-delimited string configs', () {
      const cfg = 'Contract=2WFCC^HIDE=FullSelection,BuyerCode^MANDATORY=Site,PartNo^OPTIONAL=Note^Qty=10';
      final (defaults, hidden, explicit, mandatory, optional) = ParamConfigParser.parse(cfg);

      expect(defaults, {
        'Contract': '2WFCC',
        'Qty': '10',
      });
      expect(hidden, {'FULLSELECTION', 'BUYERCODE'});
      expect(mandatory, {'SITE', 'PARTNO'});
      expect(optional, {'NOTE'});
      expect(explicit.isEmpty, true);
    });

    test('parses JSON formatted configs', () {
      const jsonCfg = '''
      {
        "defaults": { "OrderType": "NORMAL", "Priority": 1 },
        "hide": ["KeyRef", "RowVersion"],
        "mandatory": ["CustomerNo"],
        "optional": ["Remarks"],
        "fields": [
          { "key": "CustomerNo", "label": "Customer", "type": "text", "isRequired": true }
        ]
      }
      ''';

      final (defaults, hidden, explicit, mandatory, optional) = ParamConfigParser.parse(jsonCfg);

      expect(defaults['OrderType'], 'NORMAL');
      expect(defaults['Priority'], 1);
      expect(hidden, {'KEYREF', 'ROWVERSION'});
      expect(mandatory, {'CUSTOMERNO'});
      expect(optional, {'REMARKS'});
      expect(explicit.length, 1);
      expect(explicit.first.key, 'CustomerNo');
      expect(explicit.first.isRequired, true);
    });
  });
}
