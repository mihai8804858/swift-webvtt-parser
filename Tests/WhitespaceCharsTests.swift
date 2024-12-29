@testable import WebVTTParser
import Parsing
import CustomDump
import XCTest

final class WhitespaceCharsTests: XCTestCase {
    func test_parse_whitespace_chars() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("whitespace-chars.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(identifier: "spaces", timing: 0...1) {
                plain("   text0")
            }
            cue(identifier: "tabs", timing: 0...1) {
                plain("text1")
            }
            cue(identifier: "form feed", timing: 0...1) {
                plain("text2")
            }
            cue(identifier: "vertical tab", timing: 0...1) {
                plain("text3")
            }
        }
        expectNoDifference(vtt, expected)
    }
}
