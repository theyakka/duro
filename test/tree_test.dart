import 'package:dazza/dazza.dart';
import 'package:test/test.dart';

void main() {
  final router = Router();
  router.addRoute(RouteDefinition.withCallback("/hello", callback: null));
  router.addRoute(RouteDefinition.withCallback("/test", callback: null));
  router.addRoute(RouteDefinition.withCallback("/banana", callback: null));

  test("Route print function runs", () {
    router.printTree();
  });
}
