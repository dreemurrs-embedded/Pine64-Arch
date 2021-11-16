# Changelog

* [2.5.0](#2-5-0)
* [2.4.6](#2-4-6)
* [2.4.5](#2-4-5)
* [2.4.4](#2-4-4)
* [2.4.3](#2-4-3)
* [2.4.2](#2-4-2)
* [2.4.1](#2-4-1)
* [2.4.0](#2-4-0)
* [2.3.3](#2-3-3)
* [2.3.2](#2-3-2)
* [2.3.1](#2-3-1)
* [2.3.0](#2-3-0)
* [2.2.7](#2-2-7)
* [2.2.6](#2-2-6)
* [2.2.5](#2-2-5)
* [2.2.4](#2-2-4)
* [2.2.3](#2-2-3)
* [2.2.2](#2-2-2)
* [2.2.1](#2-2-1)
* [2.2.0](#2-2-0)
* [2.1.3](#2-1-3)
* [2.1.2](#2-1-2)
* [2.1.1](#2-1-1)
* [2.1.0](#2-1-0)
* [2.0.0](#2-0-0)
* [1.1.7](#1-1-7)


## 2.5.0

### Added

* Text-run shaping now requires libutf8proc (in addition to
  HarfBuzz). Grapheme shaping still requires HarfBuzz only.
* `fcft_set_emoji_presentation()` - can be used to override emojis’
  **default** presentation style.


### Changed

* Meson command line option `-Dtext-shaping` have been replaced with
  `-Dgrapheme-shaping` and `-Drun-shaping`; grapheme shaping requires
  HarfBuzz only, while run shaping requires HarfBuzz **and**
  libutf8proc. Thus, enabling run shaping implicitly enables grapheme
  shaping.
* `fcft_*_rasterize()`: emojis’ default presentation is now accounted
  for when searching for a font containing the emoji codepoint;
  codepoints whose default presentation is “text” will no longer
  consider emoji fonts, and codepoints whose default presentation is
  “emoji” will no longer consider non-emoji fonts.


### Fixed

* `fcft_text_run_rasterize()`: much improved handling of RTL scripts
  (in mixed LTR/RTL strings in particular)


## 2.4.6

### Added

* UnicodeData updated to 14.0


### Fixed

* ‘wc’ field in `struct fcft_glyph` being assigned font index instead
  of Unicode codepoint in `fcft_grapheme_rasterize()` and
  `fcft_text_run_rasterize()`.
* Assertion in `glyph_cache_resize()`, triggered by trying to
  rasterize, and _failing_, a large amount of code points
  (https://codeberg.org/dnkl/foot/issues/763).
* Bad performance of grapheme cache when rasterizing many grapheme
  clusters.


### Contributors

* [emersion](https://codeberg.org/emersion)


## 2.4.5

### Fixed

* `fcft_text_run_rasterize()` not checking if codepoint is in the
  font’s charset before attempting shaping
  (https://codeberg.org/dnkl/fcft/issues/30).
* Crash when destroying a font with a grapheme cache entry
  representing a failed grapheme glyph.


## 2.4.4

### Fixed

* Rendering of bitmap fonts with Freetype >= 2.11
  (https://codeberg.org/dnkl/fcft/issues/29).


## 2.4.3

### Fixed

* Bitmap/aliased font glyphs being mirrored on big-endian
  architectures.
* Color font glyphs having wrong colors on big-endian architectures.
* Crash when destroying a font that failed to load (typically happens
  when there are no fonts available at all).


## 2.4.2

### Fixed

* Rare crash when one thread was doing a glyph cache lookup, while
  another was resizing the cache.


## 2.4.1

### Changed

* Log messages are now printed to stderr instead of stdout.
* `fcft_grapheme_rasterize()` now sets a minimum grapheme column count
  of 2 when the cluster ends with an Emoji variant selector (codepoint
  0xFE0F).


### Fixed

* Compilation error when fallback definition for `FCFT_EXPORT` was used
  in `meson.build`.


### Contributors

* [emersion](https://codeberg.org/emersion)
* [craigbarnes](https://codeberg.org/craigbarnes)


## 2.4.0

### Added

* Example program. Very simple bare bones Wayland program that renders
  a user provided string with user configurable fonts and colors. No
  proper error checking etc. To build, configure meson with
  `-Dexamples=true`.
* `fcft_log_init()`. This function enables, and configures logging in fcft.
* `fcft_text_run_rasterize()`: new API that uses HarfBuzz to shape a
  text run (i.e. a whole string). Note that HarfBuzz is (still) an
  **optional** dependency, see
  [README](README.md#user-content-building).
* `fcft_text_run_destroy()`: new API that frees a rasterized text-run.
* `FCFT_CAPABILITY_TEXT_RUN_SHAPING` added to `fcft_capabilities()`.
* `antialias` and `subpixel` members to `struct fcft_font`.


### Changed

* fcft logging must now be enabled explicitly (see `fcft_log_init()`).
* Internal logging functions are no longer exported by the shared library.
* The pixel size passed from FontConfig to FreeType is now rounded
  instead of truncated (https://codeberg.org/dnkl/foot/issues/456).


### Fixed

* Internal logging functions have been renamed, from generic `log_*`
  names to fcft specific `fcft_log_` names.
* Apply pixel-size fixup to glyphs’ advance width/height, but **only**
  if we estimated the fixup ourselves (otherwise the advance
  width/height is already scaled).


## 2.3.3

### Fixed

* Cloned fonts not being properly freed in library destructor.


## 2.3.2

### Added

* Limited support for _"fontfeatures_" . fcft is still not a layout
  engine, but with this we can support e.g. _stylistic sets_
  (HarfBuzz-enabled builds only).


### Deprecated

* `tags` argument in `fcft_grapheme_rasterize()`. It is now being
  ignored, and will be removed in a future release.


### Fixed

* Hang in library destructor when system has no fonts installed
  (https://codeberg.org/dnkl/foot/issues/174).


### Contributors

* [birger](https://codeberg.org/birger)


## 2.3.1

### Fixed

* `fcft_grapheme_rasterize()` now makes use of the optional
  `tags`. These were previously ignored.
* Compilation error when text shaping was disabled.


## 2.3.0

### Added

* `fcft_set_scaling_filter()`: new API that lets the calling
  application configure the filter to use when downscaling bitmap
  fonts (https://codeberg.org/dnkl/fcft/issues/9).
* `fcft_grapheme_rasterize()`: new API that uses HarfBuzz to shape a
  grapheme cluster. Note that HarfBuzz is an **optional** dependency,
  see [README](README.md#user-content-building).


### Changed

* Increased timeout in tests, from 4s (the default), to 60s
  (https://codeberg.org/dnkl/foot/issues/120).


## 2.2.7

### Changed

* Use lanczos3 filtering when downscaling bitmap fonts. This improves
  the quality of e.g. color emoji fonts.


### Fixed

* Compilation with `-pedantic`


## 2.2.6

### Fixed

* Set LCD filter. This fixes **severe** color fringes when FreeType
  has been built with `FT_CONFIG_OPTION_SUBPIXEL_RENDERING` (i.e. the
  old ClearType-style subpixel rendering, instead of the newer Harmony
  LCD rendering).


## 2.2.5

### Changed

* `fcft_glyph_rasterize()`: improved performance in threaded
  applications by guarding the glyph cache with an _rwlock_ instead of
  a _mutex_.


### Fixed

* fcft now checks for memory allocation failures.
* Compilation errors in 32-bit builds.


## 2.2.4

### Added

* Unicode license file, for `UnicodeData.txt`


## 2.2.3
### Added

* Missing [LICENSE](LICENSE) file
* [LICENSE](LICENSE), [README.md](README.md) and
  [CHANGELOG.md](CHANGELOG.md) are now installed to
  `${datadir}/doc/fcft`.


### Fixed

* Assertion in debug builds when resizing the glyph cache


## 2.2.2

### Fixed

* `fcft_kerning()` was not threadsafe
* Rare crash in `fcft_glyph_rasterize()` caused by a race between a
  successful glyph cache lookup and a glyph cache resize.


## 2.2.1

### Changed

* Color bitmap glyphs with a pixel-size fixup factor other than 1.0
  are now pre-scaled. Previously, fcft would only set a pixman scale
  transform on the glyph, causing actual scaling to occur **every**
  time the glyph was blended. This improves the performance when
  rendering color emojis.


## 2.2.0

### Changed

* Internal representation of the primary and fallback fonts.
* Do not load a fallback font if it does not contain the requested glyph.


### Deprecated

* `fcft_size_adjust()`


## 2.1.3

### Fixed

* Advance width and height of scaled bitmap fonts.


## 2.1.2

### Changed

* Glyph cache now resizes dynamically. This fixes a performance
  problem when loading **a lot** of glyphs, as we ended up scanning
  very long lists when looking up a glyph in the cache.


## 2.1.1

### Changed

* Prefer user-provided `charset`. This can be used to e.g. limit a
  fallback font's usage to a custom Unicode point range.


### Fixed

* LCD RGB/BGR modes were reversed.


## 2.1.0

### Added

* When looking for a glyph in the fallback fonts, don't discard
  (destroy/unload) the fonts that did not contain the glyph. This
  improves performance massively when loading lots of glyphs that does
  not exist in the primary font, or in the first fallback font(s).
* Synthetic bold and italics (FontConfig's _embolden_ and _matrix_
  properties).
* `fcft_precompose()` - combines a base- and a combining wide
  character into a single pre-composed character.


### Changed

* `fcft_from_name()` and `fcft_size_adjust()` no longer calls
  `setlocale()` to set a suitable locale for `FcParseName()`, as this
  was not thread safe. The caller is responsible for ensuring
  `LC_NUMERICAL` is set to a locale that correctly recognizes _x.y_
  decimal values.


### Fixed

* `fcft_from_name()` was not thread safe
* `fcft_clone()` was not thread safe
* `fcft_size_adjust()` was not thread safe
* `fcft_destroy` was not thread safe


## 2.0.0

### Changed

* API: `font_` prefix changed to `fcft_`.
* API: renamed `struct font` to `struct fcft_font`.
* API: renamed `struct glyph` to `struct fcft_glyph`.
* API: internal members of `struct fcft_glyph` removed.
* API: renamed `enum subpixel_order` to `enum fcft_subpixel`, and
  `ORDER` was removed from the enum values.
* API: renamed `fcft_glyph.x_advance` to `fcft_glyph.advance.x`, and
  added `fcft_glyph.advance.y`
* API: renamed `fcft_font.max_x_advance` to `fcft_font.max_advance.x`
  and added `fcft_font.max_advance.y`.
* API: renamed `fcft_font.space_x_advance` to
  `fcft_font.space_advance.x` and added `fcft_font.space_advance.y`.
* API: renamed `fcft_glyph_for_wc()` to `fcft_glyph_rasterize()`.
* Require meson >= 0.54.
* Use `meson.override_dependency()`.


### Fixed

* `fcft_kerning()` did not scale the returned kerning distances with
  the font's pixel size fixup multiplier.


## 1.1.7

### Fixed

* LCD RGB/BGR modes were reversed
