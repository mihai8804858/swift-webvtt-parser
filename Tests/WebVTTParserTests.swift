@testable import WebVTTParser
import Parsing
import CustomDump
import XCTest

final class WebVTTParserTests: XCTestCase {
    func test_parse() throws {
        let content = ""
        let expected = WebVTT()
        let parser = WebVTTParser()
        let vtt = try parser.parse(content)
        XCTAssertNoDifference(vtt, expected)
    }

    func test_print() throws {
        let vtt = WebVTT()
        let content = try WebVTTParser().print(vtt)
        XCTAssertNoDifference(content, "")
    }
}
