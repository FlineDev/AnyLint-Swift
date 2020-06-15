#!/usr/local/bin/swift-sh
import AnyLint // @Flinesoft == wip/cg_template-system

try Lint.reportResultsToFile(arguments: CommandLine.arguments) {
    // MARK: - Variables
    let objectiveCFiles: Regex = #"^(App|Tests|UITests)/Sources/.*\.(h|m|mm)$"#

    // MARK: - Checks
    // MARK: BeforeClosingBracesWhitespace
    try Lint.checkFileContents(
        checkInfo: "BeforeClosingBracesWhitespace: Closing curly braces in ObjC should never be preceded by empty newlines.",
        regex: #"(?:\n *)+\n( *)\}"#,
        matchingExamples: ["\n        \n    }"],
        nonMatchingExamples: ["\n        return 5;\n    }"],
        includeFilters: [objectiveCFiles],
        autoCorrectReplacement: "\n$1}",
        autoCorrectExamples: [
            ["before": "\n        \n    }", "after": "\n    }"],
            ["before": "\n        \n        \n    }", "after": "\n    }"],
        ]
    )

    // MARK: ElsePrefixWhitespace
    try Lint.checkFileContents(
        checkInfo: "ElsePrefixWhitespace: Else cases in ObjC should precede with a single whitespace like so: `} else {`.",
        regex: #"\}else|\} {2,}else"#,
        matchingExamples: ["}else {", "}  else {"],
        includeFilters: [objectiveCFiles],
        autoCorrectReplacement: "} else",
        autoCorrectExamples: [
            ["before": "}else {", "after": "} else {"],
            ["before": "}  else {", "after": "} else {"],
        ]
    )

    // MARK: ElseSuffixWhitespace
    try Lint.checkFileContents(
        checkInfo: "ElseSuffixWhitespace: Else cases in ObjC should be followed with a whitespace like so: `} else {`.",
        regex: #"\} else\{|\} else\s{2,}\{|\} else\n\{"#,
        matchingExamples: ["} else{", "} else  {", "} else\n{", "} else\n  {"],
        includeFilters: [objectiveCFiles],
        autoCorrectReplacement: "} else {",
        autoCorrectExamples: [
            ["before": "} else  {", "after": "} else {"],
            ["before": "} else{", "after": "} else {"],
        ]
    )

    // MARK: EmptyTodo
    try Lint.checkFileContents(
        checkInfo: "EmptyTodo: `// TODO:` comments should not be empty.",
        regex: #"// TODO: ?(\[[\d\-_a-z]+\])? *\n"#,
        matchingExamples: ["// TODO:\n", "// TODO: [2020-03-19]\n", "// TODO: [cg_2020-03-19]  \n"],
        nonMatchingExamples: ["// TODO: refactor", "// TODO: not yet implemented", "// TODO: [cg_2020-03-19] not yet implemented"],
        includeFilters: [swiftFiles]
    )

    // MARK: FunctionWhitespace
    try Lint.checkFileContents(
        checkInfo: "FunctionWhitespace: Whitespaces on ObjC functions should be of structure: `- (type)function:(Type *)param {`",
        regex: #"^([\+\-]) *\( *([^)]+) *\) *([^\n\{]+[^ \n])\s*\{\s*\n( *\S+)"#,
        matchingExamples: ["- (void)viewDidLoad\n{\n    blubb", "-(void)viewDidLoad {\n    blubb"],
        includeFilters: [objectiveCFiles],
        autoCorrectReplacement: "$1 ($2)$3 {\n$4",
        autoCorrectExamples: [
            ["before": "- (void)viewDidLoad\n{\n    blubb", "after": "- (void)viewDidLoad {\n    blubb"],
            ["before": "-(void)viewDidLoad {\n    blubb", "after": "- (void)viewDidLoad {\n    blubb"],
        ]
    )

    // MARK: IfConditionWhitespace
    try Lint.checkFileContents(
        checkInfo: "IfConditionWhitespace: If conditions in ObjC should be surrounded with a whitespace like so: `if (condition) {`.",
        regex: #" if\s*\(\s*([^)]+[^\s])\s*\)\s*\{"#,
        matchingExamples: ["} else if (blubb == blubb){", "} else if(blubb == blubb) {", "} else if ( blubb == blubb) {"],
        includeFilters: [objectiveCFiles],
        autoCorrectReplacement: " if ($1) {",
        autoCorrectExamples: [
            ["before": "} else if (blubb == blubb){", "after": "} else if (blubb == blubb) {"],
            ["before": "} else if(blubb == blubb) {", "after": "} else if (blubb == blubb) {"],
            ["before": "} else if ( blubb == blubb) {", "after": "} else if (blubb == blubb) {"],
        ]
    )

    // MARK: MultilineWhitespaces
    try Lint.checkFileContents(
        checkInfo: "MultilineWhitespaces: Restrict whitespace lines to a maximum of one.",
        regex: #"\n( *\n){2,}"#,
        matchingExamples: ["}\n    \n     \n\nclass", "}\n\n\nvoid"],
        nonMatchingExamples: ["}\n    \n    class"],
        includeFilters: [objectiveCFiles],
        autoCorrectReplacement: "\n\n",
        autoCorrectExamples: [
            ["before": "}\n    \n     \n\n    class", "after": "}\n\n    class"],
            ["before": "}\n\n\nvoid", "after": "}\n\nvoid"],
        ]
    )

    // MARK: TernaryOperatorWhitespace
    try Lint.checkFileContents(
        checkInfo: "TernaryOperatorWhitespace: There should be a single whitespace around each separator.",
        regex: #"(.*\S)\s*\?\s*(\w+)\s*:\s*(.*)"#,
        nonMatchingExamples: ["viewCtrl?.call(param: 50)"],
        includeFilters: [swiftFiles],
        autoCorrectReplacement: #"$1 ? $2 : $3"#,
        autoCorrectExamples: [
            ["before": "constant = singleUserMode() ? 0:28", "after": "constant = singleUserMode() ? 0 : 28"],
            ["before": "constant = singleUserMode() ? 0 :28", "after": "constant = singleUserMode() ? 0 : 28"],
            ["before": "constant = singleUserMode() ?0 : 28", "after": "constant = singleUserMode() ? 0 : 28"],
            ["before": "constant = singleUserMode() ? 0: 28", "after": "constant = singleUserMode() ? 0 : 28"],
        ]
    )

    // MARK: TrailingWhitespaces
    try Lint.checkFileContents(
        checkInfo: "TrailingWhitespaces: There should be no trailing whitespaces in lines.",
        regex: #"([\S\n]) +\n"#,
        matchingExamples: ["}  \n", "\n    \n"],
        nonMatchingExamples: ["}\n    void"],
        includeFilters: [objectiveCFiles],
        autoCorrectReplacement: "$1\n",
        autoCorrectExamples: [
            ["before": "}  \n", "after": "}\n"],
            ["before": "\n    \n", "after": "\n\n"],
        ]
    )
}
