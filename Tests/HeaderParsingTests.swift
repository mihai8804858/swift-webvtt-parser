@testable import WebVTTParser
import Parsing
import CustomDump
import XCTest

final class HeaderParsingTests: XCTestCase {
    func test_parse_header_garbage() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("header-garbage.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(timing: 0...1) {
                plain("text")
            }
        }
        XCTAssertNoDifference(vtt, expected)
    }

    func test_parse_header_space() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("header-space.vtt")
        XCTAssertThrowsError(try parser.parse(contents))
    }

    func test_parse_header_tab() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("header-tab.vtt")
        XCTAssertThrowsError(try parser.parse(contents))
    }

    func test_parse_header_timings() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("header-timings.vtt")
        XCTAssertThrowsError(try parser.parse(contents))
    }
}
