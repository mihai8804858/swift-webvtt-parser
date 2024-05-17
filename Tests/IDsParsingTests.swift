@testable import WebVTTParser
import Parsing
import CustomDump
import XCTest

final class IDsParsingTests: XCTestCase {
    func test_parse_ids() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("ids.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(identifier: " leading space", timing: 0...1) {
                plain("text0")
            }
            cue(identifier: "trailing space ", timing: 0...1) {
                plain("text1")
            }
            cue(identifier: "-- >", timing: 0...1) {
                plain("text2")
            }
            cue(identifier: "->", timing: 0...1) {
                plain("text3")
            }
            cue(identifier: " ", timing: 0...1) {
                plain("text4")
            }
        }
        XCTAssertNoDifference(vtt, expected)
    }
}
