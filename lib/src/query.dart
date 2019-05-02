/*
 * Dazza
 * Created by Yakka
 * https://theyakka.com
 *
 * Copyright (c) 2019 Yakka LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'parameters.dart';

const String queryRegexPattern = '(?:[\?&]?([^\?&=]+)={1}([^\?&=]+))';

/// Helper class that allows you to easily parse a query string into a
/// [Parameters] instance.
class QueryParser {
  // Factory / internal constructor
  QueryParser._internal() : _regexp = RegExp(queryRegexPattern);
  factory QueryParser() {
    _instance ??= QueryParser._internal();
    return _instance;
  }

  // The factory / static instance
  static QueryParser _instance;
  // The RegExp we will use to parse querystrings
  final RegExp _regexp;

  /// Parses a query string and returns a [Parameters] instance. The parser
  /// supports duplicate definitions (e.g.: ?color=red&color=green) and will
  /// automatically append them to the parameter value list.
  ///
  /// See [Parameters] for more information.
  Parameters parse(String query) {
    Iterable<Match> matches = _regexp.allMatches(query);
    if (matches.isEmpty) {
      return Parameters();
    }
    final Parameters params = Parameters();
    matches.map((Match match) {
      if (match.groupCount == 2) {
        params.add(match.group(0), match.group(1));
      }
    });
    return params;
  }
}
