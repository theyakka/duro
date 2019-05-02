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

const int _globalContextValue = 12345;

void main() {
  Router router;

  setUp(() {
    router = Router(
      noMatchHandler: Handler(callback: _noMatchCallback),
    );
    final Handler handler =
        Handler(callback: _genericMatchCallback, context: null);
    router.addRoute(RouteDefinition('/usehandler', handler: handler));
    router.addRoute(RouteDefinition.withCallback(
      '/users',
      callback: _genericMatchCallback,
    ));
    router.addRoute(RouteDefinition.withCallback(
      '/users/profile',
      callback: _profileMatchCallback,
    ));
    router.addRoute(RouteDefinition.withCallback(
      '/users/:id',
      callback: _userMatchCallback,
    ));
    router.addRoute(RouteDefinition.withCallback(
      '/users/list',
      callback: _genericMatchCallback,
    ));
    router.addRoute(RouteDefinition.withCallback(
      '/gcontext',
      callback: _contextCallback,
      context: _globalContextValue,
    ));
    router.addRoute(RouteDefinition.withCallback(
      "/lcontext",
      callback: _contextCallback,
    ));
    router.addRoute(RouteDefinition.withCallback(
      "/empty",
      callback: _emptyCallback,
    ));
    router.addRoute(
      RouteDefinition.withCallback(
        "/test",
        callback: (Parameters parameters, dynamic context) {
          return 99;
        },
      ),
    );
  });

  test("Long form handler gets hit correctly", () {
    final expectedResult = "abcdefg";
    final params = Parameters.fromMap({
      "expectedResult": [expectedResult],
    });
    expect(router.handle("/users", parameters: params).result,
        equals(expectedResult));
  });

  test("Handler matches non-wildcard route", () {
    final expectedResult = 200;
    final params = Parameters.fromMap({
      "expectedResult": [expectedResult],
    });
    expect(router.handle("/users", parameters: params).result,
        equals(expectedResult));
  });

  test("Handler matches wildcard route", () {
    final userId = "55";
    expect(router.handle("/users/$userId").result, equals(userId));
  });

  test("Prioritize non-wildcard route over later defined wildcard one", () {
    expect(router.handle("/users/profile").result, equals("myProfile"));
  });

  test("Prioritize wildcard route over later defined non-wildcard one", () {
    final expectedResult = "testList";
    final params = Parameters.fromMap({
      "expectedResult": [expectedResult],
    });
    expect(router.handle("/users/list", parameters: params).result,
        isNot("testList"));
  });

  test("Match querystring parameter", () {
    final expectedResult = "750";
    expect(router.handle("/users?expectedResult=$expectedResult").result,
        equals(expectedResult));
  });

  test("Match querystring parameter with passed parameters", () {
    final expectedResult = "750";
    final params = Parameters.fromMap({
      "item1": "testing",
      "item2": "yakka",
    });
    final matchResult = router.handle(
      "/users?expectedResult=$expectedResult",
      parameters: params,
    );
    expect(matchResult.result, equals(expectedResult));
  });

  test("Match result from in-line callback definition", () {
    final expectedResult = 99;
    expect(router.handle("/test").result, equals(expectedResult));
  });

  test("Handler receives global context correctly", () {
    final expectedResult = _globalContextValue;
    expect(router.handle("/gcontext").result, equals(expectedResult));
  });

  test("Handler receives local context correctly", () {
    final expectedResult = "local value";
    expect(router.handle("/lcontext", context: expectedResult).result,
        equals(expectedResult));
  });

  test("Handler hits the no match handler", () {
    final expectedResult = -1;
    expect(router.handle("/notavalidpath").result, equals(expectedResult));
  });

  test("Manual match fails to find non-defined route", () {
    final result = router.match("/doesnotexist");
    expect(result.matchType, equals(MatchStatus.noMatch));
  });

  test("Manual match finds defined route", () {
    final result = router.match("/lcontext");
    expect(result.matchType, equals(MatchStatus.match));
  });

  test("Manual match finds defined route with parameter", () {
    final result = router.match("/users/55");
    expect(result.matchType, equals(MatchStatus.match));
  });

  test("Manual match finds defined route and parameter is collected", () {
    final result = router.match("/users/55");
    expect(result.parameters.firstString("id"), equals("55"));
  });

  test("Match result state indicates match correctly", () {
    final result = router.match("/users/55");
    expect(result.wasMatched, isTrue);
  });

  test("Match result state indicates non-match correctly", () {
    final result = router.match("/banana");
    expect(result.wasNotMatched, isTrue);
  });

  test("Match contains empty parameters value", () {
    final result = router.handle("/empty");
    expect(result.parameters.isEmpty, isTrue);
  });

  test("Match contains non-empty parameters value", () {
    final params = Parameters.fromMap({
      "something": "a value",
    });
    final result = router.handle(
      "/empty",
      parameters: params,
    );
    expect(result.parameters.isNotEmpty, isTrue);
  });
}

dynamic _emptyCallback(Context context) {}

dynamic _genericMatchCallback(Context context) {
  final Parameters parameters = context.parameters;
  return parameters.first('expectedResult');
}

dynamic _userMatchCallback(Context context) {
  final Parameters parameters = context.parameters;
  return parameters.firstString('id');
}

dynamic _profileMatchCallback(Context context) {
  return 'myProfile';
}

dynamic _noMatchCallback(Context context) {
  return -1;
}

dynamic _contextCallback(Context context) {
  return context;
}
