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

class Parameters extends ValueStore<String, List<dynamic>> {
  Parameters();
  Parameters.fromMap(Map<String, dynamic> values) {
    addMap(values);
  }

  ///
  static Parameters fromQuery(String query) => QueryParser().parse(query);

  ///
  void add(String key, dynamic value) => _append(key, value);

  ///
  void addAll(String key, List<dynamic> value) => _append(key, value);

  ///
  void addMap(Map<String, dynamic> values) {
    values.forEach((String key, dynamic val) {
      if (val is List) {
        _append(key, val);
      } else {
        _append(key, <dynamic>[val]);
      }
    });
  }

  /// Will return the parameter value.
  dynamic first(String key) => _firstValueIfExists(key);

  /// Will return the parameter value as a String.
  String firstString(String key) {
    final dynamic val = first(key);
    if (val is String) {
      return val;
    } else {
      return val.toString();
    }
  }

  /// Will return true or false if the string is one of the following values:
  /// true, false, yes, no, 1 or 0. If the value is not one of the afforementioned
  /// values then it will return null.
  bool firstBool(String key) {
    return Conversion.boolValue(first(key));
  }

  /// Will return an int value for the parameter or null if the value was not
  /// able to be converted.
  int firstInt(String key) {
    return Conversion.intValue(first(key));
  }

  // internal
  void _append(String key, dynamic val) {
    final List<dynamic> valueList = value(key) ?? <dynamic>[];
    if (value is List) {
      valueList.addAll(val);
    } else {
      valueList.add(value);
    }
    set(key, valueList);
  }

  dynamic _firstValueIfExists(String key) {
    if (has(key)) {
      final List<dynamic> val = value(key);
      if (val.isNotEmpty) {
        return val.first;
      }
    }
    return null;
  }
}
