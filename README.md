# TMS WEB Core JSON Editor

This repository contains a JSON editor that has been built with TMS WEB Core (Delphi) and its Miletus Framework, resulting in standard binaries for Windows, Linux, macOS, and Raspberry Pi. This repository also includes a separate TMS WEB Core project used to generate the website published directly here on GitHub, where these executables can be downloaded. This project first appeared in connection with a blog post on the TMS Software website, which can be found here. 

The basic idea behind this project is to provide an alternative front end for JSON configuration files, including the configuration file for this project.  We've all made typos in JSON files, like forgetting a comma or using a {, [, or ( when one of the others was called for. And sometimes it would help to have a bit more information, context, or other documentation when it comes to filling in a value or adding a key of some kind. Well, this is what this tool is for. This project will load up a "Project" JSON file that describes, well, another JSON file. This Project JSON file will describe what should be in the target JSON file, along with other documentation, rules, themes, and so on to help with managing the other file, to the point where this is all that is required for an average person (not a developer!) to make changes without fear of producing an unusable JSON file.

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
[![Count Lines of Code](https://github.com/500Foods/Catheedral/actions/workflows/main.yml/badge.svg)](https://github.com/500Foods/Catheedral/actions/workflows/main.yml)
```
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SUM:                             0             0               0              0
-------------------------------------------------------------------------------
```

## Sponsor / Donate / Support
If you find this work interesting, helpful, or valuable, or that it has saved you time, money, or both, please consider directly supporting these efforts financially via [GitHub Sponsors](https://github.com/sponsors/500Foods) or donating via [Buy Me a Pizza](https://www.buymeacoffee.com/andrewsimard500). Also, check out these other [GitHub Repositories](https://github.com/500Foods?tab=repositories&q=&sort=stargazers) that may interest you.
