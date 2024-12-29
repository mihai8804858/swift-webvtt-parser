@testable import WebVTTParser
import Parsing
import CustomDump
import XCTest

final class StylesheetsParsingTests: XCTestCase {
    func test_parse_stylesheets() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("stylesheets.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            style("""
            ::cue(#foo) {
                width: 20px;
            } /*
            NOTE hello
            00:00:00.000 -- > 00:00:01.000
            */
            .foo {
                width: 19px;
            }
            .bar {
                width: 18px;
            }
            """)
            cue(identifier: "foo", timing: 0...1) {
                plain("text")
            }
            style("""
            ::cue(::bar) {
                width: 18px;
            }
            """)
            cue(identifier: "bar", timing: 0...1) {
                plain("text")
            }
        }
        expectNoDifference(vtt, expected)
    }
}
