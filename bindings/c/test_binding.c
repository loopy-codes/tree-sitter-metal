#include <assert.h>
#include <stdio.h>
#include <tree_sitter/api.h>

TSLanguage *tree_sitter_metal(void);

void test_can_load_grammar() {
    TSParser *parser = ts_parser_new();
    bool result = ts_parser_set_language(parser, tree_sitter_metal());
    assert(result && "Error loading Metal grammar");
    ts_parser_delete(parser);
    printf("✓ test_can_load_grammar passed\n");
}

int main() {
    printf("Running tree-sitter-metal C binding tests...\n\n");
    
    test_can_load_grammar();
    
    printf("\nAll tests passed! ✓\n");
    return 0;
}