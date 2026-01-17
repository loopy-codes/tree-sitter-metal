# `tree-sitter-metal`

*An experimental Tree Sitter Grammar for Apple's Metal Shading Language.*

> [!NOTE]
> This project is not affiliated with Apple!

## Overview

Apple's Metal Shading Language allows developers to execute programs (kernels) --- and control the execution --- on Apple Silicon GPU hardware.
The language is an extension of C++, with features such as exceptions removed, and several type specifiers and attributes added to control execution flows.
Metal's specifics are described in a formal [specification](https://developer.apple.com/metal/Metal-Shading-Language-Specification.pdf).

Tree Sitter grammars require very little code *logic*; grammars are largely code as *data* in the form of a [`grammar.js`](/grammar.js) file.
This is where generative text models shine.
The repository was generated with the Tree Sitter CLI, and the content for the Metal grammar was generated with Claude models in the [Zed](https://zed.dev) editor.

Please file an [issue](https://github.com/loopy-codes/tree-sitter-metal/issues/new) to report missing or incorrect grammar content, or any other unexpected behaviors.
