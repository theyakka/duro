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
  Parameters params;

  setUp(() {
    params = Parameters.fromMap(<String, dynamic>{
      'name': 'Hello',
      'colors': <String>['red', 'green', 'blue'],
      'someBool': true,
      'someInt': 100,
      'someFloat': 1.5,
      'someStringBool': 'true',
      'boolAsYesString': 'yes',
      'boolAsNoString': 'no',
      'boolAsIntString': '1',
      'boolAsBadString': 'A',
      'someStringInt': '400',
    });
  });

  test('Set parameter as a value list', () {
    const String key = 'testlist';
    final List<String> list = <String>['a', 'b', 'c', 'd'];
    params.addAll(key, list);
    if (params.has(key)) {
      expect(params.value(key), equals(list));
    } else {
      fail(
        'Value list parameter was not stored in the list of parameter values',
      );
    }
  });

  test('Add methods persist existing values', () {
    final Parameters parameters = Parameters();
    parameters.add('colors', 'red');
    parameters.addMap(<String, String>{
      'colors': 'green',
    });
    parameters.addAll('colors', <String>['blue', 'orange']);
    expect(parameters['colors'].length, equals(4));
  });

  test('Set method erases existing values', () {
    final Parameters parameters = Parameters();
    parameters.addAll('colors', <String>['blue', 'orange']);
    parameters['colors'] = <String>['red'];
    expect(parameters['colors'].length, equals(1));
  });

  test('Add list to Parameters object', () {
    const String key = 'myList';
    final List<String> list = <String>['aa', 'bb', 'cc'];
    params.add(key, list);
    if (params.has(key)) {
      expect(params.value(key), equals(list));
    } else {
      fail(
        'Value list parameter was not stored in the list of parameter values',
      );
    }
  });

  test('Retrieve bool parameter as String', () {
    const String key = 'someBool';
    if (params.has(key)) {
      expect(params.firstString(key), 'true');
    } else {
      fail(
        'Parameters object is not set up correctly',
      );
    }
  });

  test("Retrieve 'yes' value as bool", () {
    const String key = 'boolAsYesString';
    if (params.has(key)) {
      expect(params.firstBool(key), isTrue);
    } else {
      fail(
        'Parameters object is not set up correctly',
      );
    }
  });

  test("Retrieve 'no' value as bool", () {
    const String key = 'boolAsNoString';
    if (params.has(key)) {
      expect(params.firstBool(key), isFalse);
    } else {
      fail(
        'Parameters object is not set up correctly',
      );
    }
  });

  test("Retrieve '1' value as bool", () {
    const String key = 'boolAsIntString';
    if (params.has(key)) {
      expect(params.firstBool(key), isTrue);
    } else {
      fail(
        'Parameters object is not set up correctly',
      );
    }
  });

  test('Bad bool value returns null', () {
    const String key = 'boolAsBadString';
    if (params.has(key)) {
      expect(params.firstBool(key), isFalse);
    } else {
      fail(
        'Parameters object is not set up correctly',
      );
    }
  });

  test('Retrieve String parameter as bool', () {
    const String key = 'someStringBool';
    if (params.has(key)) {
      expect(params.firstBool(key), isTrue);
    } else {
      fail(
        'Parameters object is not set up correctly',
      );
    }
  });

  test('Retrieve int parameter', () {
    const String key = 'someInt';
    if (params.has(key)) {
      expect(params.firstInt(key), equals(100));
    } else {
      fail(
        'Parameters object is not set up correctly',
      );
    }
  });

  test('Retrieve String parameter as int', () {
    const String key = 'someStringInt';
    if (params.has(key)) {
      expect(params.firstInt(key), equals(400));
    } else {
      fail(
        'Parameters object is not set up correctly',
      );
    }
  });

  test('Retrieve String parameter as String', () {
    const String key = 'name';
    if (params.has(key)) {
      expect(params.firstString(key), equals('Hello'));
    } else {
      fail(
        'Parameters object is not set up correctly',
      );
    }
  });

  test('Parameters to String', () {
    final Parameters testParams = Parameters.fromMap(<String, dynamic>{
      'a': 123,
      'b': 'hello',
      'c': <String>['red', 'green', 'blue'],
      'd': 1.5,
      'e': false,
    });
    const String paramsString =
        '{a: [123], b: [hello], c: [red, green, blue], d: [1.5], e: [false]}';
    expect(testParams.toString(), paramsString);
  });
}
