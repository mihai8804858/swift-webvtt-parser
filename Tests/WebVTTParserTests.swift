@testable import WebVTTParser
import Parsing
import CustomDump
import XCTest

// swiftlint:disable:next type_body_length
final class WebVTTParserTests: XCTestCase {
    // swiftlint:disable:next function_body_length
    func test_parse() throws {
        let content = """
        WEBVTT - Subtitle header goes here
        Kind: captions
        Language: en-US
        Title: Law & Murder
        ContentAdvisory: TV-14

        STYLE
        /* Default cue styling */
        ::cue {
            background-image: linear-gradient(to bottom, dimgray, lightgray);
            color: blue;
        }
        /* Classes that can be applied to individual cues or phrases */
        ::cue(.bg-yellow) {
            background-color: yellow;
        }
        ::cue(.green) {
            color: green;
        }

        This can't be parsed

        STYLE
        ::cue {
          background-image: linear-gradient(to bottom, dimgray, lightgray);
          color: papayawhip;
        }

        NOTE This is a comment

        STYLE
        ::cue(crédit de transcription) {
          color: peachpuff;
        }

        REGION
        id:region_1
        lines:1
        scroll:up
        width:40%
        regionanchor:50%,50%
        viewportanchor:50%,50%

        1
        00:01.000 --> 10:04.123
        <ruby.a.b.c>- Never drink liquid nitrogen &amp; bad <rt>stuff</rt>.</ruby>

        NOTE
        One comment that is spanning
        more than one line.

        NOTE You can also make a comment
        across more than one line this way.

        Second Cue
        01:02:05.123 --> 01:23:45.000
        You could &lt;die&gt;.

        STYLE
        ::cue(1) {
          color: lime;
        }

        NOTE
        This last line may not translate well.

        12:34:56.789 --> 23:46:07.890
        <green>Seriously...</green>

        c0000001
        00:00:05.550 --> 00:00:06.760 line:90% align:center
        <Default><b>[JOO JAE-HWAN]
        We gotta get outta here!</b></Default>

        12:34:56.789 --> 23:46:07.890 vertical:rl
        <14:34:56.789>This cue has &nbsp;one <34:56.789>setting

        12:34:56.789 --> 23:46:07.890 vertical:lr line:1
        This cue has &lrm;two settings

        12:34:56.789 --> 23:46:07.890 line:-5 line:100% position:50% size:50% align:center
        This cue has &rlm;multiple settings

        12:34:56.789 --> 23:46:07.890 region:region_1
        <c.my-class><b>Lorem ipsum dolor sit amet,</b> consectetur adipiscing elit.
        <i>Proin ultricies nunc ut turpis pharetra, <u>quis aliquet ligula laoreet</u>.
        <v Mike>Vivamus</v> facilisis odio risus, ut tristique elit sagittis ac.</i></c>

        12:34:56.789 --> 23:46:07.890
        <c>Optional class name</c>

        12:34:56.789 --> 23:46:07.890
        <lang fr-FR>This is in French</lang>

        12:34:56.789 --> 23:46:07.890
        <c><b.bold-pseudo-class>Lorem ipsum dolor sit amet,</b> consectetur adipiscing elit.
        <i.italic-pseudo-class>Proin ultricies nunc ut turpis pharetra,
        <u.underline-pseudo-class>quis aliquet ligula laoreet</u>.
        <v.voice-pseudo-class Mike>Vivamus</v> facilisis odio risus, ut tristique elit sagittis ac.</i></c>
        <ruby.ruby-pseudo-class>Ruby<rt.ruby-text-pseudo-class>Ruby Text</rt></ruby>

        12:34:56.789 --> 23:46:07.890
        <v Mike>This is spoken by Mike
        """

        let expected = WebVTT(header: WebVTT.Header(
            text: "- Subtitle header goes here",
            metadata: [
                WebVTT.HeaderMetadata(key: "Kind", value: "captions"),
                WebVTT.HeaderMetadata(key: "Language", value: "en-US"),
                WebVTT.HeaderMetadata(key: "Title", value: "Law & Murder"),
                WebVTT.HeaderMetadata(key: "ContentAdvisory", value: "TV-14")
            ]
        )) {
            style("""
            /* Default cue styling */
            ::cue {
                background-image: linear-gradient(to bottom, dimgray, lightgray);
                color: blue;
            }
            /* Classes that can be applied to individual cues or phrases */
            ::cue(.bg-yellow) {
                background-color: yellow;
            }
            ::cue(.green) {
                color: green;
            }
            """
            )
            unknown("This can't be parsed")
            style("""
            ::cue {
              background-image: linear-gradient(to bottom, dimgray, lightgray);
              color: papayawhip;
            }
            """)
            note("This is a comment")
            style("""
            ::cue(crédit de transcription) {
              color: peachpuff;
            }
            """)
            region {
                WebVTT.RegionSetting.id("region_1")
                WebVTT.RegionSetting.lines(1)
                WebVTT.RegionSetting.scroll(.up)
                WebVTT.RegionSetting.widthPercentage(40)
                WebVTT.RegionSetting.anchor(WebVTT.RegionAnchor(xPercentage: 50, yPercentage: 50))
                WebVTT.RegionSetting.viewPortAnchor(WebVTT.RegionAnchor(xPercentage: 50, yPercentage: 50))
            }
            cue(identifier: "1", timing: 1...604.123) {
                ruby(classes: ["a", "b", "c"]) {
                    plain("- Never drink liquid nitrogen & bad ")
                    rubyText {
                        plain("stuff")
                    }
                    plain(".")
                }
            }
            note("One comment that is spanning\nmore than one line.")
            note("You can also make a comment\nacross more than one line this way.")
            cue(identifier: "Second Cue", timing: 3725.123...5025) {
                plain("You could <die>.")
            }
            style("""
            ::cue(1) {
              color: lime;
            }
            """)
            note("This last line may not translate well.")
            cue(timing: 45296.789...85567.89) {
                styleClass(name: "green") {
                    plain("Seriously...")
                }
            }
            cue(identifier: "c0000001", timing: 5.55...6.76, settings: [.linePercentage(90), .align(.center)]) {
                styleClass(name: "Default") {
                    bold {
                        plain("[JOO JAE-HWAN]\nWe gotta get outta here!")
                    }
                }
            }
            cue(timing: 45296.789...85567.89, settings: [.vertical(.rl)]) {
                timestamp(
                    time: WebVTT.Time(hours: 14, minutes: 34, seconds: 56, milliseconds: 789)
                ) {
                    plain("This cue has \u{00a0}one ")
                }
                timestamp(
                    time: WebVTT.Time(hours: 0, minutes: 34, seconds: 56, milliseconds: 789)
                ) {
                    plain("setting")
                }
            }
            cue(timing: 45296.789...85567.89, settings: [.vertical(.lr), .lineNumber(1)]) {
                plain("This cue has \u{200e}two settings")
            }
            cue(timing: 45296.789...85567.89, settings: [
                .lineNumber(-5),
                .linePercentage(100),
                .position(50),
                .size(50),
                .align(.center)
            ]) {
                plain("This cue has \u{200f}multiple settings")
            }
            cue(timing: 45296.789...85567.89, settings: [.region("region_1")]) {
                styleClass(name: "my-class") {
                    bold {
                        plain("Lorem ipsum dolor sit amet,")
                    }
                    plain(" consectetur adipiscing elit.\n")
                    italic {
                        plain("Proin ultricies nunc ut turpis pharetra, ")
                        underline {
                            plain("quis aliquet ligula laoreet")
                        }
                        plain(".\n")
                        voice(name: "Mike") {
                            plain("Vivamus")
                        }
                        plain(" facilisis odio risus, ut tristique elit sagittis ac.")
                    }
                }
            }
            cue(timing: 45296.789...85567.89) {
                styleClass {
                    plain("Optional class name")
                }
            }
            cue(timing: 45296.789...85567.89) {
                language(locale: "fr-FR") {
                    plain("This is in French")
                }
            }
            cue(timing: 45296.789...85567.89) {
                styleClass {
                    bold(classes: ["bold-pseudo-class"]) {
                        plain("Lorem ipsum dolor sit amet,")
                    }
                    plain(" consectetur adipiscing elit.\n")
                    italic(classes: ["italic-pseudo-class"]) {
                        plain("Proin ultricies nunc ut turpis pharetra,\n")
                        underline(classes: ["underline-pseudo-class"]) {
                            plain("quis aliquet ligula laoreet")
                        }
                        plain(".\n")
                        voice(classes: ["voice-pseudo-class"], name: "Mike") {
                            plain("Vivamus")
                        }
                        plain(" facilisis odio risus, ut tristique elit sagittis ac.")
                    }
                }
                plain("\n")
                ruby(classes: ["ruby-pseudo-class"]) {
                    plain("Ruby")
                    rubyText(classes: ["ruby-text-pseudo-class"]) {
                        plain("Ruby Text")
                    }
                }
            }
            cue(timing: 45296.789...85567.89) {
                voice(name: "Mike") {
                    plain("This is spoken by Mike")
                }
            }
        }
        let parser = WebVTTParser()
        let vtt = try parser.parse(content)
        XCTAssertNoDifference(vtt, expected)
    }

