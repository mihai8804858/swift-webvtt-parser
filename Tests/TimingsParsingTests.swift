@testable import WebVTTParser
import Parsing
import CustomDump
import XCTest

final class TimingsParsingTests: XCTestCase {
    func test_parse_timings_60() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("timings-60.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(timing: WebVTT.Timing(
                start: WebVTT.Time(hours: 0, minutes: 0, seconds: 60, milliseconds: 0),
                end: WebVTT.Time(hours: 0, minutes: 0, seconds: 1, milliseconds: 0)
            )) {
                plain("text0")
            }
            cue(timing: WebVTT.Timing(
                start: WebVTT.Time(hours: 0, minutes: 60, seconds: 0, milliseconds: 0),
                end: WebVTT.Time(hours: 0, minutes: 0, seconds: 1, milliseconds: 0)
            )) {
                plain("text1")
            }
            cue(timing: WebVTT.Timing(
                start: WebVTT.Time(hours: 0, minutes: 0, seconds: 0, milliseconds: 0),
                end: WebVTT.Time(hours: 0, minutes: 0, seconds: 60, milliseconds: 0)
            )) {
                plain("text2")
            }
            cue(timing: WebVTT.Timing(
                start: WebVTT.Time(hours: 0, minutes: 0, seconds: 0, milliseconds: 0),
                end: WebVTT.Time(hours: 0, minutes: 60, seconds: 0, milliseconds: 0)
            )) {
                plain("text3")
            }
            cue(timing: WebVTT.Timing(
                start: WebVTT.Time(hours: 0, minutes: 0, seconds: 0, milliseconds: 0),
                end: WebVTT.Time(hours: 60, minutes: 0, seconds: 1, milliseconds: 0)
            )) {
                plain("text4")
            }
            cue(timing: WebVTT.Timing(
                start: WebVTT.Time(hours: 60, minutes: 0, seconds: 0, milliseconds: 0),
                end: WebVTT.Time(hours: 60, minutes: 0, seconds: 1, milliseconds: 0)
            )) {
                plain("text5")
            }
        }
        expectNoDifference(vtt, expected)
    }

    func test_parse_timings_eof() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("timings-eof.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            unknown("00:00:00.000 -->")
        }
        expectNoDifference(vtt, expected)
    }

    func test_parse_timings_garbage() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("timings-garbage.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            unknown("x00:00:00.000 --> 00:00:01.000\ninvalid")
            unknown("0x0:00:00.000 --> 00:00:01.000\ninvalid")
            unknown("00x:00:00.000 --> 00:00:01.000\ninvalid")
            unknown("00:x00:00.000 --> 00:00:01.000\ninvalid")
            unknown("00:0x0:00.000 --> 00:00:01.000\ninvalid")
            unknown("00:00x:00.000 --> 00:00:01.000\ninvalid")
            unknown("00:00:x00.000 --> 00:00:01.000\ninvalid")
            unknown("00:00:0x0.000 --> 00:00:01.000\ninvalid")
            unknown("00:00:00x.000 --> 00:00:01.000\ninvalid")
            unknown("00:00:00.x000 --> 00:00:01.000\ninvalid")
            unknown("00:00:00.0x00 --> 00:00:01.000\ninvalid")
            unknown("00:00:00.00x0 --> 00:00:01.000\ninvalid")
            unknown("00:00:00.000x --> 00:00:01.000\ninvalid")
            unknown("00:00:00.000 x--> 00:00:01.000\ninvalid")
            unknown("00:00:00.000 -x-> 00:00:01.000\ninvalid")
            unknown("00:00:00.000 --x> 00:00:01.000\ninvalid")
            unknown("00:00:00.000 -->x 00:00:01.000\ninvalid")
            unknown("00:00:00.000 --> x00:00:01.000\ninvalid")
            unknown("00:00:00.000 --> 0x0:00:01.000\ninvalid")
            unknown("00:00:00.000 --> 00x:00:01.000\ninvalid")
            unknown("00:00:00.000 --> 00:x00:01.000\ninvalid")
            unknown("00:00:00.000 --> 00:0x0:01.000\ninvalid")
            unknown("00:00:00.000 --> 00:00x:01.000\ninvalid")
            unknown("00:00:00.000 --> 00:00:x01.000\ninvalid")
            unknown("00:00:00.000 --> 00:00:0x1.000\ninvalid")
            unknown("00:00:00.000 --> 00:00:01x.000\ninvalid")
            unknown("00:00:00.000 --> 00:00:01.x000\ninvalid")
            unknown("00:00:00.000 --> 00:00:01.0x00\ninvalid")
            unknown("00:00:00.000 --> 00:00:01.00x0\ninvalid")
            unknown("x0:00:00.000 --> 00:00:01.000\ninvalid")
            unknown("0x:00:00.000 --> 00:00:01.000\ninvalid")
            unknown("00x00:00.000 --> 00:00:01.000\ninvalid")
            unknown("00:x0:00.000 --> 00:00:01.000\ninvalid")
            unknown("00:0x:00.000 --> 00:00:01.000\ninvalid")
            unknown("00:00x00.000 --> 00:00:01.000\ninvalid")
            unknown("00:00:x0.000 --> 00:00:01.000\ninvalid")
            unknown("00:00:0x.000 --> 00:00:01.000\ninvalid")
            unknown("00:00:00x000 --> 00:00:01.000\ninvalid")
            unknown("00:00:00.x00 --> 00:00:01.000\ninvalid")
            unknown("00:00:00.0x0 --> 00:00:01.000\ninvalid")
            unknown("00:00:00.00x --> 00:00:01.000\ninvalid")
            unknown("00:00:00.000x--> 00:00:01.000\ninvalid")
            unknown("00:00:00.000 x-> 00:00:01.000\ninvalid")
            unknown("00:00:00.000 -x> 00:00:01.000\ninvalid")
            unknown("00:00:00.000 --x 00:00:01.000\ninvalid")
            unknown("00:00:00.000 -->x00:00:01.000\ninvalid")
            unknown("00:00:00.000 --> x0:00:01.000\ninvalid")
            unknown("00:00:00.000 --> 0x:00:01.000\ninvalid")
            unknown("00:00:00.000 --> 00x00:01.000\ninvalid")
            unknown("00:00:00.000 --> 00:x0:01.000\ninvalid")
            unknown("00:00:00.000 --> 00:0x:01.000\ninvalid")
            unknown("00:00:00.000 --> 00:00x01.000\ninvalid")
            unknown("00:00:00.000 --> 00:00:x1.000\ninvalid")
            unknown("00:00:00.000 --> 00:00:0x.000\ninvalid")
            unknown("00:00:00.000 --> 00:00:01x000\ninvalid")
            unknown("00:00:00.000 --> 00:00:01.x00\ninvalid")
            unknown("00:00:00.000 --> 00:00:01.0x0\ninvalid")
            unknown("00:00:00.000 --> 00:00:01.00x\ninvalid")
            unknown("00.00:00.000 --> 00:00:01.000\ninvalid")
            unknown("00:00.00.000 --> 00:00:01.000\ninvalid")
            unknown("00:00:00:000 --> 00:00:01.000\ninvalid")
            unknown("00:00.00:000 --> 00:00:01.000\ninvalid")
            unknown("00:00:00,000 --> 00:00:01,000\ninvalid")

        }
        expectNoDifference(vtt, expected)
    }

    func test_parse_timings_negative() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("timings-negative.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(timing: WebVTT.Timing(
                start: WebVTT.Time(hours: 0, minutes: 0, seconds: 0, milliseconds: 0),
                end: WebVTT.Time(hours: 0, minutes: 0, seconds: 0, milliseconds: 0)
            )) {
                plain("text0")
            }
            cue(timing: WebVTT.Timing(
                start: WebVTT.Time(hours: 0, minutes: 0, seconds: 1, milliseconds: 0),
                end: WebVTT.Time(hours: 0, minutes: 0, seconds: 0, milliseconds: 999)
            )) {
                plain("text1")
            }
            cue(timing: WebVTT.Timing(
                start: WebVTT.Time(hours: 0, minutes: 1, seconds: 0, milliseconds: 0),
                end: WebVTT.Time(hours: 0, minutes: 0, seconds: 59, milliseconds: 999)
            )) {
                plain("text2")
            }
            cue(timing: WebVTT.Timing(
                start: WebVTT.Time(hours: 1, minutes: 0, seconds: 0, milliseconds: 0),
                end: WebVTT.Time(hours: 0, minutes: 59, seconds: 59, milliseconds: 999)
            )) {
                plain("text3")
            }
        }
        expectNoDifference(vtt, expected)
    }

    func test_parse_timings_omitted_hours() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("timings-omitted-hours.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(timing: WebVTT.Timing(
                start: WebVTT.Time(hours: 0, minutes: 0, seconds: 0, milliseconds: 0),
                end: WebVTT.Time(hours: 0, minutes: 0, seconds: 1, milliseconds: 0)
            )) {
                plain("text0")
            }
            cue(timing: WebVTT.Timing(
                start: WebVTT.Time(hours: 0, minutes: 0, seconds: 0, milliseconds: 0),
                end: WebVTT.Time(hours: 0, minutes: 0, seconds: 1, milliseconds: 0)
            )) {
                plain("text1")
            }
            cue(timing: WebVTT.Timing(
                start: WebVTT.Time(hours: 0, minutes: 0, seconds: 0, milliseconds: 0),
                end: WebVTT.Time(hours: 0, minutes: 0, seconds: 1, milliseconds: 0)
            )) {
                plain("text2")
            }
        }
        expectNoDifference(vtt, expected)
    }

    func test_parse_timings_too_long() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("timings-too-long.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(timing: 0...1) {
                plain("text0")
            }
            unknown("00::00:00.000 --> 00:00:01.000\ninvalid")
            cue(timing: 0...1) {
                plain("text1")
            }
            unknown("00:00::00.000 --> 00:00:01.000\ninvalid")
            cue(timing: 0...1) {
                plain("text2")
            }
            unknown("00:00:00..000 --> 00:00:01.000\ninvalid")
            cue(timing: 0...1) {
                plain("text3")
            }
            cue(timing: 0...1) {
                plain("text4")
            }
            cue(timing: 0...1) {
                plain("text5")
            }
            unknown("00::00.000 --> 00:01.000\ninvalid")
            cue(timing: 0...1) {
                plain("text6")
            }
            unknown("00:00..000 --> 00:01.000\ninvalid")
            cue(timing: 0...1) {
                plain("text7")
            }
            cue(timing: 0...1) {
                plain("text8")
            }
            cue(timing: 0...1) {
                plain("text9")
            }
        }
        expectNoDifference(vtt, expected)
    }

    func test_parse_timings_too_short() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("timings-too-short.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(timing: 0...1) {
                plain("text0")
            }
            cue(timing: 0...1) {
                plain("text1")
            }
            cue(timing: 0...1) {
                plain("text2")
            }
            cue(timing: 0...1) {
                plain("text3")
            }
            cue(timing: 0...1) {
                plain("text4")
            }
            unknown("00:00:00000 --> 00:00:01.000\ninvalid")
            cue(timing: 0...1) {
                plain("text5")
            }
            cue(timing: 0...1) {
                plain("text6")
            }
            unknown("00:00:00. --> 00:00:01.000\ninvalid")
            unknown("00:00:00 --> 00:00:01.000\ninvalid")
            unknown("00:00:0 --> 00:00:01.000\ninvalid")
            unknown("00:00: --> 00:00:01.000\ninvalid")
            unknown("00:00 --> 00:00:01.000\ninvalid")
            unknown("00:0 --> 00:00:01.000\ninvalid")
            unknown("00: --> 00:00:01.000\ninvalid")
            unknown("00 --> 00:00:01.000\ninvalid")
            unknown("0 --> 00:00:01.000\ninvalid")
            unknown(" --> 00:00:01.000\ninvalid")
            cue(timing: 0...1) {
                plain("text7")
            }
            unknown("0000.000 --> 00:01.000\ninvalid")
            cue(timing: 0...1) {
                plain("text8")
            }
            unknown("00:00000 --> 00:01.000\ninvalid")
            cue(timing: 0...1) {
                plain("text9")
            }
            cue(timing: 0...1) {
                plain("text10")
            }
            unknown("00:00. --> 00:01.000\ninvalid")
            unknown("0:00. --> 00:01.000\ninvalid")
            unknown(":00. --> 00:01.000\ninvalid")
            unknown("00. --> 00:01.000\ninvalid")
            unknown("0. --> 00:01.000\ninvalid")
            unknown(". --> 00:01.000\ninvalid")
            cue(timing: 0...1) {
                plain("text11")
            }
            cue(timing: 0...1) {
                plain("text12")
            }
        }
        expectNoDifference(vtt, expected)
    }
}
