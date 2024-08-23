@testable import WebVTTParser
import Parsing
import CustomDump
import XCTest

final class BOMParserTests: XCTestCase {
    func test_parse_bom() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("bom.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(timing: 0...1) {
                plain("\ntext0")
            }
        }
        XCTAssertNoDifference(vtt, expected)
    }
}
