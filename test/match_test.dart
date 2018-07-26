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

final _globalContextValue = 12345;

void main() {
  Router router;

  setUp(() {
    router = new Router(
      noMatchHandler: new Handler(callback: _noMatchCallback),
    );
    router.addRoute(new RouteDefinition.withCallback("/users",
        callback: _genericMatchCallback));
    router.addRoute(new RouteDefinition.withCallback("/users/profile",
        callback: _profileMatchCallback));
    router.addRoute(new RouteDefinition.withCallback("/users/:id",
        callback: _userMatchCallback));
    router.addRoute(new RouteDefinition.withCallback("/users/list",
        callback: _genericMatchCallback));
    router.addRoute(new RouteDefinition.withCallback("/gcontext",
        callback: _contextCallback, context: _globalContextValue));
    router.addRoute(new RouteDefinition.withCallback("/lcontext",
        callback: _contextCallback));

    router.addRoute(
      new RouteDefinition.withCallback("/test",
          callback: (Parameters parameters, dynamic context) {
        return 99;
      }),
    );
  });

  test("Handler matches non-wildcard route", () {
    final expectedResult = 200;
    expect(
        router
            .handle(
              "/users",
              parameters: new Parameters.fromMap({
                "expectedResult": [expectedResult],
              }),
            )
            .result,
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
    expect(
        router
            .handle("/users/list",
                parameters: new Parameters.fromMap({
                  "expectedResult": [expectedResult],
                }))
            .result,
        isNot("testList"));
  });

  test("Match querystring parameter", () {
    final expectedResult = "750";
    expect(router.handle("/users?expectedResult=$expectedResult").result,
        equals(expectedResult));
  });

  test("Match querystring parameter with passed parameters", () {
    final expectedResult = "750";
    expect(
        router
            .handle(
              "/users?expectedResult=$expectedResult",
              parameters: new Parameters.fromMap({
                "item1": "testing",
                "item2": "yakka",
              }),
            )
            .result,
        equals(expectedResult));
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
}

dynamic _genericMatchCallback(Parameters parameters, dynamic context) {
  return parameters.first("expectedResult");
}

dynamic _userMatchCallback(Parameters parameters, dynamic context) {
  return parameters.firstString("id");
}

dynamic _profileMatchCallback(Parameters parameters, dynamic context) {
  return "myProfile";
}

dynamic _noMatchCallback(Parameters parameters, dynamic context) {
  return -1;
}

dynamic _contextCallback(Parameters parameters, dynamic context) {
  return context;
}
