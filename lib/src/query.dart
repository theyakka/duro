/*
 * Dazza
 * Created by Yakka
 * https://theyakka.com
 *
 * Copyright (c) 2019 Yakka LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:dazza/dazza.dart';

import 'parameters.dart';

/// Regex pattern that is used to parse query strings
const String queryRegexPattern = '(?:[\?&]?([^\?&=]+)={1}([^\?&=]+))';

/// Helper class that allows you to easily parse a query string into a
/// [Parameters] instance.
class QueryParser {
  /// Singleton factory constructor. There is no reason to have multiple
  /// instances of this class.
  factory QueryParser() {
    _instance ??= QueryParser._internal();
    return _instance;
  }

  /// Factory / internal constructor
  QueryParser._internal() : _regexp = RegExp(queryRegexPattern);

  // The factory / static instance
  static QueryParser _instance;
  // The RegExp we will use to parse querystrings
  final RegExp _regexp;

  /// Parses a string containing a query string and returns a [Parameters]
  /// instance. The parser supports duplicate definitions
  /// (e.g.: ?color=red&color=green) and will automatically append them to the
  /// parameter value list.
  ///
  /// See [Parameters] for more information.
  Parameters parse(String query, {bool decodeValue = true}) {
    final Iterable<Match> matches = _regexp.allMatches(query);
    if (matches.isEmpty) {
      return Parameters();
    }
    final params = Parameters();
    for (final match in matches) {
      if (match.groupCount == 2) {
        var value = match.group(2);
        if (decodeValue) {
          value = _decode(match.group(2));
        }
        params.add(match.group(1), value);
      }
    }
    return params;
  }

  String _decode(String s) => Uri.decodeComponent(s.replaceAll('+', ' '));
}
