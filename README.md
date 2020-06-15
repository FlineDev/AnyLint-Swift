<p align="center">
    <a href="https://github.com/Flinesoft/AnyLint-Swift/actions?query=branch%3Amain">
        <img src="https://github.com/Flinesoft/AnyLint-Swift/workflows/CI/badge.svg"
            alt="CI">
    </a>
    <a href="https://github.com/Flinesoft/AnyLint-Swift/releases">
        <img src="https://img.shields.io/badge/Version-0.0.0-blue.svg"
             alt="Version: 0.0.0">
    </a>
    <a href="https://github.com/Flinesoft/AnyLint-Swift/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-MIT-lightgrey.svg"
             alt="License: MIT">
    </a>
    <br />
    <a href="https://paypal.me/Dschee/5EUR">
        <img src="https://img.shields.io/badge/PayPal-Donate-orange.svg"
             alt="PayPal: Donate">
    </a>
    <a href="https://github.com/sponsors/Jeehut">
        <img src="https://img.shields.io/badge/GitHub-Become a sponsor-orange.svg"
             alt="GitHub: Become a sponsor">
    </a>
    <a href="https://patreon.com/Jeehut">
        <img src="https://img.shields.io/badge/Patreon-Become a patron-orange.svg"
             alt="Patreon: Become a patron">
    </a>
</p>

<p align="center">
  <a href="#swift">Swift</a>
  • <a href="#xcode">Xcode</a>
  • <a href="#docs">Docs</a>
  • <a href="#donation">Donation</a>
  • <a href="https://github.com/Flinesoft/AnyLint-Swift/issues">Issues</a>
  • <a href="#license">License</a>
</p>

# AnyLint-Swift

The [AnyLint](https://github.com/Flinesoft/AnyLint) community-collected configurations project for the Swift community.

## Configurations

A configuration can be placed into an AnyLint configuration file like so:

```Swift
// MARK: Swift/Core
try Lint.runChecks(source: .github(repo: "Flinesoft/AnyLint-Swift", version: "main", variant: "Swift/Core"))
```

### Swift

If you are using Swift, you will probably want to use the `Swift/Core` configuration.

Other configurations might follow and will be more opinionated towards a specific programming style.

### Xcode

There is no `Core` configuration here yet.

* If you have `ObjectiveC` files in your project, use the `Xcode/ObjectiveC` variant.
* If you have a projects with localized Strings files, use the `Xcode/Strings` variant.
* If you are using the [Carthage](https://github.com/Carthage/Carthage) dependency manager, use the `Xcode/Carthage` variant.
* If you are using [SwiftGen](https://github.com/SwiftGen/SwiftGen) for accessing resources, use the `Xcode/SwiftGen` variant.

Other configurations might follow and will be more opinionated towards a specific programming style.

### Docs

If you want to document your project, you will probably want to use the `Docs/Core` configuration.

Other configurations might follow and will be more opinionated towards a specific documentation styles.

## Donation

AnyLint-Swift was brought to you by [Cihat Gündüz](https://github.com/Jeehut) in his free time. If you want to thank me and support the development of this project, please **make a small donation on [PayPal](https://paypal.me/Dschee/5EUR)**. In case you also like my other [open source contributions](https://github.com/Flinesoft) and [articles](https://medium.com/@Jeehut), please consider motivating me by **becoming a sponsor on [GitHub](https://github.com/sponsors/Jeehut)** or a **patron on [Patreon](https://www.patreon.com/Jeehut)**.

Thank you very much for any donation, it really helps out a lot! 💯

## Contributing

Contributions are welcome. Feel free to open an issue on GitHub with your ideas or implement an idea yourself and post a pull request. If you want to contribute code, please try to follow the same syntax and semantic in your **commit messages** (see rationale [here](http://chris.beams.io/posts/git-commit/)). Also, please make sure to add an entry to the `CHANGELOG.md` file which explains your change.

## License

This library is released under the [MIT License](http://opensource.org/licenses/MIT). See LICENSE for details.
