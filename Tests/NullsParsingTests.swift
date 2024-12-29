@testable import WebVTTParser
import Parsing
import CustomDump
import XCTest

final class NullsParsingTests: XCTestCase {
    func test_parse_nulls() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("nulls.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT(header: WebVTT.Header(text: "\0(null in header)")) {
            cue(timing: 0...1) {
                plain("text0")
            }
            cue(identifier: "\0 (null in id)", timing: 0...1) {
                plain("text1")
            }
            cue(identifier: "� (null in cue data)", timing: 0...1) {
                plain("�text\02")
            }
            unknown("00:00:00.000 --> 00:00:01.000 align\0:end\ninvalid")
            unknown("00:00:00.000 --> 00:00:01.000 align:end\0\ninvalid")
            unknown("00:00:00.000 --> 00:00:01.000\0align:end\ninvalid")
            unknown("00:00:00.000 --> 00:00:01.000\0 align:end\ninvalid")
            unknown("00:00:00.000\0 --> 00:00:01.000\ninvalid")
            unknown("00:00:00.000 -->\000:00:01.000\ninvalid")
            unknown("\000:00:00.000 --> 00:00:01.000\ninvalid")
            unknown("0\00:00:00.000 --> 00:00:01.000\ninvalid")
            unknown("00\0:00:00.000 --> 00:00:01.000\ninvalid")
            unknown("00:\000:00.000 --> 00:00:01.000\ninvalid")
            unknown("00:0\00:00.000 --> 00:00:01.000\ninvalid")
            unknown("00:00\0:00.000 --> 00:00:01.000\ninvalid")
            unknown("00:00:\000.000 --> 00:00:01.000\ninvalid")
            unknown("00:00:0\00.000 --> 00:00:01.000\ninvalid")
            unknown("00:00:00\0.000 --> 00:00:01.000\ninvalid")
            unknown("00:00:00.\0000 --> 00:00:01.000\ninvalid")
            unknown("00:00:00.0\000 --> 00:00:01.000\ninvalid")
            unknown("00:00:00.00\00 --> 00:00:01.000\ninvalid")
            unknown("00:00:00.000\0 --> 00:00:01.000\ninvalid")
            unknown("00:00:00.000 \0--> 00:00:01.000\ninvalid")
            unknown("00:00:00.000 -\0-> 00:00:01.000\ninvalid")
            unknown("00:00:00.000 --\0> 00:00:01.000\ninvalid")
            unknown("00:00:00.000 -->\0 00:00:01.000\ninvalid")
            unknown("00:00:00.000 --> \000:00:01.000\ninvalid")
            unknown("00:00:00.000 --> 0\00:00:01.000\ninvalid")
            unknown("00:00:00.000 --> 00\0:00:01.000\ninvalid")
            unknown("00:00:00.000 --> 00:\000:01.000\ninvalid")
            unknown("00:00:00.000 --> 00:0\00:01.000\ninvalid")
            unknown("00:00:00.000 --> 00:00\0:01.000\ninvalid")
            unknown("00:00:00.000 --> 00:00:\001.000\ninvalid")
            unknown("00:00:00.000 --> 00:00:0\01.000\ninvalid")
            unknown("00:00:00.000 --> 00:00:01\0.000\ninvalid")
            unknown("00:00:00.000 --> 00:00:01.\0000\ninvalid")
            unknown("00:00:00.000 --> 00:00:01.0\000\ninvalid")
            unknown("00:00:00.000 --> 00:00:01.00\00\ninvalid")
            unknown("\00:00:00.000 --> 00:00:01.000\ninvalid")
            unknown("0\0:00:00.000 --> 00:00:01.000\ninvalid")
            unknown("00\000:00.000 --> 00:00:01.000\ninvalid")
            unknown("00:\00:00.000 --> 00:00:01.000\ninvalid")
            unknown("00:0\0:00.000 --> 00:00:01.000\ninvalid")
            unknown("00:00\000.000 --> 00:00:01.000\ninvalid")
            unknown("00:00:\00.000 --> 00:00:01.000\ninvalid")
            unknown("00:00:0\0.000 --> 00:00:01.000\ninvalid")
            unknown("00:00:00\0000 --> 00:00:01.000\ninvalid")
            unknown("00:00:00.\000 --> 00:00:01.000\ninvalid")
            unknown("00:00:00.0\00 --> 00:00:01.000\ninvalid")
            unknown("00:00:00.00\0 --> 00:00:01.000\ninvalid")
            unknown("00:00:00.000\0--> 00:00:01.000\ninvalid")
            unknown("00:00:00.000 \0-> 00:00:01.000\ninvalid")
            unknown("00:00:00.000 -\0> 00:00:01.000\ninvalid")
            unknown("00:00:00.000 --\0 00:00:01.000\ninvalid")
            unknown("00:00:00.000 -->\000:00:01.000\ninvalid")
            unknown("00:00:00.000 --> \00:00:01.000\ninvalid")
            unknown("00:00:00.000 --> 0\0:00:01.000\ninvalid")
            unknown("00:00:00.000 --> 00\000:01.000\ninvalid")
            unknown("00:00:00.000 --> 00:\00:01.000\ninvalid")
            unknown("00:00:00.000 --> 00:0\0:01.000\ninvalid")
            unknown("00:00:00.000 --> 00:00\001.000\ninvalid")
            unknown("00:00:00.000 --> 00:00:\01.000\ninvalid")
            unknown("00:00:00.000 --> 00:00:0\0.000\ninvalid")
            unknown("00:00:00.000 --> 00:00:01\0000\ninvalid")
            unknown("00:00:00.000 --> 00:00:01.\000\ninvalid")
            unknown("00:00:00.000 --> 00:00:01.0\00\ninvalid")
            unknown("00:00:00.000 --> 00:00:01.00\0\ninvalid")
        }
        expectNoDifference(vtt, expected)
    }
}
