import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/utils/condition_evaluator.dart';

void main() {
  group('ConditionEvaluator Unit Tests', () {
    test('null or empty condition returns true', () {
      expect(ConditionEvaluator.evaluate(null, {}), true);
      expect(ConditionEvaluator.evaluate('', {}), true);
      expect(ConditionEvaluator.evaluate('   ', {}), true);
    });

    test('equality and inequality operators evaluate correctly', () {
      final record = {
        'Objstate': 'Planned',
        'CustomerNo': 'CUST-100',
      };

      expect(ConditionEvaluator.evaluate("Objstate == 'Planned'", record), true);
      expect(ConditionEvaluator.evaluate("Objstate == 'planned'", record), true); // case-insensitive
      expect(ConditionEvaluator.evaluate("Objstate == 'Released'", record), false);

      expect(ConditionEvaluator.evaluate("CustomerNo != 'CUST-200'", record), true);
      expect(ConditionEvaluator.evaluate("CustomerNo != 'CUST-100'", record), false);
    });

    test('numeric comparison operators evaluate correctly', () {
      final record = {
        'Quantity': '15',
        'Price': 250,
      };

      expect(ConditionEvaluator.evaluate('Quantity > 10', record), true);
      expect(ConditionEvaluator.evaluate('Quantity > 20', record), false);

      expect(ConditionEvaluator.evaluate('Quantity >= 15', record), true);
      expect(ConditionEvaluator.evaluate('Quantity <= 15', record), true);

      expect(ConditionEvaluator.evaluate('Price < 300', record), true);
      expect(ConditionEvaluator.evaluate('Price < 100', record), false);
    });

    test('contains operator checks substring match', () {
      final record = {'Description': 'Hydraulic Pump Assembly'};

      expect(ConditionEvaluator.evaluate("Description contains 'Pump'", record), true);
      expect(ConditionEvaluator.evaluate("Description contains 'PUMP'", record), true);
      expect(ConditionEvaluator.evaluate("Description contains 'Valve'", record), false);
    });

    test('compound logical conditions evaluate correctly', () {
      final record = {
        'Objstate': 'Planned',
        'Quantity': 25,
        'Site': 'SITE1',
      };

      expect(
        ConditionEvaluator.evaluate("Objstate == 'Planned' && Quantity > 20", record),
        true,
      );

      expect(
        ConditionEvaluator.evaluate("Objstate == 'Planned' && Quantity > 50", record),
        false,
      );

      expect(
        ConditionEvaluator.evaluate("Objstate == 'Released' || Site == 'SITE1'", record),
        true,
      );
    });

    test('brackets and braces in keys are stripped properly', () {
      final record = {
        'Active': true,
        'Code': 'ABC',
      };

      expect(ConditionEvaluator.evaluate('[Active] == true', record), true);
      expect(ConditionEvaluator.evaluate('{Code} == ABC', record), true);
    });

    test('raw boolean and truthy field evaluation without operator', () {
      expect(ConditionEvaluator.evaluate('IsUrgent', {'IsUrgent': true}), true);
      expect(ConditionEvaluator.evaluate('IsUrgent', {'IsUrgent': false}), false);
      expect(ConditionEvaluator.evaluate('Notes', {'Notes': 'Some notes'}), true);
      expect(ConditionEvaluator.evaluate('Notes', {'Notes': ''}), false);
      expect(ConditionEvaluator.evaluate('Notes', {'Notes': '0'}), false);
    });
  });
}
