/*
 * Dazza
 * Created by Yakka
 * http://theyakka.com
 *
 * Copyright (c) 2018 Yakka, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:dazza/dazza.dart';
import 'package:test/test.dart';

void main() {
  Parameters params;

  setUp(() {
    params = Parameters.fromMap({
      "name": "Hello",
      "colors": ["red", "green", "blue"],
      "someBool": true,
      "someInt": 100,
      "someFloat": 1.5,
      "someStringBool": "true",
      "boolAsYesString" : "yes",
      "boolAsNoString" : "no",
      "boolAsIntString" : "1",
      "boolAsBadString" : "A",
      "someStringInt": "400",
    });
  });

  test("Set parameter as a value list", () {
    final key = "testlist";
    final list = <String>["a", "b", "c", "d"];
    params.setValueList(key, list);
    if (params.has(key)) {
      expect(params.value(key), list);
    } else {
      fail("Value list parameter was not stored in the list of parameter values");
    }
  });

  test("Retrieve bool parameter as String", () {
    final key = "someBool";
    if (params.has(key)) {
      expect(params.firstString(key), "true");
    } else {
      fail("Parameters object is not set up correctly");
    }
  });

  test("Retrieve 'yes' value as bool", () {
    final key = "boolAsYesString";
    if (params.has(key)) {
      expect(params.firstBool(key), isTrue);
    } else {
      fail("Parameters object is not set up correctly");
    }
  });

  test("Retrieve 'no' value as bool", () {
    final key = "boolAsNoString";
    if (params.has(key)) {
      expect(params.firstBool(key), isFalse);
    } else {
      fail("Parameters object is not set up correctly");
    }
  });

  test("Retrieve '1' value as bool", () {
    final key = "boolAsIntString";
    if (params.has(key)) {
      expect(params.firstBool(key), isTrue);
    } else {
      fail("Parameters object is not set up correctly");
    }
  });

  test("Bad bool value returns null", () {
    final key = "boolAsBadString";
    if (params.has(key)) {
      expect(params.firstBool(key), isNull);
    } else {
      fail("Parameters object is not set up correctly");
    }
  });

  test("Retrieve String parameter as bool", () {
    final key = "someStringBool";
    if (params.has(key)) {
      expect(params.firstBool(key), isTrue);
    } else {
      fail("Parameters object is not set up correctly");
    }
  });

  test("Retrieve int parameter", () {
    final key = "someInt";
    if (params.has(key)) {
      expect(params.firstInt(key), equals(100));
    } else {
      fail("Parameters object is not set up correctly");
    }
  });

  test("Retrieve String parameter as int", () {
    final key = "someStringInt";
    if (params.has(key)) {
      expect(params.firstInt(key), equals(400));
    } else {
      fail("Parameters object is not set up correctly");
    }
  });

  test("Retrieve String parameter as String", () {
    final key = "name";
    if (params.has(key)) {
      expect(params.firstString(key), equals("Hello"));
    } else {
      fail("Parameters object is not set up correctly");
    }
  });

  test("Parameters to String", () {
    final testParams = Parameters.fromMap({
      "a" : 123,
      "b" : "hello",
      "c": ["red", "green", "blue"],
      "d" : 1.5,
      "e" : false,
    });
    final paramsString = "{a: [123], b: [hello], c: [red, green, blue], d: [1.5], e: [false]}";
    expect(testParams.toString(), paramsString);
  });
}
