#!/usr/local/bin/swift-sh
import AnyLint // @Flinesoft == wip/cg_template-system

try Lint.reportResultsToFile(arguments: CommandLine.arguments) {
    // MARK: - Variables
    let swiftFiles: Regex = #"^(App|Tests|UITests)/Sources/.*\.swift$"#

    // MARK: - Checks
    // MARK: EmptyMethodBody
    try Lint.checkFileContents(
        checkInfo: "EmptyMethodBody: Don't use whitespace or newlines for the body of empty methods.",
        regex: ["declaration": #"(init|func [^\(\s]+)\([^{}]*\)"#, "spacing": #"\s*"#, "body": #"\{\s+\}"#],
        matchingExamples: [
            "init() { }",
            "init() {\n\n}",
            "init(\n    x: Int,\n    y: Int\n) { }",
            "func foo2bar()  { }",
            "func foo2bar(x: Int, y: Int)  { }",
            "func foo2bar(\n    x: Int,\n    y: Int\n) {\n    \n}",
        ],
        nonMatchingExamples: ["init() { /* comment */ }", "init() {}", "func foo2bar() {}", "func foo2bar(x: Int, y: Int) {}"],
        includeFilters: [swiftFiles],
        autoCorrectReplacement: "$declaration {}",
        autoCorrectExamples: [
            ["before": "init()  { }", "after": "init() {}"],
            ["before": "init(x: Int, y: Int)  { }", "after": "init(x: Int, y: Int) {}"],
            ["before": "init()\n{\n    \n}", "after": "init() {}"],
            ["before": "init(\n    x: Int,\n    y: Int\n) {\n    \n}", "after": "init(\n    x: Int,\n    y: Int\n) {}"],
            ["before": "func foo2bar()  { }", "after": "func foo2bar() {}"],
            ["before": "func foo2bar(x: Int, y: Int)  { }", "after": "func foo2bar(x: Int, y: Int) {}"],
            ["before": "func foo2bar()\n{\n    \n}", "after": "func foo2bar() {}"],
            ["before": "func foo2bar(\n    x: Int,\n    y: Int\n) {\n    \n}", "after": "func foo2bar(\n    x: Int,\n    y: Int\n) {}"],
        ]
    )

    // MARK: EmptyTodo
    try Lint.checkFileContents(
        checkInfo: "EmptyTodo: `// TODO:` comments should not be empty.",
        regex: #"// TODO: ?(\[[\d\-_a-z]+\])? *\n"#,
        matchingExamples: ["// TODO:\n", "// TODO: [2020-03-19]\n", "// TODO: [cg_2020-03-19]  \n"],
        nonMatchingExamples: ["// TODO: refactor", "// TODO: not yet implemented", "// TODO: [cg_2020-03-19] not yet implemented"],
        includeFilters: [swiftFiles, objectiveCFiles]
    )

    // MARK: EmptyType
    try Lint.checkFileContents(
        checkInfo: "EmptyType: Don't keep empty types in code without commenting inside why they are needed.",
        regex: #"(class|protocol|struct|enum) [^\{]+\{\s*\}"#,
        matchingExamples: ["class Foo {}", "enum Constants {\n    \n}", "struct MyViewModel(x: Int, y: Int, closure: () -> Void) {}"],
        nonMatchingExamples: ["class Foo { /* TODO: not yet implemented */ }", "func foo() {}", "init() {}", "enum Bar { case x, y }"],
        includeFilters: [swiftFiles]
    )

    // MARK: IfAsGuard
    try Lint.checkFileContents(
        checkInfo: "IfAsGuard: Don't use an if statement to just return – use guard for such cases instead.",
        regex: #" +if [^\{]+\{\s*return\s*[^\}]*\}(?! *else)"#,
        matchingExamples: [" if x == 5 { return }", " if x == 5 {\n    return nil\n}", " if x == 5 { return 500 }", " if x == 5 { return do(x: 500, y: 200) }"],
        nonMatchingExamples: [" if x == 5 {\n    let y = 200\n    return y\n}", " if x == 5 { someMethod(x: 500, y: 200) }", " if x == 500 { return } else {"],
        includeFilters: [swiftFiles]
    )

    // MARK: MultilineIfStructure
    try Lint.checkFileContents(
        checkInfo: "MultilineIfStructure: Make sure multiline if conditions are all on their own lines, indented by four spaces.",
        regex: #"^( *)if\s*(.*,) *\n((?:.+, *\n)*) *(.*\S)\s*\{\s*"#,
        includeFilters: [swiftFiles],
        autoCorrectReplacement: "$1if\n$1    $2\n$3$1    $4\n$1{\n$1    $5",
        autoCorrectExamples: [
            [
                "before": """
                        if let employee = UserDefaults.standard.currentEmployee(),
                            let employeeName = employeeName,
                            let employeeEmail = employeeEmail,
                            let recipientEmail = recipientEmail {
                                dataExporterHelper.exportData(
                    """,
                "after": """
                        if
                            let employee = UserDefaults.standard.currentEmployee(),
                            let employeeName = employeeName,
                            let employeeEmail = employeeEmail,
                            let recipientEmail = recipientEmail
                        {
                            dataExporterHelper.exportData(
                    """
            ],
            [
                "before": """
                        if let employee = UserDefaults.standard.currentEmployee(),
                            let recipientEmail = recipientEmail
                        {
                            dataExporterHelper.exportData(
                    """,
                "after": """
                        if
                            let employee = UserDefaults.standard.currentEmployee(),
                            let recipientEmail = recipientEmail
                        {
                            dataExporterHelper.exportData(
                    """
            ],
        ]
    )

    // MARK: MultilineGuardEnd
    try Lint.checkFileContents(
        checkInfo: "MultilineGuardEnd: Always close a multiline guard via `else {` on a new line indented like the opening `guard`.",
        regex: #"guard\s*([^\n]*,\n)+([^\n]*\S *)else\s*\{"#,
        matchingExamples: [
            """
            guard
                let collection = viewModel.myCollection(),
                !collection.compactMap({ OtherType($0) }).isEmpty() else {
                return
            }
            """,
            """
            guard let collection = viewModel.myCollection(),
                !collection.compactMap({ OtherType($0) }).isEmpty() else {
                return
            }
            """
        ],
        nonMatchingExamples: [
            """
            guard
                let collection = viewModel.myCollection(),
                !collection.compactMap({ OtherType($0) }).isEmpty()
            else {
                return
            }
            """,
            """
            guard let collection = viewModel.myCollection(),
                !collection.compactMap({ OtherType($0) }).isEmpty()
            else {
                return
            }
            """
        ],
        includeFilters: [swiftFiles]
    )

    // MARK: MultilineGuardStart
    try Lint.checkFileContents(
        checkInfo: "MultilineGuardStart: Always start a multiline guard via `guard` then a line break and all expressions indented.",
        regex: #"guard([^\n]*,\s*\n)+[^\n]*\s*else\s*\{"#,
        matchingExamples: [
            """
            guard let collection = viewModel.myCollection(),
                !collection.compactMap({ OtherType($0) }).isEmpty()
            else {
                return
            }
            """,
            """
            guard let collection = viewModel.myCollection(),
                !collection.compactMap({ OtherType($0) }).isEmpty() else {
                return
            }
            """
        ],
        nonMatchingExamples: [
            """
            guard
                let collection = viewModel.myCollection(),
                !collection.compactMap({ OtherType($0) }).isEmpty()
            else {
                return
            }
            """,
            """
            guard
                let collection = viewModel.myCollection(),
                !collection.compactMap({ OtherType($0) }).isEmpty() else {
                return
            }
            """
        ],
        includeFilters: [swiftFiles]
    )

    // MARK: NilCoalescingOperator
    try Lint.checkFileContents(
        checkInfo: "NilCoalescingOperator: Prefer nil coalescing operator over `variable != nil ? variable! : alternative`.",
        regex: #"(\w+)\s*!=\s*nil\s*\?\s*\1!\s*:\s*(.*)"#,
        includeFilters: [swiftFiles],
        autoCorrectReplacement: "$1 ?? $2",
        autoCorrectExamples: [
            [
                "before": "    let message = errorMessage != nil ? errorMessage! : L10n.Global.Info.success\n",
                "after": "    let message = errorMessage ?? L10n.Global.Info.success\n",
            ],
            [
                "before": "param: callFunction(errorMessage != nil ? errorMessage! : L10n.Global.Info.success),\n",
                "after": "param: callFunction(errorMessage ?? L10n.Global.Info.success),\n",
            ],
        ]
    )

    // MARK: SingleLineGuard
    try Lint.checkFileContents(
        checkInfo: "SingleLineGuard: Use a single line guard for simple checks.",
        regex: #"guard\s*([^\{]{2,80})\s+else\s*\{\s*\n\s*(return[^\n]{0,40}|continue|fatalError\([^\n;]+\))\s*\}"#,
        matchingExamples: ["guard x else {\n  return\n}", "guard x else {\n  return 2 * x.squared(x: {15})\n}", #"guard x else {\#n  fatalError("some message: \(x)")\#n}"#],
        nonMatchingExamples: ["guard x else { return }", "guard x else { return 2 * x.squared(x: {15}) }", #"guard x else { fatalError("some message: \(x)") }"#],
        includeFilters: [swiftFiles],
        autoCorrectReplacement: #"guard $1 else { $2 }"#,
        autoCorrectExamples: [
            ["before": "guard let x = y?.x(z: 5) else {\n  return\n}", "after": "guard let x = y?.x(z: 5) else { return }"],
            ["before": "guard let x = y?.x(z: 5) else {\n  return 2 * x.squared(x: {15})\n}", "after": "guard let x = y?.x(z: 5) else { return 2 * x.squared(x: {15}) }"],
            ["before": "guard let x = y?.x(z: 5)\nelse {\n  return\n}", "after": "guard let x = y?.x(z: 5) else { return }"],
        ]
    )

    // MARK: SingletonDefaultPrivateInit
    try Lint.checkFileContents(
        checkInfo: "SingletonDefaultPrivateInit: Singletons with a `default` object (pseudo-singletons) should not declare init methods as private.",
        regex: #"class +(?<TYPE>\w+)(?:<[^\>]+>)? *\{.*static let `default`(?:: *\k<TYPE>)? *= *\k<TYPE>\(.*(?<=private) init\(\m"#,
        matchingExamples: ["class MySingleton {\n  static let `default` = MySingleton()\n\n  private init() {}\n"],
        nonMatchingExamples: ["class MySingleton {\n  static let `default` = MySingleton()\n\n  init() {}\n"],
        includeFilters: [swiftFiles]
    )

    // MARK: SingletonSharedFinal
    try Lint.checkFileContents(
        checkInfo: "SingletonSharedFinal: Singletons with a single object (`shared`) should be marked as final.",
        regex: #"(?<!final )class +(?<TYPE>\w+)(?:<[^\>]+>)? *\{.*static let shared(?:: *\k<TYPE>)? *= *\k<TYPE>\(\m"#,
        matchingExamples: ["\nclass MySingleton {\n  static let shared = MySingleton()\n\n  private init() {}\n"],
        nonMatchingExamples: ["\nfinal class MySingleton {\n  static let shared = MySingleton()\n\n  private init() {}\n"],
        includeFilters: [swiftFiles]
    )

    // MARK: SingletonSharedPrivateInit
    try Lint.checkFileContents(
        checkInfo: "SingletonSharedPrivateInit: Singletons with a single object (`shared`) should declare their init method(s) as private.",
        regex: #"class +(?<TYPE>\w+)(?:<[^\>]+>)? *\{.*static let shared(?:: *\k<TYPE>)? *= *\k<TYPE>\(.*(?<= |\t|public|internal) init\(\m"#,
        matchingExamples: ["\nfinal class MySingleton {\n  static let shared = MySingleton()\n\n  init() {}\n"],
        nonMatchingExamples: ["\nfinal class MySingleton {\n  static let shared = MySingleton()\n\n  private init() {}\n"],
        includeFilters: [swiftFiles]
    )

    // MARK: SingletonSharedSingleObject
    try Lint.checkFileContents(
        checkInfo: "SingletonSharedSingleObject: Singletons with a `shared` object (real Singletons) should not have other static let properties. Use `default` instead (if needed).",
        regex: #"class +(?<TYPE>\w+)(?:<[^\>]+>)? *\{.*(?:static let shared(?:: *\k<TYPE>)? *= *\k<TYPE>\(.*static let \w+(?:: *\k<TYPE>)? *= *\k<TYPE>\(|static let \w+(?:: *\k<TYPE>)? *= *\k<TYPE>\(.*static let shared(?:: *\k<TYPE>)? *= *\k<TYPE>\()\m"#,
        matchingExamples: ["\nfinal class MySingleton {\n  static let shared = MySingleton(url: productionUrl)\n  static let test = MySingleton(url: testUrl)"],
        nonMatchingExamples: ["\nfinal class MySingleton {\n  static let shared = MySingleton()\n\n  private init() {}\n"],
        includeFilters: [swiftFiles]
    )

    // MARK: SwitchAssociatedValueStyle
    try Lint.checkFileContents(
        checkInfo: "SwitchAssociatedValueStyle: Always put the `let` in front of case – even if only one associated value captured.",
        regex: #"case +[^\(][^\n]*(\(let |[^\)], let)"#,
        matchingExamples: ["case .addText(let text, let font, let textColor):", "case .addImage(let image)"],
        nonMatchingExamples: ["case let .addText(text, font, textColor):", "case let .addImage(image)"],
        includeFilters: [swiftFiles]
    )

    // MARK: TernaryOperatorWhitespace
    try Lint.checkFileContents(
        checkInfo: "TernaryOperatorWhitespace: There should be a single whitespace around each separator.",
        regex: #"(.*\S)\s*\?\s*(\w+)\s*:\s*(.*)"#,
        nonMatchingExamples: ["viewCtrl?.call(param: 50)"],
        includeFilters: [swiftFiles, objectiveCFiles],
        autoCorrectReplacement: #"$1 ? $2 : $3"#,
        autoCorrectExamples: [
            ["before": "constant = singleUserMode() ? 0:28", "after": "constant = singleUserMode() ? 0 : 28"],
            ["before": "constant = singleUserMode() ? 0 :28", "after": "constant = singleUserMode() ? 0 : 28"],
            ["before": "constant = singleUserMode() ?0 : 28", "after": "constant = singleUserMode() ? 0 : 28"],
            ["before": "constant = singleUserMode() ? 0: 28", "after": "constant = singleUserMode() ? 0 : 28"],
        ]
    )

    // MARK: TupleIndex
    try Lint.checkFileContents(
        checkInfo: "TupleIndex: Prevent unwrapping tuples by their index – define a typealias with named components instead.",
        regex: #"(\$\d|\w*[^%\d \(\[\{])\.\d"#,
        matchingExamples: ["$0.0", "$1.2", "tuple.0"],
        nonMatchingExamples: ["$0.key", "tuple.key", "%1$d of %2$d"],
        includeFilters: [swiftFiles]
    )

    // MARK: UnnecessaryNilAssignment
    try Lint.checkFileContents(
        checkInfo: "UnnecessaryNilAssignment: Don't assign nil as a value when defining an optional type – it's nil by default.",
        regex: #"(\svar +\w+\s*:\s*[^\n=]+\?)\s*=\s*nil"#,
        matchingExamples: ["class MyClass {\n  var count: Int? = nil\n", "class MyClass {\n  var dict: Dictionary<String, AnyObject>? = nil\n"],
        nonMatchingExamples: ["class MyClass {\n  let count: Int? = nil\n", "funct sum(dict: Dictionary<String, AnyObject>? = nil,"],
        includeFilters: [swiftFiles],
        autoCorrectReplacement: "$1",
        autoCorrectExamples: [
            ["before": "class MyClass {\n  var  count:Int?=nil\n", "after": "class MyClass {\n  var  count:Int?\n"],
            ["before": "class MyClass {\n  var dict: Dictionary<String, AnyObject>? = nil\n", "after": "class MyClass {\n  var dict: Dictionary<String, AnyObject>?\n"],
        ]
    )

    // MARK: ViewControllerVariableNaming
    try Lint.checkFileContents(
        checkInfo: "ViewControllerVariableNaming: Always name your view controller variables with the suffix `ViewCtrl` or just `viewCtrl`.",
        regex: #"(var|let) +(vc|viewcontroller|viewc|vcontroller)[ :][^\n=]*=\i"#,
        matchingExamples: ["let vc =", "var viewController =", "let viewc =", "let vcontroller =", "var vc: MyViewController =", "let viewController: MyViewController<T> = "],
        nonMatchingExamples: ["let viewCtrl =", "let viewCtrl: MyViewController =", "var myViewCtrl: MyViewController<T> ="],
        includeFilters: [swiftFiles]
    )
}
