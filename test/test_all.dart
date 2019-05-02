/*
 * Dazza
 * Created by Yakka
 * https://theyakka.com
 *
 * Copyright (c) 2019 Yakka, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:test/test.dart';

import 'context_test.dart' as context;
import 'match_test.dart' as match;
import 'parameters_test.dart' as parameters;
import 'query_test.dart' as query;
import 'tree_test.dart' as tree;

void main() {
  group('context:', context.main);
  group('match:', match.main);
  group('parameters:', parameters.main);
  group('query:', query.main);
  group('tree:', tree.main);
}
