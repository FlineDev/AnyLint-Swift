#!/usr/local/bin/swift-sh
import AnyLint // @Flinesoft == wip/cg_template-system

try Lint.reportResultsToFile(arguments: CommandLine.arguments) {
    // MARK: - Variables
    let changelogFile: Regex = #"^CHANGELOG\.md$"#
    let readmeFile: Regex = #"^README\.md$"#

    // MARK: - Checks
    // MARK: ChangelogExistence
    try Lint.checkFilePaths(
        checkInfo: "ChangelogExistence: Each project should have a CHANGELOG.md file, tracking the changes within a project over time.",
        regex: changelogFile,
        matchingExamples: ["CHANGELOG.md"],
        nonMatchingExamples: ["CHANGELOG.markdown", "Changelog.md", "ChangeLog.md"],
        violateIfNoMatchesFound: true
    )

    // MARK: ChangelogEntryStructure
    try Lint.checkFileContents(
        checkInfo: "ChangelogEntryStructure: Changelog entries should have exactly the structure (including whitespaces) like documented in top of the file.",
        regex: #"^[-–]\s*([^\s][^\n]+[^\s])\s*\n\s*((?:Task|Issue|PR|Author)\S.*\))[^)\n]*\n"#,
        matchingExamples: [
            "- Summary.  \nTask: [#50](https://github.com/Flinesoft/AnyLint/pull/50) | PR: [#100](https://github.com/Flinesoft/AnyLint/pull/100) | Author: [Cihat Gündüz](https://github.com/Jeehut)\n",
            "- Summary.  \n    Task: [#50](https://github.com/Flinesoft/AnyLint/pull/100) | PR: [#100](https://github.com/Flinesoft/AnyLint/pull/100) | Author: [Cihat Gündüz](https://github.com/Jeehut)  ,  \n",
        ],
        nonMatchingExamples: ["- None.\n##"],
        includeFilters: [changelogFile],
        autoCorrectReplacement: "- $1  \n  $2\n",
        autoCorrectExamples: [
            [
                "before": "- Summary. \nTask: [#50](https://github.com/Flinesoft/AnyLint/pull/50) | PR: [#100](https://github.com/Flinesoft/AnyLint/pull/100) | Author: [Cihat Gündüz](https://github.com/Jeehut).  \n",
                "after": "- Summary.  \n  Task: [#50](https://github.com/Flinesoft/AnyLint/pull/50) | PR: [#100](https://github.com/Flinesoft/AnyLint/pull/100) | Author: [Cihat Gündüz](https://github.com/Jeehut)\n"
            ],
        ]
    )

    // MARK: ReadmeExistence
    try Lint.checkFilePaths(
        checkInfo: "ReadmeExistence: Each project should have a README.md file, explaining how to use or contribute to the project.",
        regex: readmeFile,
        matchingExamples: ["README.md"],
        nonMatchingExamples: ["README.markdown", "Readme.md", "ReadMe.md"],
        violateIfNoMatchesFound: true
    )
}
