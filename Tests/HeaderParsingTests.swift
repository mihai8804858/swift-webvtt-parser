@testable import WebVTTParser
import Parsing
import CustomDump
import Testing

struct HeaderParsingTests {
    @Test func parseHeaderGarbage() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("header-garbage.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            cue(timing: 0...1) {
                plain("text")
            }
        }
        expectNoDifference(vtt, expected)
    }

    @Test func parseHeaderSpace() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("header-space.vtt")
        #expect(throws: (any Error).self) { try parser.parse(contents) }
    }

    @Test func parseHeaderTab() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("header-tab.vtt")
        #expect(throws: (any Error).self) { try parser.parse(contents) }
    }

    @Test func parseHeaderTimings() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("header-timings.vtt")
        #expect(throws: (any Error).self) { try parser.parse(contents) }
    }
}
