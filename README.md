
# WebVTTParser

Swift package to parse WebVTT subtitles.

[![CI](https://github.com/mihai8804858/swift-webvtt-parser/actions/workflows/ci.yml/badge.svg)](https://github.com/mihai8804858/swift-webvtt-parser/actions/workflows/ci.yml) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmihai8804858%2Fswift-webvtt-parser%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/mihai8804858/swift-webvtt-parser) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmihai8804858%2Fswift-webvtt-parser%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/mihai8804858/swift-webvtt-parser)


## Installation

You can add `swift-webvtt-parser` to an Xcode project by adding it to your project as a package.

> https://github.com/mihai8804858/swift-webvtt-parser

If you want to use `swift-webvtt-parser` in a [SwiftPM](https://swift.org/package-manager/) project, it's as
simple as adding it to your `Package.swift`:

``` swift
dependencies: [
  .package(url: "https://github.com/mihai8804858/swift-webvtt-parser", from: "1.0.0")
]
```

And then adding the product to any target that needs access to the library:

```swift
.product(name: "WebVTTParser", package: "swift-webvtt-parser"),
```

## Quick Start

* Create an instance of `WebVTTParser`:
```swift
private let parser = WebVTTParser()
```
* Get the WebVTT contents:
```swift
let contents = ...
```
* Parse the contents into a structured model:
```swift
let vtt = try parser.parse(contents)
```
* Print an `WebVTT` model back into raw contents:
```swift
let contents = try parser.print(vtt)
```

## Example

### Parsing

```swift
let contents = """
WEBVTT

1
00:02:17.440 --> 00:02:20.375
Senator, we're making
our <b>final</b> approach into <u>Coruscant</u>.

2
00:02:20.476 --> 00:02:22.501 line:5 line:80% position:50% size:60% align:center
<b>Very good, <i>Lieutenant</i></b>.
"""

dump(try WebVTTParser().parse(contents))
```

```
▿ WebVTTParser.WebVTT
  ▿ header: WebVTTParser.WebVTT.Header
    - text: nil
    - metadata: 0 elements
  ▿ elements: 2 elements
    ▿ WebVTTParser.WebVTT.Element.cue
      ▿ cue: WebVTTParser.WebVTT.Cue
        ▿ metadata: WebVTTParser.WebVTT.CueMetadata
          ▿ identifier: Optional("1")
            - some: "1"
          ▿ timing: WebVTTParser.WebVTT.Timing
            ▿ start: WebVTTParser.WebVTT.Time
              - hours: 0
              - minutes: 2
              - seconds: 17
              - milliseconds: 440
            ▿ end: WebVTTParser.WebVTT.Time
              - hours: 0
              - minutes: 2
              - seconds: 20
              - milliseconds: 375
          - settings: 0 elements
        ▿ payload: WebVTTParser.WebVTT.CuePayload
          ▿ components: 5 elements
            ▿ WebVTTParser.WebVTT.CuePayload.Component.plain
              ▿ plain: (1 element)
                - text: "Senator, we\'re making\nour "
            ▿ WebVTTParser.WebVTT.CuePayload.Component.bold
              ▿ bold: (2 elements)
                - classes: 0 elements
                ▿ children: 1 element
                  ▿ WebVTTParser.WebVTT.CuePayload.Component.plain
                    ▿ plain: (1 element)
                      - text: "final"
            ▿ WebVTTParser.WebVTT.CuePayload.Component.plain
              ▿ plain: (1 element)
                - text: " approach into "
            ▿ WebVTTParser.WebVTT.CuePayload.Component.underline
              ▿ underline: (2 elements)
                - classes: 0 elements
                ▿ children: 1 element
                  ▿ WebVTTParser.WebVTT.CuePayload.Component.plain
                    ▿ plain: (1 element)
                      - text: "Coruscant"
            ▿ WebVTTParser.WebVTT.CuePayload.Component.plain
              ▿ plain: (1 element)
                - text: "."
    ▿ WebVTTParser.WebVTT.Element.cue
      ▿ cue: WebVTTParser.WebVTT.Cue
        ▿ metadata: WebVTTParser.WebVTT.CueMetadata
          ▿ identifier: Optional("2")
            - some: "2"
          ▿ timing: WebVTTParser.WebVTT.Timing
            ▿ start: WebVTTParser.WebVTT.Time
              - hours: 0
              - minutes: 2
              - seconds: 20
              - milliseconds: 476
            ▿ end: WebVTTParser.WebVTT.Time
              - hours: 0
              - minutes: 2
              - seconds: 22
              - milliseconds: 501
          ▿ settings: 5 elements
            ▿ WebVTTParser.WebVTT.Setting.lineNumber
              - lineNumber: 5
            ▿ WebVTTParser.WebVTT.Setting.linePercentage
              - linePercentage: 80
            ▿ WebVTTParser.WebVTT.Setting.position
              - position: 50
            ▿ WebVTTParser.WebVTT.Setting.size
              - size: 60
            ▿ WebVTTParser.WebVTT.Setting.align
              - align: WebVTTParser.WebVTT.Setting.Alignment.center
        ▿ payload: WebVTTParser.WebVTT.CuePayload
          ▿ components: 2 elements
            ▿ WebVTTParser.WebVTT.CuePayload.Component.bold
              ▿ bold: (2 elements)
                - classes: 0 elements
                ▿ children: 2 elements
                  ▿ WebVTTParser.WebVTT.CuePayload.Component.plain
                    ▿ plain: (1 element)
                      - text: "Very good, "
                  ▿ WebVTTParser.WebVTT.CuePayload.Component.italic
                    ▿ italic: (2 elements)
                      - classes: 0 elements
                      ▿ children: 1 element
                        ▿ WebVTTParser.WebVTT.CuePayload.Component.plain
                          ▿ plain: (1 element)
                            - text: "Lieutenant"
            ▿ WebVTTParser.WebVTT.CuePayload.Component.plain
              ▿ plain: (1 element)
                - text: "."
```

### Printing

```swift
let vtt = WebVTT {
    cue(identifier: "1", timing: 137.44...140.375) {
        plain("Senator, we're making\nour ")
        bold {
            plain("final")
        }
        plain(" approach into ")
        underline {
            plain("Coruscant")
        }
        plain(".")
    }
    cue(identifier: "2", timing: 140.476...142.501) {
        bold {
            plain("Very good, ")
            italic {
                plain("Lieutenant")
            }
        }
        plain(".")
    }
}

print(try WebVTTParser().print(vtt))
```

```
WEBVTT

1
02:17.440 --> 02:20.375
Senator, we're making
our <b>final</b> approach into <u>Coruscant</u>.

2
02:20.476 --> 02:22.501
<b>Very good, <i>Lieutenant</i></b>.
```

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
