@testable import WebVTTParser
import Parsing
import CustomDump
import Testing

struct BOMParserTests {
    @Test func parseBom() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("bom.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(timing: 0...1) {
                plain("\ntext0")
            }
        }
        expectNoDifference(vtt, expected)
    }
}
