/*
 * Dazza
 * Created by Yakka
 * http://theyakka.com
 *
 * Copyright (c) 2018 Yakka, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

class Parameters {
  /// Storage for parameter values
  final Map<String, List<dynamic>> _parameters = {};

  Parameters();

  Parameters.fromMap(Map<String, dynamic> values) {
    values.forEach((key, val) {
      if (val is List) {
        _parameters[key] = val;
      } else {
        _parameters[key] = [val];
      }
    });
  }

  void setValueList(String key, List<dynamic> valueList) =>
      _parameters[key] = valueList;

  void add(String key, dynamic value) => _append(key, value);

  void addAll(Parameters parameters) {
    if (parameters != null) {
      _parameters.addAll(parameters._parameters);
    }
  }

  void addMap(Map<String, List<dynamic>> paramMap) =>
      _parameters.addAll(paramMap);

  /// Checks to see if the parameter exists.
  bool has(String key) => _parameters.containsKey(key);

  /// Will return the list of parameter values or null if it is undefined.
  List<dynamic> value(String key) => _parameters[key];

  /// Will return the parameter value.
  dynamic first(String key) => _firstValueIfExists(key);

  /// Will return the parameter value as a String.
  String firstString(String key) {
    final val = first(key);
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
    final val = first(key);
    if (val is bool) {
      return val;
    } else if (val is String) {
      final lowerVal = val.toLowerCase();
      if (lowerVal == "true" || lowerVal == "false") {
        return lowerVal == "true";
      } else if (lowerVal == "yes" || lowerVal == "no") {
        return lowerVal == "yes";
      } else {
        final intVal = firstInt(key);
        if (intVal != null && (intVal == 0 || intVal == 1)) {
          return intVal == 1 ? true : false;
        }
      }
    }
    return null;
  }

  /// Will return an int value for the parameter or null if the value was not
  /// able to be converted.
  int firstInt(String key) {
    final val = first(key);
    if (val is int) {
      return val;
    } else if (val is String) {
      try {
        return int.tryParse(_firstValueIfExists(key));
      } catch (ex) {
        return null;
      }
    }
    return null;
  }

  // internal
  void _append(String key, dynamic value) {
    List<dynamic> valueList = _parameters[key];
    if (valueList == null) {
      valueList = [];
    }
    if (value is List) {
      valueList.addAll(value);
    } else {
      valueList.add(value);
    }
    _parameters[key] = valueList;
  }

  dynamic _firstValueIfExists(String key) {
    if (_parameters.containsKey(key)) {
      final value = _parameters[key];
      if (value.isNotEmpty) return value.first;
    }
    return null;
  }

  @override
  String toString() => _parameters.toString();
}

/// Built-in parameters that will be present in the [parameters] value of any
/// [HandlerFunc].
class RouteParameter {
  static String path = "_dazza_path";
  static String routePath = "_dazza_routePath";
}
