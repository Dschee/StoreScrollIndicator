// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "StoreScrollIndicator",
    platforms: [.iOS("10.0")],
    products: [
        .library(name: "StoreScrollIndicator", targets: ["StoreScrollIndicator"])
    ],
    targets: [
        .target(
            name: "StoreScrollIndicator",
            path: "StoreScrollIndicator",
            sources: ["ScrollIndicatorView.swift", "StackedIndicatorView.swift"]
        )
    ]
)
