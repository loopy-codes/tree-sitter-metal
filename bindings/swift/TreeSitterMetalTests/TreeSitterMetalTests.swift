import Foundation
import SwiftTreeSitter
import TreeSitterMetal

func testCanLoadGrammar() {
    let parser = Parser()
    let language = Language(language: tree_sitter_metal())

    do {
        try parser.setLanguage(language)
        print("✓ Can load grammar - PASSED")
    } catch {
        print("✗ Can load grammar - FAILED: \(error)")
        exit(1)
    }
}

// Run tests
print("Running Tree-Sitter Metal Swift tests...")
print("")
testCanLoadGrammar()
print("")
print("All tests passed!")
