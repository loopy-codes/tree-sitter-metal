/**
 * @file A Tree Sitter Grammar for Apple's Metal Shading Language.
 * @author Joseph D. Carpinelli <joey@loopy.codes>
 * @license MIT
 */

/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

module.exports = grammar({
  name: "metal",

  rules: {
    // TODO: add the actual grammar rules
    source_file: $ => "hello"
  }
});