    // swiftlint:disable:next function_body_length
    func test_print() throws {
        let vtt = WebVTT(header: WebVTT.Header(
            text: "- Subtitle header goes here",
            metadata: [
                WebVTT.HeaderMetadata(key: "Kind", value: "captions"),
                WebVTT.HeaderMetadata(key: "Language", value: "en-US"),
                WebVTT.HeaderMetadata(key: "Title", value: "Law & Murder"),
                WebVTT.HeaderMetadata(key: "ContentAdvisory", value: "TV-14")
            ]
        )) {
            style("""
            ::cue {
                background-image: linear-gradient(to bottom, dimgray, lightgray);
                color: blue;
            }
            ::cue(.bg-yellow) {
                background-color: yellow;
            }
            ::cue(.green) {
                color: green;
            }
            """
            )
            unknown("This can't be parsed")
            style("""
            ::cue {
              background-image: linear-gradient(to bottom, dimgray, lightgray);
              color: papayawhip;
            }
            """)
            note("This is a comment")
            style("""
            ::cue(crédit de transcription) {
              color: peachpuff;
            }
            """)
            region {
                WebVTT.RegionSetting.id("region_1")
                WebVTT.RegionSetting.lines(1)
                WebVTT.RegionSetting.scroll(.up)
                WebVTT.RegionSetting.widthPercentage(40)
                WebVTT.RegionSetting.anchor(WebVTT.RegionAnchor(xPercentage: 50, yPercentage: 50))
                WebVTT.RegionSetting.viewPortAnchor(WebVTT.RegionAnchor(xPercentage: 50, yPercentage: 50))
            }
            cue(identifier: "1", timing: 1...604.123) {
                ruby(classes: ["a", "b", "c"]) {
                    plain("- Never drink liquid nitrogen & bad ")
                    rubyText {
                        plain("stuff")
                    }
                    plain(".")
                }
            }
            note("One comment that is spanning\nmore than one line.")
            note("You can also make a comment\nacross more than one line this way.")
            cue(identifier: "Second Cue", timing: 3725.123...5025) {
                plain("You could <die>.")
            }
            style("""
            ::cue(1) {
              color: lime;
            }
            """)
            note("This last line may not translate well.")
            cue(timing: 45296.789...85567.89) {
                styleClass(name: "green") {
                    plain("Seriously...")
                }
            }
            cue(identifier: "c0000001", timing: 5.55...6.76, settings: [.linePercentage(90), .align(.center)]) {
                styleClass(name: "Default") {
                    bold {
                        plain("[JOO JAE-HWAN]\nWe gotta get outta here!")
                    }
                }
            }
            cue(timing: 45296.789...85567.89, settings: [.vertical(.rl)]) {
                timestamp(
                    time: WebVTT.Time(hours: 14, minutes: 34, seconds: 56, milliseconds: 789)
                ) {
                    plain("This cue has \u{00a0}one ")
                }
                timestamp(
                    time: WebVTT.Time(hours: 0, minutes: 34, seconds: 56, milliseconds: 789)
                ) {
                    plain("setting")
                }
            }
            cue(timing: 45296.789...85567.89, settings: [.vertical(.lr), .lineNumber(1)]) {
                plain("This cue has \u{200e}two settings")
            }
            cue(timing: 45296.789...85567.89, settings: [
                .lineNumber(-5),
                .linePercentage(100),
                .position(50),
                .size(50),
                .align(.center)
            ]) {
                plain("This cue has \u{200f}multiple settings")
            }
            cue(timing: 45296.789...85567.89, settings: [.region("region_1")]) {
                styleClass(name: "my-class") {
                    bold {
                        plain("Lorem ipsum dolor sit amet,")
                    }
                    plain(" consectetur adipiscing elit.\n")
                    italic {
                        plain("Proin ultricies nunc ut turpis pharetra, ")
                        underline {
                            plain("quis aliquet ligula laoreet")
                        }
                        plain(".\n")
                        voice(name: "Mike") {
                            plain("Vivamus")
                        }
                        plain(" facilisis odio risus, ut tristique elit sagittis ac.")
                    }
                }
            }
            cue(timing: 45296.789...85567.89) {
                styleClass {
                    plain("Optional class name")
                }
            }
            cue(timing: 45296.789...85567.89) {
                language(locale: "fr-FR") {
                    plain("This is in French")
                }
            }
            cue(timing: 45296.789...85567.89) {
                styleClass {
                    bold(classes: ["bold-pseudo-class"]) {
                        plain("Lorem ipsum dolor sit amet,")
                    }
                    plain(" consectetur adipiscing elit.\n")
                    italic(classes: ["italic-pseudo-class"]) {
                        plain("Proin ultricies nunc ut turpis pharetra,\n")
                        underline(classes: ["underline-pseudo-class"]) {
                            plain("quis aliquet ligula laoreet")
                        }
                        plain(".\n")
                        voice(classes: ["voice-pseudo-class"], name: "Mike") {
                            plain("Vivamus")
                        }
                        plain(" facilisis odio risus, ut tristique elit sagittis ac.")
                    }
                }
                plain("\n")
                ruby(classes: ["ruby-pseudo-class"]) {
                    plain("Ruby")
                    rubyText(classes: ["ruby-text-pseudo-class"]) {
                        plain("Ruby Text")
                    }
                }
            }
            cue(timing: 45296.789...85567.89) {
                voice(name: "Mike") {
                    plain("This is spoken by Mike")
                }
            }
        }

        let content = try WebVTTParser().print(vtt)
        XCTAssertNoDifference(content, """
        WEBVTT - Subtitle header goes here
        Kind: captions
        Language: en-US
        Title: Law & Murder
        ContentAdvisory: TV-14

        STYLE
        ::cue {
            background-image: linear-gradient(to bottom, dimgray, lightgray);
            color: blue;
        }
        ::cue(.bg-yellow) {
            background-color: yellow;
        }
        ::cue(.green) {
            color: green;
        }

        This can't be parsed

        STYLE
        ::cue {
          background-image: linear-gradient(to bottom, dimgray, lightgray);
          color: papayawhip;
        }

        NOTE
        This is a comment

        STYLE
        ::cue(crédit de transcription) {
          color: peachpuff;
        }

        REGION
        id:region_1
        lines:1
        scroll:up
        width:40%
        regionanchor:50%,50%
        viewportanchor:50%,50%

        1
        00:01.000 --> 10:04.123
        <ruby.a.b.c>- Never drink liquid nitrogen &amp; bad <rt>stuff</rt>.</ruby>

        NOTE
        One comment that is spanning
        more than one line.

        NOTE
        You can also make a comment
        across more than one line this way.

        Second Cue
        01:02:05.123 --> 01:23:45.000
        You could &lt;die&gt;.

        STYLE
        ::cue(1) {
          color: lime;
        }

        NOTE
        This last line may not translate well.

        12:34:56.789 --> 23:46:07.890
        <c.green>Seriously...</c>

        c0000001
        00:05.550 --> 00:06.760 line:90% align:center
        <c.Default><b>[JOO JAE-HWAN]
        We gotta get outta here!</b></c>

        12:34:56.789 --> 23:46:07.890 vertical:rl
        <14:34:56.789>This cue has &nbsp;one <34:56.789>setting

        12:34:56.789 --> 23:46:07.890 vertical:lr line:1
        This cue has &lrm;two settings

        12:34:56.789 --> 23:46:07.890 line:-5 line:100% position:50% size:50% align:center
        This cue has &rlm;multiple settings

        12:34:56.789 --> 23:46:07.890 region:region_1
        <c.my-class><b>Lorem ipsum dolor sit amet,</b> consectetur adipiscing elit.
        <i>Proin ultricies nunc ut turpis pharetra, <u>quis aliquet ligula laoreet</u>.
        <v Mike>Vivamus</v> facilisis odio risus, ut tristique elit sagittis ac.</i></c>

        12:34:56.789 --> 23:46:07.890
        <c>Optional class name</c>

        12:34:56.789 --> 23:46:07.890
        <lang fr-FR>This is in French</lang>

        12:34:56.789 --> 23:46:07.890
        <c><b.bold-pseudo-class>Lorem ipsum dolor sit amet,</b> consectetur adipiscing elit.
        <i.italic-pseudo-class>Proin ultricies nunc ut turpis pharetra,
        <u.underline-pseudo-class>quis aliquet ligula laoreet</u>.
        <v.voice-pseudo-class Mike>Vivamus</v> facilisis odio risus, ut tristique elit sagittis ac.</i></c>
        <ruby.ruby-pseudo-class>Ruby<rt.ruby-text-pseudo-class>Ruby Text</rt></ruby>

        12:34:56.789 --> 23:46:07.890
        <v Mike>This is spoken by Mike</v>
        """)
    }
}

// swiftlint:disable:this file_length
