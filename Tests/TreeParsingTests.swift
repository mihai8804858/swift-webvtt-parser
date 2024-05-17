@testable import WebVTTParser
import Parsing
import CustomDump
import XCTest

final class TreeParsingTests: XCTestCase {
    func test_parse_tree() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("tree.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(timing: 0...1) {
                plain("test")
            }
            cue(timing: 1...2) {
                plain("<ruby>test<rt>test")
            }
            cue(timing: 2...3) {
                plain("<ruby>test")
                rubyText {
                    plain("test")
                }
                plain("test")
            }
            cue(timing: 3...4) {
                ruby {
                    plain("test")
                    rubyText {
                        plain("test")
                    }
                }
                plain("test")
            }
            cue(timing: 4...5) {
                ruby {
                    plain("test<rt>test")
                }
                plain("test")
            }
            cue(timing: 5...6) {
                ruby {
                    plain("test")
                    rubyText {
                        plain("<b>test")
                    }
                }
                plain("test")
            }
            cue(timing: 6...7) {
                ruby {
                    plain("test<rt><b>test")
                }
                plain("test")
            }
            cue(timing: 7...8) {
                ruby {
                    plain("test")
                    rubyText {
                        plain("<b>test")
                    }
                }
                plain("</b>test")
            }
            cue(timing: 8...9) {
                ruby {
                    plain("test")
                    rubyText {
                        plain("<b>test")
                    }
                    plain("</b>")
                }
                plain("test")
            }
        }
        XCTAssertNoDifference(vtt, expected)
    }
}
