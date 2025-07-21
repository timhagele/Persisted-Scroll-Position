// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package (
    name: "Persisted Scroll Position" ,
		platforms:  [ .iOS ( .v14 )  , .macOS ( .v11 ) ] ,
    products: [ .library ( name: "Persisted Scroll Position" , targets: [ "Persisted Scroll Position" ] ) , ] ,
		
    targets: [
        .target (  name: "Persisted Scroll Position" ) ,
        .testTarget ( name: "Persisted Scroll PositionTests" , dependencies: [ "Persisted Scroll Position" ] ) ,
		] , swiftLanguageVersions: [ .v5 , .version ( "6" ) ]
)
