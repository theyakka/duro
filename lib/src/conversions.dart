/*
 * Dazza
 * Created by Yakka
 * https://theyakka.com
 *
 * Copyright (c) 2019 Yakka LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

/// Provides conversion functions to common types from `dynamic` objects.
class Conversion {
  /// Attempts to return the stored value as a boolean. If the value cannot be
  /// converted, it will return `null`.
  ///
  /// This function will use the following rules:
  ///  - int values: 1 = true, 0 = false, else = null
  ///  - string values: 'true', 'yes', '1' = true, 'false', 'no', '0' = false,
  ///    else = null
  ///  - bool values will not be converted (obviously)
  static bool boolValue(dynamic val) {
    if (val == null) {
      return null;
    }
    if (val is bool) {
      return val;
    } else if (val is int) {
      if (val == 0 || val == 1) {
        return val == 1 ? true : false;
      } else {
        return null;
      }
    } else if (val is String) {
      final String lowerVal = val.toLowerCase();
      if (lowerVal == 'true' || lowerVal == 'false') {
        return lowerVal == 'true';
      } else if (lowerVal == 'yes' || lowerVal == 'no') {
        return lowerVal == 'yes';
      } else {
        try {
          final int intVal = int.tryParse(val);
          if (intVal != null && (intVal == 0 || intVal == 1)) {
            return intVal == 1 ? true : false;
          }
        } catch (_) {
          return null;
        }
      }
    }
    return null;
  }

  /// Attempts to return the stored value as an int. If the value cannot be
  /// converted, it will return `null`.
  ///
  /// This function will use the following rules:
  ///  - bool values: true = 1, false = 0
  ///  - string values: will use [int.tryParse(value)]. If the value is
  ///    invalid, it will return null.
  ///  - int values will not be converted (obviously)
  static int intValue(dynamic val) {
    if (val == null) {
      return null;
    }
    if (val is int) {
      return val;
    } else if (val is bool && val != null) {
      return val == true ? 1 : 0;
    } else if (val is String) {
      try {
        return int.tryParse(val);
      } catch (ex) {
        return null;
      }
    }
    return null;
  }

  /// Returns the dynamic value as a string. For completeness sake (and for
  /// future compatibility) we've added this function but, for now, it will
  /// just call `toString()` on the value.
  static String stringValue(dynamic val) {
    if (val == null) {
      return null;
    }
    try {
      return val.toString();
    } catch (ex) {
      return null;
    }
  }
}
