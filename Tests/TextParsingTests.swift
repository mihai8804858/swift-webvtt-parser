@testable import WebVTTParser
import Parsing
import CustomDump
import XCTest

final class TextParsingTests: XCTestCase {
    func test_parse_text() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("text.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(timing: 0...1) {
                plain("text")
            }
            cue(timing: 1...2) {
                plain("text1\ntext2")
            }
            cue(timing: 2...3) {
                plain("foo\0bar")
            }
            cue(timing: 3...4) {
                plain("✓")
            }
            cue(timing: 4...5) {
                plain("text1")
            }
            unknown("text2")
        }
        XCTAssertNoDifference(vtt, expected)
    }
}
