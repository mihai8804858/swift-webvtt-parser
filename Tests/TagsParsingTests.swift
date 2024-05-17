@testable import WebVTTParser
import Parsing
import CustomDump
import XCTest

final class TagsParsingTests: XCTestCase {
    func test_parse_tags() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("tags.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(timing: 0...1) {
                plain("<")
            }
            cue(timing: 1...2) {
                plain("<<")
            }
            cue(timing: 2...3) {
                plain("<\t")
            }
            cue(timing: 3...4) {
                plain("<")
            }
            cue(timing: 4...5) {
                plain("< ")
            }
            cue(timing: 5...6) {
                plain("<.")
            }
            cue(timing: 6...7) {
                plain("<c.")
            }
            cue(timing: 7...8) {
                plain("</")
            }
            cue(timing: 8...9) {
                plain("<c></>x")
            }
            cue(timing: 9...10) {
                plain("<c></\nc>x")
            }
            cue(timing: 10...11) {
                plain("<c>test")
            }
            cue(timing: 11...12) {
                plain("a")
                styleClass(name: "d") {
                    plain("b")
                }
                plain("c")
            }
            cue(timing: 12...13) {
                plain("<i>test")
            }
            cue(timing: 13...14) {
                plain("a")
                italic(classes: ["d"]) {
                    plain("b")
                }
                plain("c")
            }
            cue(timing: 14...15) {
                plain("<b>test")
            }
            cue(timing: 15...16) {
                plain("a")
                bold(classes: ["d"]) {
                    plain("b")
                }
                plain("c")
            }
            cue(timing: 16...17) {
                plain("<u>test")
            }
            cue(timing: 17...18) {
                plain("a")
                underline(classes: ["d"]) {
                    plain("b")
                }
                plain("c")
            }
            cue(timing: 18...19) {
                plain("<ruby>test")
            }
            cue(timing: 19...20) {
                plain("a")
                ruby(classes: ["f"]) {
                    plain("b")
                    rubyText(classes: ["h"]) {
                        plain("c")
                    }
                    plain("d")
                }
                plain("e")
            }
            cue(timing: 20...21) {
                plain("<rt>test")
            }
            cue(timing: 21...22) {
                plain("<v>test")
            }
            cue(timing: 22...23) {
                voice(name: "a") {
                    plain("test")
                }
            }
            cue(timing: 23...24) {
                voice(name: "a b") {
                    plain("test")
                }
            }
            cue(timing: 24...25) {
                plain("<v.a>test")
            }
            cue(timing: 25...26) {
                plain("<v.a.b>test")
            }
            cue(timing: 26...27) {
                plain("a")
                voice(classes: ["d"], name: "e") {
                    plain("b")
                }
                plain("c")
            }
            cue(timing: 27...28) {
                plain("a")
                language(classes: ["d"], locale: "e") {
                    plain("b")
                }
                plain("c")
            }
        }
        XCTAssertNoDifference(vtt, expected)
    }
}
