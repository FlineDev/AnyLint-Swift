#!/usr/local/bin/swift-sh
import AnyLint // @Flinesoft == wip/cg_template-system

try Lint.reportResultsToFile(arguments: CommandLine.arguments) {
    // MARK: - Variables
    let stringsFiles: Regex = #"^App/.*/\w+\.lproj/\w+\.strings$"#

    // MARK: - Checks
    // MARK: LocalizationWhitespaces
    try Lint.checkFileContents(
        checkInfo: "LocalizationWhitespaces: Do not add whitespaces to the beginning or end of localized strings – use String interpolation instead.",
        regex: #""\s*=\s*" +| +";"#,
        matchingExamples: [#""my.example.key1" = "(Total: ";\n"#, #""my.example.key2" = "\n    Title: ";\n"#, #""my.example.key3" = "    Title:";\n"#],
        nonMatchingExamples: [#""my.example.key1" = "(Total:";\n"#, #""my.example.key2" = "\n    Title:";\n"#, #""my.example.key3" = "Title:";\n"#],
        includeFilters: [stringsFiles]
    )
}
