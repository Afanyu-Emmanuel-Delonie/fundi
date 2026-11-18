class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double screen = 20; // side padding of every screen
}

/// Nested corners: inner radius = outer radius - padding.
class AppRadius {
  AppRadius._();
  static const double sm = 8;     // chips, badges
  static const double md = 12;    // buttons, inputs, thumbnails
  static const double lg = 16;    // cards, sheets
  static const double xl = 20;    // big panels
  static const double pill = 999; // avatars, search, filter chips
}