# TMS WEB Core JSON Editor

This repository contains a JSON editor that has been built with [TMS WEB Core](https://www.tmssoftware.com/site/tmswebcore.asp) (Delphi) and its Miletus Framework, resulting in standard binaries for Windows, Linux, macOS, and Raspberry Pi. This repository also includes a separate TMS WEB Core project used to generate the website published directly here on GitHub, where these executables can be downloaded. This project first appeared in connection with a blog post on the TMS Software website, which can be found here. 

The basic idea behind this project is to provide an app for editing JSON configuration files.  We've all made typos in JSON files, like forgetting a comma or using a {, [, or ( when one of the others was called for. And sometimes it would help to have a bit more information, context, or other documentation when it comes to filling in a value or adding a key of some kind. Well, this is what this tool is for. 

When the app first starts, it loads up its own JSON configuration file which tells it what "configurations" are available. Each configuration describes a JSON format, like a Manifest.json file for the web, or even the JSON file used by this app. These "configurations", which are JSON files themselves, describe the object hierarchy of a given JSON file and can provide additional comments, formatting guidelines, input helpers and more.

The app is intended to be used by other projects, providing a much-needed tool for editing increasingly complex JSON configuration files. As a fallback, it also leans on the very capable [svelte-jsoneditor](https://github.com/josdejong/svelte-jsoneditor), used as a fallback of sorts when the available "configurations" don't cover a particular JSON format.

## Key Dependencies
As with any modern web application, other JavaScript libraries/dependencies have been used in this project. Most of the time, this is handled via a CDN link (usually JSDelivr) in the Project.html file. In some cases, for performance or other reasons, they may be included directly.
- [TMS WEB Core](https://www.tmssoftware.com/site/tmswebcore.asp) - This is a TMS WEB Core project, after all
- [AdminLTE 4](https://github.com/ColorlibHQ/AdminLTE/tree/v4-dev) - Naturally
- [Home Assistant](https://www.home-assistant.io/) - Need a current Home Assistant server to be of much use
- [Bootstrap](https://getbootstrap.com/) - No introduction needed
- [Tabulator](https://www.tabulator.info) - Fantastic pure JavaScript web data tables
- [Font Awesome](https://www.fontawesome.com) - The very best icons
- [Material Design Icons](https://pictogrammers.com/library/mdi/) - Used throughout Home Assistant
- [Leaflet](https://www.leafletjs.com) - Excellent mapping library
- [OpenStreetMap](https://www.openstreetmap.org) - Mapping tile data
- [Luxon](https://moment.github.io/luxon/#/) - For handling date/time conversions
- [Shoelace](https://shoelace.style/) - Web components, particularly the color picker for lights
- [Peity Vanilla JS](https://github.com/railsjazz/peity_vanilla) - Fast and simple charts
- [Meteocons](https://github.com/basmilius/weather-icons) - Animated Weather Icons by [Bas Milius](https://bas.dev/)
- [SwiperJS](https://swiperjs.com) - Currently works well with v10
- [FlatPickr](https://flatpickr.js.org) - Main UI date pickers
- [Vanilla Lazy Load](https://github.com/verlok/vanilla-lazyload) - So placeholders can be used
- [FlagPack](https://github.com/jackiboy/flagpack) - For displaying citizenship flags
- [PanZoom](https://github.com/timmywil/panzoom) - Used when viewing photos/posters/backgrounds
- [HackTimer](https://github.com/turuslan/HackTimer) - Bypasses normal JavaScript timer behaviour
- [AudioBuffer-ArrayBuffer-Serializer](https://github.com/suzuito/audiobuffer-arraybuffer-serializer) - Useful for moving audio data around
- [InteractJS](https://interactjs.io/) - Dragging and resizing UI elements of all kinds
- [Simplebar](https://github.com/Grsmto/simplebar) - Used to create the custom hexagonal scrollbars
- [D3](https://d3js.org/) - Used here to draw audio waveforms
- [FileSaver](https://moment.github.io/luxon/#/?id=luxon) - For downloading HexaGong projects

## Additional Notes
While this project is currently under active development, feel free to give it a try and post any issues you encounter.  Or start a discussion if you would like to help steer the project in a particular direction.  Early days yet, so a good time to have your voice heard.  As the project unfolds, additional resources will be made available, including platform binaries, more documentation, demos, and so on.

## Repository Information 
[![Count Lines of Code](https://github.com/500Foods/TMS-WEB-Core-JsonEditor/actions/workflows/main.yml/badge.svg)](https://github.com/500Foods/TMS-WEB-Core-JsonEditor/actions/workflows/main.yml)
<!--CLOC-START -->
```
Last Updated at 2023-11-28 21:52:17 UTC
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Pascal                           3            130            161            600
Delphi Form                      1              0              0            355
CSS                              1             20              0            186
HTML                             3             15              6             68
Markdown                         1              8              2             52
YAML                             2              8             12             33
-------------------------------------------------------------------------------
SUM:                            11            181            181           1294
-------------------------------------------------------------------------------
```
<!--CLOC-END-->

## Sponsor / Donate / Support
If you find this work interesting, helpful, or valuable, or that it has saved you time, money, or both, please consider directly supporting these efforts financially via [GitHub Sponsors](https://github.com/sponsors/500Foods) or donating via [Buy Me a Pizza](https://www.buymeacoffee.com/andrewsimard500). Also, check out these other [GitHub Repositories](https://github.com/500Foods?tab=repositories&q=&sort=stargazers) that may interest you.
