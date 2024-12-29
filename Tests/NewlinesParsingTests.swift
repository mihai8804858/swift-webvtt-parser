@testable import WebVTTParser
import Parsing
import CustomDump
import XCTest

final class NewlinesParsingTests: XCTestCase {
    func test_parse_newlines() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("newlines.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(identifier: "cr", timing: 0...1) {
                plain("text0")
            }
            cue(identifier: "lf", timing: 0...1) {
                plain("text1")
            }
            cue(identifier: "crlf", timing: 0...1) {
                plain("text2")
            }
            cue(identifier: "lfcr", timing: 0...1) {
                plain("text3")
            }
        }
        expectNoDifference(vtt, expected)
    }
}
