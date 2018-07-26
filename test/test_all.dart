/*
 * Dazza
 * Created by Yakka
 * http://theyakka.com
 *
 * Copyright (c) 2018 Yakka, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:test/test.dart';

import 'match_test.dart' as match;
import 'parameters_test.dart' as parameters;
import 'tree_test.dart' as tree;

void main() {
  group('match:', match.main);
  group('parameters:', parameters.main);
  group('tree:', tree.main);
}
