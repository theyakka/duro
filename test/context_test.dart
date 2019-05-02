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
  test('Check that context is being created', () {
    final Context context = Context.initial('hello', 'world');
    final Context context2 =
        Context.withValue(context, 'testing', 'this thing');
    print(context.values.length);
    print(context2.values.length);
  });
}
