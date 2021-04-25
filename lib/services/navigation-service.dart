import 'package:przepisnik_v3/models/routes.dart';
import 'package:przepisnik_v3/globals/globals.dart' as globals;

class NavigationService {
  init(Function handler) {
    globals.globalNavHandler = handler;
    print(globals.globalNavHandler);
  }

  handleNavigation(Routes route) {
    globals.globalNavHandler(route);
  }
}
