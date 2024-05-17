@testable import WebVTTParser
import Parsing
import CustomDump
import XCTest

final class EntitiesParsingTests: XCTestCase {
    func test_parse_entities() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("entities.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(timing: 0...1) {
                plain("&")
            }
            cue(timing: 1...2) {
                plain("&amp")
            }
            cue(timing: 2...3) {
                plain("&")
            }
            cue(timing: 3...4) {
                plain("&")
            }
            cue(timing: 4...5) {
                plain("<")
            }
            cue(timing: 5...6) {
                plain(">")
            }
            cue(timing: 6...7) {
                plain("a\u{200e}b")
            }
            cue(timing: 7...8) {
                plain("a\u{200f}b")
            }
            cue(timing: 8...9) {
                plain("\"")
            }
            cue(timing: 9...10) {
                plain("\u{00a0}")
            }
            cue(timing: 10...11) {
                plain("©")
            }
            cue(timing: 11...12) {
                plain("&&")
            }
            cue(timing: 12...13) {
                plain("&1")
            }
            cue(timing: 13...14) {
                plain("&1;")
            }
            cue(timing: 14...15) {
                plain("&<")
            }
            cue(timing: 15...16) {
                plain("&<c")
            }
            cue(timing: 16...17) {
                plain(" ")
            }
            cue(timing: 17...18) {
                plain(" ")
            }
            cue(timing: 18...19) {
                plain("&;")
            }
            cue(timing: 19...20) {
                plain("∲")
            }
            cue(timing: 20...21) {
                plain("⫅̸")
            }
            cue(timing: 21...22) {
                plain("∉")
            }
            cue(timing: 22...23) {
                plain("¬")
            }
        }
        XCTAssertNoDifference(vtt, expected)
    }
}
