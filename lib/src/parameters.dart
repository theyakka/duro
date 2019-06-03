/*
 * Dazza
 * Created by Yakka
 * https://theyakka.com
 *
 * Copyright (c) 2019 Yakka LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'conversions.dart';
import 'query.dart';
import 'value_store.dart';

/// Parameter key for the wildcard value (if present).
const paramKeyWildcard = '_dazza.wildcard';

///
class Parameters extends ValueStore<String, List<dynamic>> {
  /// Create an empty set of parameters.
  Parameters();

  /// Create a set of parameters from an existing [Map]. See [addMap] for
  /// details on how each specific value in the map will be treated.
  Parameters.fromMap(Map<String, dynamic> values) {
    addMap(values);
  }

  /// Create a set of parameters from a valid query string.
  static Parameters fromString(String query) => QueryParser().parse(query);

  /// Add a parameter to the parameter set. [add] will automatically wrap the
  /// value in a [List] if the value is not a [List] type.
  void add(String key, dynamic value) => _append(key, value);

  /// Add a list of values to the parameter set.
  void addAll(String key, List<dynamic> value) => _append(key, value);

  /// Add an existing map to the parameter set. If the map value is a single
  /// value type then it will be wrapped inside a [List] and that [List] will
  /// be stored in the [Map].
  void addMap(Map<String, dynamic> values) {
    values.forEach((final key, dynamic val) {
      if (val is List) {
        _append(key, val);
      } else {
        _append(key, <dynamic>[val]);
      }
    });
  }

  /// Merge another set of parameters into this set of parameters.
  void addParameters(Parameters parametersToAdd) {
    addMap(parametersToAdd.values);
  }

  /// Get a parameter value for a parameter key.
  dynamic first(String key) => _firstValueIfExists(key);

  /// Get a parameter value as a [String] for a parameter key.
  String firstString(String key) {
    // ignore: omit_local_variable_types
    final dynamic firstVal = first(key);
    if (firstVal == null) {
      return null;
    }
    if (firstVal is String) {
      return firstVal;
    } else {
      return firstVal.toString();
    }
  }

  /// Get a parameter value as a [bool] for a parameter key. Will return true
  /// or false if the string is one of the following values: true, false, yes,
  /// no, 1 or 0. If the value is not one of the aforementioned values then it
  /// will return false.
  bool firstBool(String key) {
    return Conversion.boolValue(first(key));
  }

  /// Get a parameter value as an [int] for a parameter key. If the value is not
  /// able to be converted the value will be zero (0).
  int firstInt(String key) {
    return Conversion.intValue(first(key));
  }

  /// Convenience getter for the wildcard value. If not present, will return
  /// null.
  String wildcardValue() => firstString(paramKeyWildcard);

  // internal
  void _append(String key, dynamic val) {
    final valueList = value(key) ?? <dynamic>[];
    if (val is List) {
      valueList.addAll(val);
    } else {
      valueList.add(val);
    }
    set(key, valueList);
  }

  dynamic _firstValueIfExists(String key) {
    if (has(key)) {
      final vals = value(key);
      if (vals.isNotEmpty) {
        return vals.first;
      }
    }
    return null;
  }
}
