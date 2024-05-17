import Foundation
import XCTest

func subtitleContents(_ fileName: String) throws -> String {
    let resourcesURL = try XCTUnwrap(Bundle.module.resourceURL)
    let subtitlesURL = resourcesURL.appendingPathComponent("Subtitles")
    let filePath = subtitlesURL.appendingPathComponent(fileName)
    let contents = try String(contentsOf: filePath)

    return contents
}
