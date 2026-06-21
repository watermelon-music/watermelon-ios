/// Watermelon Dark — asset path constants.
///
/// Image variants live at the base path; Flutter automatically picks the
/// matching 2.0x / 3.0x file for the device's devicePixelRatio.
/// Icons are single-color SVGs (currentColor) — tint with flutter_svg's
/// `colorFilter: ColorFilter.mode(color, BlendMode.srcIn)`.
class AppAssets {
  AppAssets._();

  static const String _img = 'assets/images/';
  static const String _ico = 'assets/icons/';

  // ── Imagery ───────────────────────────────────────────────────────────
  static const String logoSlice = '${_img}logo-slice.png'; // transparent brand mark
  static const String sliceFlat = '${_img}slice-flat.png';
  static const String melonWhole = '${_img}melon-whole.png'; // avatar / round art
  static const String bgFieldTall = '${_img}bg-field-tall.png'; // onboarding / playlist hero
  static const String bgRiver = '${_img}bg-river.png'; // feature card
  static const String bgSandy = '${_img}bg-sandy.png'; // album art
  static const String patternSlices = '${_img}pattern-slices.png'; // tiled texture

  // ── Icons (SVG, currentColor) ─────────────────────────────────────────
  static const String home = '${_ico}home.svg';
  static const String search = '${_ico}search.svg';
  static const String radio = '${_ico}radio.svg';
  static const String profile = '${_ico}profile.svg';
  static const String play = '${_ico}play.svg';
  static const String pause = '${_ico}pause.svg';
  static const String skipNext = '${_ico}skip_next.svg';
  static const String skipPrev = '${_ico}skip_prev.svg';
  static const String shuffle = '${_ico}shuffle.svg';
  static const String repeat = '${_ico}repeat.svg';
  static const String heart = '${_ico}heart.svg';
  static const String heartFilled = '${_ico}heart_filled.svg';
  static const String queue = '${_ico}queue.svg';
  static const String bell = '${_ico}bell.svg';
  static const String settings = '${_ico}settings.svg';
  static const String chevronLeft = '${_ico}chevron_left.svg';
  static const String chevronRight = '${_ico}chevron_right.svg';
  static const String download = '${_ico}download.svg';
  static const String share = '${_ico}share.svg';
  static const String devices = '${_ico}devices.svg';
  static const String lyrics = '${_ico}lyrics.svg';
  static const String moreHoriz = '${_ico}more_horiz.svg';
  static const String close = '${_ico}close.svg';
  static const String plus = '${_ico}plus.svg';
  static const String check = '${_ico}check.svg';
  static const String mail = '${_ico}mail.svg';
  static const String lock = '${_ico}lock.svg';
  static const String eye = '${_ico}eye.svg';
}
