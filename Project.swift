import ProjectDescription

let swiftLintScript: TargetScript = .pre(
  script: """
  #!/bin/bash
  set -e

  # 1) Mint (предпочтительно, если используете Mint и зафиксированную версию):
  if command -v mint >/dev/null 2>&1; then
    echo "Running SwiftLint via Mint…"
    mint run realm/SwiftLint swiftlint --quiet
    exit 0
  fi

  # 2) Homebrew / системный swiftlint:
  if command -v swiftlint >/dev/null 2>&1; then
    echo "Running SwiftLint…"
    swiftlint --quiet
    exit 0
  fi

  echo "SwiftLint not installed. Skipping lint."
  exit 0
  """,
  name: "SwiftLint",
  basedOnDependencyAnalysis: false
)

let project = Project(
    name: "Documentor",
    organizationName: "Documentor",
    settings: .settings(configurations: [
        .debug(name: "Debug",   xcconfig: .relativeToRoot("Tuist/Configs/Debug.xcconfig")),
        .release(name: "Release", xcconfig: .relativeToRoot("Tuist/Configs/Release.xcconfig"))
    ]),
    targets: [
        .target(
            name: "Documentor",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.Documentor",
            infoPlist: .extendingDefault(
                with: [
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ]
                            ]
                        ]
                    ],
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "UIBackgroundModes": ["remote-notification"]
                ]
            ),
            sources: ["Documentor/Sources/**"],
            resources: ["Documentor/Resources/**"],
            scripts: [swiftLintScript],
            dependencies: [.external(name: "SnapKit")]
        ),
        .target(
            name: "DocumentorTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.DocumentorTests",
            infoPlist: .default,
            sources: ["Documentor/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Documentor")]
        ),
    ],
    schemes: [
        // Основная схема для локальной разработки
        Scheme.scheme(
            name: "Documentor",
            shared: true,
            buildAction: .buildAction(targets: ["Documentor"]),
            testAction: .targets(
                [TestableTarget(stringLiteral: "DocumentorTests")],
              configuration: "Debug"
            ),
            runAction: .runAction(configuration: "Debug", executable: "Documentor"),
            archiveAction: .archiveAction(configuration: "Release"),
            profileAction: .profileAction(configuration: "Release"),
            analyzeAction: .analyzeAction(configuration: "Debug")
          ),

        // Схема под CI: build + tests в Debug
        Scheme.scheme(
            name: "Documentor-CI",
            shared: true,
            buildAction: .buildAction(targets: ["Documentor"]),
            testAction: .targets(
              [
                TestableTarget(stringLiteral: "DocumentorTests"),
                TestableTarget(stringLiteral: "DocumentorUITests")
              ],
              configuration: "Debug"
            ),
            runAction: .runAction(configuration: "Debug", executable: "Documentor"),
            archiveAction: .archiveAction(configuration: "Release"),
            profileAction: .profileAction(configuration: "Release"),
            analyzeAction: .analyzeAction(configuration: "Debug")
          ),

          // Схема для ручного прогона в Release (без тестов)
        Scheme.scheme(
            name: "Documentor-Release",
            shared: true,
            buildAction: .buildAction(targets: ["Documentor"]),
            runAction: .runAction(configuration: "Release", executable: "Documentor"),
            archiveAction: .archiveAction(configuration: "Release"),
            profileAction: .profileAction(configuration: "Release"),
            analyzeAction: .analyzeAction(configuration: "Release")
          )
    ]
)
