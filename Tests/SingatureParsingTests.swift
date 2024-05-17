@testable import WebVTTParser
import Parsing
import CustomDump
import XCTest

final class SingatureParsingTests: XCTestCase {
    func test_parse_bom() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("signature-bom.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            note("This is a note")
        }
        XCTAssertNoDifference(vtt, expected)
    }

    func test_parse_no_newlines() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("signature-no-newline.vtt")
        XCTAssertThrowsError(try parser.parse(contents))
    }

    func test_parse_space_no_newlines() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("signature-space-no-newline.vtt")
        XCTAssertThrowsError(try parser.parse(contents))
    }

    func test_parse_tab_no_newlines() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("signature-tab-no-newline.vtt")
        XCTAssertThrowsError(try parser.parse(contents))
    }

    func test_parse_space() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("signature-space.vtt")
        XCTAssertThrowsError(try parser.parse(contents))
    }

    func test_parse_tab() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("signature-tab.vtt")
        XCTAssertThrowsError(try parser.parse(contents))
    }

    func test_parse_timings() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("signature-timings.vtt")
        XCTAssertThrowsError(try parser.parse(contents))
    }
}
