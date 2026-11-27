@testable import WebVTTParser
import Parsing
import CustomDump
import Testing

struct SingatureParsingTests {
    @Test func parseBom() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("signature-bom.vtt")
        let vtt = try parser.parse(contents)
        let expected = WebVTT {
            note("This is a note")
        }
        expectNoDifference(vtt, expected)
    }

    @Test func parseNoNewlines() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("signature-no-newline.vtt")
        #expect(throws: (any Error).self) { try parser.parse(contents) }
    }

    @Test func parseSpaceNoNewlines() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("signature-space-no-newline.vtt")
        #expect(throws: (any Error).self) { try parser.parse(contents) }
    }

    @Test func parseTabNoNewlines() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("signature-tab-no-newline.vtt")
        #expect(throws: (any Error).self) { try parser.parse(contents) }
    }

    @Test func parseSpace() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("signature-space.vtt")
        #expect(throws: (any Error).self) { try parser.parse(contents) }
    }

    @Test func parseTab() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("signature-tab.vtt")
        #expect(throws: (any Error).self) { try parser.parse(contents) }
    }

    @Test func parseTimings() throws {
        let parser = WebVTTParser()
        let contents = try subtitleContents("signature-timings.vtt")
        #expect(throws: (any Error).self) { try parser.parse(contents) }
    }
}
