import 'package:platform_info/platform_info.dart';

bool get isDesktop {
  return !Platform.I.isWeb && Platform.I.isDesktop;
}

bool get isMobile {
  return !Platform.I.isWeb && Platform.I.isMobile;
}

bool get isWeb {
  return Platform.I.isWeb;
}

bool get isAndroid {
  return !Platform.I.isWeb && Platform.I.isAndroid;
}

bool get isIOS {
  return !Platform.I.isWeb && Platform.I.isIOS;
}

bool get isMacOS {
  return !Platform.I.isWeb && Platform.I.isMacOS;
}

bool get isWindows {
  return !Platform.I.isWeb && Platform.I.isWindows;
}

bool get isLinux {
  return !Platform.I.isWeb && Platform.I.isLinux;
}
