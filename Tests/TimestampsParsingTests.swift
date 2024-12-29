@testable import WebVTTParser
import Parsing
import CustomDump
import XCTest

final class TimestampsParsingTests: XCTestCase {
    func test_parse_timestamps() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("timestamps.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(timing: 0...1) {
                plain("<0")
            }
            cue(timing: 1...2) {
                plain("<0.500")
            }
            cue(timing: 2...3) {
                plain("<0:00.500")
            }
            cue(timing: 3...4) {
                plain("<00:\000:00.500>")
            }
            cue(timing: 4...5) {
                plain("<00:00.500")
            }
            cue(timing: 5...6) {
                plain("<00:00:00.500")
            }
            cue(timing: 6...7) {
                plain("test")
                timestamp(interval: 0.5) {
                    plain("test")
                }
            }
            cue(timing: 7...8) {
                plain("test")
                timestamp(interval: 3600) {
                    plain("test")
                }
            }
            cue(timing: 8...9) {
                plain("test")
                timestamp(interval: 36000) {
                    plain("test")
                }
            }
            cue(timing: 9...10) {
                plain("test")
                timestamp(interval: 360000) {
                    plain("test")
                }
            }
        }
        expectNoDifference(vtt, expected)
    }
}
