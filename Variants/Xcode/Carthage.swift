#!/usr/local/bin/swift-sh
import AnyLint // @Flinesoft == wip/cg_template-system

try Lint.reportResultsToFile(arguments: CommandLine.arguments) {
    // MARK: - Variables
    let cartfile: Regex = #"^Cartfile$"#

    // MARK: - Checks
    // MARK: CartfileEmptyLines
    try Lint.checkFileContents(
        checkInfo: "CartfileEmptyLines: Make sure that each dependency is separated from the neighbors by an empty line.",
        regex: #"(#[^\n]+\n)?(git[^\n]+)\n([^\n]+)"#,
        matchingExamples: [
            """
            github "Flinesoft/HandySwift" ~> 3.1
            github "Flinesoft/HandyUIKit" ~> 1.9
            """,
            """
            # Handy Swift features that didn't make it into the Swift standard library.
            github "Flinesoft/HandySwift" ~> 3.1
            # Handy UI features that should have been part of UIKit in the first place.
            github "Flinesoft/HandyUIKit" ~> 1.9
            """
        ],
        nonMatchingExamples: [
            """
            github "Flinesoft/HandySwift" ~> 3.1
            github "Flinesoft/HandyUIKit" ~> 1.9
            """,
            """
            # Handy Swift features that didn't make it into the Swift standard library.
            github "Flinesoft/HandySwift" ~> 3.1
            # Handy UI features that should have been part of UIKit in the first place.
            github "Flinesoft/HandyUIKit" ~> 1.9
            """
        ],
        includeFilters: [cartfile],
        autoCorrectReplacement: "$1$2\n\n$3",
        autoCorrectExamples: [
            [
                "before": """
                    github "Flinesoft/HandySwift" ~> 3.1
                    github "Flinesoft/HandyUIKit" ~> 1.9
                    """,
                "after": """
                    github "Flinesoft/HandySwift" ~> 3.1
                    github "Flinesoft/HandyUIKit" ~> 1.9
                    """
            ],
            [
                "before": """
                    # Handy Swift features that didn't make it into the Swift standard library.
                    github "Flinesoft/HandySwift" ~> 3.1
                    # Handy UI features that should have been part of UIKit in the first place.
                    github "Flinesoft/HandyUIKit" ~> 1.9
                    """,
                "after": """
                    # Handy Swift features that didn't make it into the Swift standard library.
                    github "Flinesoft/HandySwift" ~> 3.1
                    # Handy UI features that should have been part of UIKit in the first place.
                    github "Flinesoft/HandyUIKit" ~> 1.9
                    """
            ],
        ]
    )

    // MARK: CartfileComments
    try Lint.checkFileContents(
        checkInfo: "CartfileComments: Make sure that each dependency has their GitHub tagline as a comment above it.",
        regex: #"(?<=\n\n)git[^\n]+"#,
        matchingExamples: [
            """
            github "Flinesoft/HandySwift" ~> 3.1
            github "Flinesoft/HandyUIKit" ~> 1.9
            """
        ],
        nonMatchingExamples: [
            """
            # Handy Swift features that didn't make it into the Swift standard library.
            github "Flinesoft/HandySwift" ~> 3.1
            # Handy UI features that should have been part of UIKit in the first place.
            github "Flinesoft/HandyUIKit" ~> 1.9
            """
        ],
        includeFilters: [cartfile]
    )

    // MARK: CartfileVersionSpecifier
    try Lint.checkFileContents(
        checkInfo: "CartfileVersionSpecifier: Make sure to allow for minor upgrades for all dependencies.",
        regex: #"(github "\w+\/\w+") *~> *(\d+\.\d+)\.\d+"#,
        matchingExamples: [#"github "Flinesoft/HandySwift" ~> 3.2.0"#],
        nonMatchingExamples: [#"github "Flinesoft/HandySwift" ~> 3.2"#, #"github "aromajoin/material-showcase-ios" ~> 0.7.1"#],
        includeFilters: [cartfile],
        autoCorrectReplacement: "$1 ~> $2",
        autoCorrectExamples: [
            ["before": #"github "Flinesoft/HandySwift" ~> 3.2.0"#, "after": #"github "Flinesoft/HandySwift" ~> 3.2"#],
        ]
    )
}
