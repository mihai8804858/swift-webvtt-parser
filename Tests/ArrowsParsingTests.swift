@testable import WebVTTParser
import Parsing
import CustomDump
import XCTest

final class ArrowsParsingTests: XCTestCase {
    func test_parse_arrows() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("arrows.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(identifier: "-->", timing: 0...1) {
                plain("text0")
            }
            cue(identifier: "foo-->", timing: 0...1) {
                plain("text1")
            }
            cue(identifier: "-->foo", timing: 0...1) {
                plain("text2")
            }
            cue(identifier: "--->", timing: 0...1) {
                plain("text3")
            }
            cue(identifier: "-->-->", timing: 0...1) {
                plain("text4")
            }
            cue(timing: 0...1) {
                plain("text5")
            }
            unknown("00:00:00.000 -a -->")
            unknown("00:00:00.000 --a -->")
            unknown("00:00:00.000 - -->")
            unknown("00:00:00.000 -- -->")
        }
        expectNoDifference(vtt, expected)
    }
}
