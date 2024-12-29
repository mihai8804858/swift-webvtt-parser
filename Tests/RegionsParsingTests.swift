@testable import WebVTTParser
import Parsing
import CustomDump
import XCTest

final class RegionsParsingTests: XCTestCase {
    func test_parse_id() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("regions-id.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            note("No API for accessing region ids, so using lines to uniquely identify regions")
            region {
                WebVTT.RegionSetting.id("foo")
                WebVTT.RegionSetting.id("bar")
                WebVTT.RegionSetting.lines(1)
            }
            region {
                WebVTT.RegionSetting.id("bar")
                WebVTT.RegionSetting.id("foo")
                WebVTT.RegionSetting.lines(2)
            }
            region {
                WebVTT.RegionSetting.id("id")
                WebVTT.RegionSetting.id("foo")
                WebVTT.RegionSetting.id("bar")
                WebVTT.RegionSetting.lines(3)
            }
            region {
                WebVTT.RegionSetting.lines(4)
                WebVTT.RegionSetting.id("")
            }
            cue(timing: 0...1, settings: [.region("foo")]) {
                plain("valid")
            }
            cue(timing: 0...1, settings: [.region("bar")]) {
                plain("valid")
            }
            cue(timing: 0...1, settings: [.region("id")]) {
                plain("valid")
            }
            cue(timing: 0...1, settings: [.region("")]) {
                plain("\nvalid")
            }
        }
        expectNoDifference(vtt, expected)
    }

    func test_parse_lines() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("regions-lines.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            note("valid")
            region {
                WebVTT.RegionSetting.id("1")
                WebVTT.RegionSetting.lines(0)
            }
            region {
                WebVTT.RegionSetting.id("2")
                WebVTT.RegionSetting.lines(1)
            }
            region {
                WebVTT.RegionSetting.id("3")
                WebVTT.RegionSetting.lines(100)
            }
            region {
                WebVTT.RegionSetting.id("4")
                WebVTT.RegionSetting.lines(101)
            }
            region {
                WebVTT.RegionSetting.id("5")
                WebVTT.RegionSetting.lines(65536)
            }
            region {
                WebVTT.RegionSetting.id("6")
                WebVTT.RegionSetting.lines(4294967296)
            }
            region {
                WebVTT.RegionSetting.id("9")
                WebVTT.RegionSetting.lines(1)
                WebVTT.RegionSetting.lines(3)
                WebVTT.RegionSetting.lines(2)
            }
            region {
                WebVTT.RegionSetting.id("10")
                WebVTT.RegionSetting.lines(-0)
            }
            region {
                WebVTT.RegionSetting.id("12")
                WebVTT.RegionSetting.lines(-1)
            }
            region {
                WebVTT.RegionSetting.id("13")
                WebVTT.RegionSetting.lines(1)
            }
            cue(timing: 0...1, settings: [.region("1")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("2")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("3")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("4")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("5")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("6")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("7")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("8")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("9")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("10")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("11")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("12")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("13")]) {
                plain("text")
            }
        }
        expectNoDifference(vtt, expected)
    }

    func test_parse_old() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("regions-old.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            region {
                WebVTT.RegionSetting.id("foo")
                WebVTT.RegionSetting.widthPercentage(40)
                WebVTT.RegionSetting.lines(3)
                WebVTT.RegionSetting.anchor(WebVTT.RegionAnchor(xPercentage: 0, yPercentage: 100))
                WebVTT.RegionSetting.viewPortAnchor(WebVTT.RegionAnchor(xPercentage: 10, yPercentage: 90))
                WebVTT.RegionSetting.scroll(.up)
            }
            region {
                WebVTT.RegionSetting.id("bar")
                WebVTT.RegionSetting.widthPercentage(40)
                WebVTT.RegionSetting.lines(3)
                WebVTT.RegionSetting.anchor(WebVTT.RegionAnchor(xPercentage: 100, yPercentage: 100))
                WebVTT.RegionSetting.viewPortAnchor(WebVTT.RegionAnchor(xPercentage: 90, yPercentage: 90))
                WebVTT.RegionSetting.scroll(.up)
            }
            cue(timing: 0...1, settings: [.region("foo")]) {
                plain("text0")
            }
            cue(timing: 0...1, settings: [.region("bar")]) {
                plain("text1")
            }
        }
        expectNoDifference(vtt, expected)
    }

    func test_parse_scroll() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("regions-scroll.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            region {
                WebVTT.RegionSetting.id("0")
            }
            region {
                WebVTT.RegionSetting.id("1")
                WebVTT.RegionSetting.scroll(.up)
            }
            region {
                WebVTT.RegionSetting.id("2")
                WebVTT.RegionSetting.scroll(.up)
            }
            region {
                WebVTT.RegionSetting.id("3")
                WebVTT.RegionSetting.scroll(.down)
                WebVTT.RegionSetting.scroll(.left)
                WebVTT.RegionSetting.scroll(.right)
            }
            region {
                WebVTT.RegionSetting.id("4")
                WebVTT.RegionSetting.scroll(.up)
            }
            cue(timing: 0...1, settings: [.region("0")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("1")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("2")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("3")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("4")]) {
                plain("text")
            }
        }
        expectNoDifference(vtt, expected)
    }

    func test_parse_regionanchor() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("regions-regionanchor.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            note("valid")
            region {
                WebVTT.RegionSetting.id("0")
            }
            region {
                WebVTT.RegionSetting.id("1")
                WebVTT.RegionSetting.anchor(WebVTT.RegionAnchor(xPercentage: 0, yPercentage: 0))
            }
            region {
                WebVTT.RegionSetting.id("2")
                WebVTT.RegionSetting.anchor(WebVTT.RegionAnchor(xPercentage: 1, yPercentage: 1))
            }
            region {
                WebVTT.RegionSetting.id("3")
                WebVTT.RegionSetting.anchor(WebVTT.RegionAnchor(xPercentage: 100, yPercentage: 0))
            }
            region {
                WebVTT.RegionSetting.id("4")
                WebVTT.RegionSetting.anchor(WebVTT.RegionAnchor(xPercentage: 0, yPercentage: 100))
            }
            region {
                WebVTT.RegionSetting.id("5")
                WebVTT.RegionSetting.anchor(WebVTT.RegionAnchor(xPercentage: 100, yPercentage: 100))
            }
            region {
                WebVTT.RegionSetting.id("11")
                WebVTT.RegionSetting.anchor(WebVTT.RegionAnchor(xPercentage: 101, yPercentage: 1))
            }
            region {
                WebVTT.RegionSetting.id("12")
                WebVTT.RegionSetting.anchor(WebVTT.RegionAnchor(xPercentage: 1, yPercentage: 101))
            }
            region {
                WebVTT.RegionSetting.id("13")
                WebVTT.RegionSetting.anchor(WebVTT.RegionAnchor(xPercentage: -0, yPercentage: 0))
            }
            region {
                WebVTT.RegionSetting.id("14")
                WebVTT.RegionSetting.anchor(WebVTT.RegionAnchor(xPercentage: 0, yPercentage: -0))
            }
            region {
                WebVTT.RegionSetting.id("15")
                WebVTT.RegionSetting.anchor(WebVTT.RegionAnchor(xPercentage: 65536, yPercentage: 65536))
            }
            region {
                WebVTT.RegionSetting.id("16")
                WebVTT.RegionSetting.anchor(WebVTT.RegionAnchor(xPercentage: 4294967296, yPercentage: 4294967296))
            }
            region {
                WebVTT.RegionSetting.id("19")
                WebVTT.RegionSetting.anchor(WebVTT.RegionAnchor(xPercentage: 100, yPercentage: 100))
            }
            cue(timing: 0...1, settings: [.region("0")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("1")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("2")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("3")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("4")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("5")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("6")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("7")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("8")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("9")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("10")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("11")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("12")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("13")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("14")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("15")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("16")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("17")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("18")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("19")]) {
                plain("text")
            }
        }
        expectNoDifference(vtt, expected)
    }

    func test_parse_viewportanchor() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("regions-viewportanchor.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            note("valid")
            region {
                WebVTT.RegionSetting.id("0")
            }
            region {
                WebVTT.RegionSetting.id("1")
                WebVTT.RegionSetting.viewPortAnchor(WebVTT.RegionAnchor(xPercentage: 0, yPercentage: 0))
            }
            region {
                WebVTT.RegionSetting.id("2")
                WebVTT.RegionSetting.viewPortAnchor(WebVTT.RegionAnchor(xPercentage: 1, yPercentage: 1))
            }
            region {
                WebVTT.RegionSetting.id("3")
                WebVTT.RegionSetting.viewPortAnchor(WebVTT.RegionAnchor(xPercentage: 100, yPercentage: 0))
            }
            region {
                WebVTT.RegionSetting.id("4")
                WebVTT.RegionSetting.viewPortAnchor(WebVTT.RegionAnchor(xPercentage: 0, yPercentage: 100))
            }
            region {
                WebVTT.RegionSetting.id("5")
                WebVTT.RegionSetting.viewPortAnchor(WebVTT.RegionAnchor(xPercentage: 100, yPercentage: 100))
            }
            region {
                WebVTT.RegionSetting.id("11")
                WebVTT.RegionSetting.viewPortAnchor(WebVTT.RegionAnchor(xPercentage: 101, yPercentage: 1))
            }
            region {
                WebVTT.RegionSetting.id("12")
                WebVTT.RegionSetting.viewPortAnchor(WebVTT.RegionAnchor(xPercentage: 1, yPercentage: 101))
            }
            region {
                WebVTT.RegionSetting.id("13")
                WebVTT.RegionSetting.viewPortAnchor(WebVTT.RegionAnchor(xPercentage: -0, yPercentage: 0))
            }
            region {
                WebVTT.RegionSetting.id("14")
                WebVTT.RegionSetting.viewPortAnchor(WebVTT.RegionAnchor(xPercentage: 0, yPercentage: -0))
            }
            region {
                WebVTT.RegionSetting.id("15")
                WebVTT.RegionSetting.viewPortAnchor(WebVTT.RegionAnchor(xPercentage: 65536, yPercentage: 65536))
            }
            region {
                WebVTT.RegionSetting.id("16")
                WebVTT.RegionSetting.viewPortAnchor(WebVTT.RegionAnchor(
                    xPercentage: 4294967296,
                    yPercentage: 4294967296
                ))
            }
            region {
                WebVTT.RegionSetting.id("19")
                WebVTT.RegionSetting.viewPortAnchor(WebVTT.RegionAnchor(xPercentage: 100, yPercentage: 100))
            }
            cue(timing: 0...1, settings: [.region("0")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("1")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("2")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("3")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("4")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("5")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("6")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("7")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("8")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("9")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("10")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("11")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("12")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("13")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("14")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("15")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("16")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("17")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("18")]) {
                plain("text")
            }
            cue(timing: 0...1, settings: [.region("19")]) {
                plain("text")
            }
        }
        expectNoDifference(vtt, expected)
    }
}

// swiftlint:disable:this file_length
