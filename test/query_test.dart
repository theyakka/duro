/*
 * Dazza
 * Created by Yakka
 * https://theyakka.com
 *
 * Copyright (c) 2019 Yakka, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:dazza/dazza.dart';
import 'package:test/test.dart';

void main() {
  test('Check that a query string with single values can be parsed', () {
    const String query =
        '?hello=55&testing=absd-cddjd&color=red&vegetable=turnip';
    final Parameters parameters = QueryParser().parse(query);
    expect(parameters.values.length, equals(4));
  });
}
