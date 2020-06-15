#!/usr/local/bin/swift-sh
import AnyLint // @Flinesoft == wip/cg_template-system

try Lint.reportResultsToFile(arguments: CommandLine.arguments) {
    // MARK: - Variables
    let swiftFiles: Regex = #"^(App|Tests|UITests)/Sources/.*\.swift$"#
    let generatedSwiftFiles: Regex = #".*/Generated/.*\.swift|.*/SwiftGen/.*\.swift"#

    // MARK: - Checks
    // MARK: DynamicColorReference
    try Lint.checkFileContents(
        checkInfo: "DynamicColorReference: Don't use dynamic color references – use SwiftGen & Color instead.",
        regex: #"UIColor\(\s*named:\s*\""#,
        matchingExamples: [#"UIColor(named: "primary")"#],
        nonMatchingExamples: ["Colors.primary.color"],
        includeFilters: [swiftFiles],
        excludeFilters: [generatedSwiftFiles]
    )

    // MARK: DynamicStoryboardReference
    try Lint.checkFileContents(
        checkInfo: "DynamicStoryboardReference: Don't use dynamic storyboard references – use SwiftGen & StoryboardScene instead.",
        regex: #"UIStoryboard\(\s*name:\s*\""#,
        matchingExamples: [#"UIStoryboard(name: "LoginViewController")"#],
        nonMatchingExamples: ["StoryboardScene.Login.loginViewController.instantiate()"],
        includeFilters: [swiftFiles],
        excludeFilters: [generatedSwiftFiles]
    )

    // MARK: DynamicStringReference
    try Lint.checkFileContents(
        checkInfo: "DynamicStringReference@warning: Don't use dynamic localization string references via code strings – use SwiftGen & L10n instead.",
        regex: #"NSLocalizedString\s*\("#,
        matchingExamples: [#"NSLocalizedString(@"Test", comment: "");"#, #"NSLocalizedString("Test", comment: nil)"#],
        includeFilters: [swiftFiles],
        excludeFilters: [generatedSwiftFiles]
    )
}
