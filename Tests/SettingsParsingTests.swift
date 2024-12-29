@testable import WebVTTParser
import Parsing
import CustomDump
import XCTest

final class SettingsParsingTests: XCTestCase {
    func test_parse_settings_align() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("settings-align.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(timing: 0...1, settings: []) {
                plain("text0")
            }
            cue(timing: 0...1, settings: [.align(.start)]) {
                plain("text1")
            }
            cue(timing: 0...1, settings: [.align(.center)]) {
                plain("text2")
            }
            cue(timing: 0...1, settings: [.align(.end)]) {
                plain("text3")
            }
            cue(timing: 0...1, settings: [.align(.left)]) {
                plain("text4")
            }
            cue(timing: 0...1, settings: [.align(.right)]) {
                plain("text5")
            }
            cue(timing: 0...1, settings: [.align(.start), .align(.end)]) {
                plain("text6")
            }
            cue(timing: 0...1, settings: [.align(.end), .align(.center)]) {
                plain("text7")
            }
            cue(timing: 0...1, settings: [.align(.end), .align(.center)]) {
                plain("text8")
            }
            cue(timing: 0...1, settings: [.align(.end), .align(.center)]) {
                plain("text9")
            }
        }
        expectNoDifference(vtt, expected)
    }

    func test_parse_settings_line() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("settings-line.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(timing: 0...1, settings: [.lineNumber(-1)]) {
                plain("valid")
            }
            cue(timing: 0...1, settings: [.lineNumber(0)]) {
                plain("valid")
            }
            cue(timing: 0...1, settings: [.lineNumber(-0)]) {
                plain("valid")
            }
            cue(timing: 0...1, settings: [.lineNumber(1)]) {
                plain("valid")
            }
            cue(timing: 0...1, settings: [.lineNumber(100)]) {
                plain("valid")
            }
            cue(timing: 0...1, settings: [.lineNumber(101)]) {
                plain("valid")
            }
            cue(timing: 0...1, settings: [.lineNumber(65536)]) {
                plain("valid")
            }
            cue(timing: 0...1, settings: [.lineNumber(4294967296)]) {
                plain("valid")
            }
            cue(timing: 0...1, settings: [.linePercentage(65536)]) {
                plain("valid")
            }
            cue(timing: 0...1, settings: [.linePercentage(4294967296)]) {
                plain("valid")
            }
            cue(timing: 0...1, settings: [.linePercentage(-0)]) {
                plain("valid")
            }
            cue(timing: 0...1, settings: [.linePercentage(101)]) {
                plain("valid")
            }
            cue(timing: 0...1, settings: [.linePercentage(0)]) {
                plain("valid")
            }
            cue(timing: 0...1, settings: [.linePercentage(0)]) {
                plain("valid")
            }
            cue(timing: 0...1, settings: [.linePercentage(100)]) {
                plain("valid")
            }
            cue(timing: 0...1, settings: [.linePercentage(100), .align(.start)]) {
                plain("valid")
            }
        }
        expectNoDifference(vtt, expected)
    }

    func test_parse_settings_vertical() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("settings-vertical.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(timing: 0...1, settings: []) {
                plain("text0")
            }
            cue(timing: 0...1, settings: [.vertical(.lr)]) {
                plain("text1")
            }
            cue(timing: 0...1, settings: [.vertical(.rl)]) {
                plain("text2")
            }
            cue(timing: 0...1, settings: [.vertical(.rl), .vertical(.lr)]) {
                plain("text3")
            }
            unknown("""
            00:00:00.000 --> 00:00:01.000 vertical:
            invalid4
            """)
            unknown("""
            00:00:00.000 --> 00:00:01.000 vertical:RL
            invalid5
            """)
            cue(timing: 0...1, settings: [.vertical(.rl)]) {
                plain("invalid6")
            }
            unknown("""
            00:00:00.000 --> 00:00:01.000 vertical:vertical-rl
            invalid7
            """)
        }
        expectNoDifference(vtt, expected)
    }

    func test_parse_settings_size() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("settings-size.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(timing: 0...1, settings: []) {
                plain("text0")
            }
            unknown("""
            00:00:00.000 --> 00:00:01.000 size:1xx size:2%
            text1
            """)
            cue(timing: 0...1, settings: [.size(0)]) {
                plain("text2")
            }
            cue(timing: 0...1, settings: [.size(0)]) {
                plain("text3")
            }
            cue(timing: 0...1, settings: [.size(50), .size(100)]) {
                plain("text4")
            }
            cue(timing: 0...1, settings: [.size(50), .size(101)]) {
                plain("text5")
            }
            unknown("""
            00:00:00.000 --> 00:00:01.000 size:1.5%
            invalid6
            """)
            unknown("""
            00:00:00.000 --> 00:00:01.000 size:
            invalid7
            """)
            unknown("""
            00:00:00.000 --> 00:00:01.000 size:x
            invalid8
            """)
            unknown("""
            00:00:00.000 --> 00:00:01.000 size:%
            invalid9
            """)
            unknown("""
            00:00:00.000 --> 00:00:01.000 size:%%
            invalid10
            """)
            unknown("""
            00:00:00.000 --> 00:00:01.000 size:1%%
            invalid11
            """)
            unknown("""
            00:00:00.000 --> 00:00:01.000 size:1%x
            invalid12
            """)
            cue(timing: 0...1, settings: [.size(101)]) {
                plain("invalid13")
            }
            cue(timing: 0...1, settings: [.size(-3)]) {
                plain("invalid14")
            }
            cue(timing: 0...1, settings: [.size(200)]) {
                plain("invalid15")
            }
        }
        expectNoDifference(vtt, expected)
    }

    func test_parse_settings_region() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("settings-region.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            region {
                WebVTT.RegionSetting.id("foo")
            }
            region {
                WebVTT.RegionSetting.id("bar")
            }
            region {
                WebVTT.RegionSetting.id("foo")
            }
            region {
                WebVTT.RegionSetting.widthPercentage(10)
            }
            cue(timing: 0...1, settings: [.region("foo")]) {
                plain("text0")
            }
            cue(timing: 0...1, settings: [.region("bar")]) {
                plain("text1")
            }
            cue(timing: 0...1, settings: [.region("foo"), .region("bar")]) {
                plain("text2")
            }
            cue(timing: 0...1, settings: [.region("invalid")]) {
                plain("text3")
            }
            cue(timing: 0...1, settings: [.region("invalid"), .region("foo")]) {
                plain("text4")
            }
            cue(timing: 0...1, settings: [.region("")]) {
                plain("invalid5")
            }
            cue(timing: 0...1, settings: [.region("")]) {
                plain("invalid6")
            }
            cue(timing: 0...1, settings: [.region("foo")]) {
                plain("invalid7")
            }
            cue(timing: 0...1, settings: [.region("foo")]) {
                plain("invalid8")
            }
        }
        expectNoDifference(vtt, expected)
    }

    func test_parse_settings_multiple() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("settings-multiple.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(identifier: "id0", timing: 0...1, settings: [
                .align(.start),
                .linePercentage(1),
                .vertical(.lr),
                .size(50),
                .position(25)
            ]) {
                plain("text0")
            }
            cue(identifier: "id1", timing: 0...1, settings: [
                .align(.center),
                .lineNumber(1),
                .vertical(.rl),
                .size(0),
                .position(100)
            ]) {
                plain("text1")
            }
        }
        expectNoDifference(vtt, expected)
    }

    func test_parse_settings_position() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("settings-position.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(timing: 0...1, settings: [.position(1)]) {
                plain("text0")
            }
            cue(timing: 0...1, settings: [.position(100)]) {
                plain("text1")
            }
            cue(timing: 0...1, settings: [.position(-1)]) {
                plain("text2")
            }
            cue(timing: 0...1, settings: [.position(-12345)]) {
                plain("text3")
            }
            cue(timing: 0...1, settings: [.position(1)]) {
                plain("text4")
            }
            cue(timing: 0...1, settings: [.position(101)]) {
                plain("text5")
            }
            cue(timing: 0...1, settings: [.position(65536)]) {
                plain("text6")
            }
            cue(timing: 0...1, settings: [.position(4294967296)]) {
                plain("text7")
            }
        }
        expectNoDifference(vtt, expected)
    }
}
