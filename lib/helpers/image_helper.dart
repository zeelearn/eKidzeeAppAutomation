// Cross-platform image helper. Chooses the correct implementation
// depending on whether the app is compiled for web or IO.
export 'image_helper_io.dart' if (dart.library.html) 'image_helper_web.dart';
