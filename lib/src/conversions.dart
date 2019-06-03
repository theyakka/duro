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
  /// Attempts to return the stored value as a [bool]. If the value cannot be
  /// converted, it will return false.
  ///
  /// This function will use the following rules:
  ///  - [int] values: 1 = true, 0 = false, else = false
  ///  - [String] values: 'true', 'yes', '1' = true, 'false', 'no', '0' = false,
  ///    else = false
  ///  - [bool] values will not be converted (obviously)
  static bool boolValue(dynamic val) {
    if (val == null) {
      return false;
    }
    if (val is bool) {
      return val;
    } else if (val is int) {
      if (val == 0 || val == 1) {
        return val == 1 ? true : false;
      } else {
        return false;
      }
    } else if (val is String) {
      final lowerVal = val.toLowerCase();
      if (lowerVal == 'true' || lowerVal == 'false') {
        return lowerVal == 'true';
      } else if (lowerVal == 'yes' || lowerVal == 'no') {
        return lowerVal == 'yes';
      } else {
        try {
          final intVal = int.tryParse(val);
          if (intVal != null && (intVal == 0 || intVal == 1)) {
            return intVal == 1 ? true : false;
          }
        } on FormatException catch (_) {
          return false;
        }
      }
    }
    return false;
  }

  /// Attempts to return the stored value as an [int]. If the value cannot be
  /// converted, it will return 0.
  ///
  /// This function will use the following rules:
  ///  - [bool] values: true = 1, false = 0
  ///  - [String] values: will use [int.tryParse(value)]. If the value is
  ///    invalid, it will return 0.
  ///  - [int] values will not be converted (obviously)
  static int intValue(dynamic val) {
    if (val == null) {
      return 0;
    }
    if (val is int) {
      return val;
    } else if (val is bool && val != null) {
      return val == true ? 1 : 0;
    } else if (val is String) {
      try {
        return int.tryParse(val);
      } on FormatException catch (_) {
        return 0;
      }
    }
    return 0;
  }

  /// Returns the dynamic value as a [String]. For completeness sake (and for
  /// future compatibility) we've added this function but, for now, it will
  /// just call [toString] on the value. If there is an issue returning the
  /// [String] representation then the value will be null.
  static String stringValue(dynamic val) {
    if (val == null) {
      return null;
    }
    try {
      return val.toString();
    } on FormatException catch (_) {
      return null;
    }
  }
}
