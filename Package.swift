// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "StoreScrollIndicator",
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
