// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum LaunchScreen: StoryboardType {
    internal static let storyboardName = "LaunchScreen"

    internal static let initialScene = InitialSceneType<UIKit.UIViewController>(storyboard: LaunchScreen.self)
  }
  internal enum Main: StoryboardType {
    internal static let storyboardName = "Main"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Main.self)

    internal static let chatDetailViewController = SceneType<TLoC_Teams.ChatDetailViewController>(storyboard: Main.self, identifier: "ChatDetailViewController")

    internal static let chatOverviewViewController = SceneType<TLoC_Teams.ChatOverviewViewController>(storyboard: Main.self, identifier: "ChatOverviewViewController")

    internal static let chatViewController = SceneType<TLoC_Teams.ChatViewController>(storyboard: Main.self, identifier: "ChatViewController")

    internal static let createEventViewController = SceneType<TLoC_Teams.CreateEventViewController>(storyboard: Main.self, identifier: "CreateEventViewController")

    internal static let eventDetailViewController = SceneType<TLoC_Teams.EventDetailViewController>(storyboard: Main.self, identifier: "EventDetailViewController")

    internal static let eventViewController = SceneType<TLoC_Teams.EventViewController>(storyboard: Main.self, identifier: "EventViewController")

    internal static let gameListViewController = SceneType<TLoC_Teams.GameListViewController>(storyboard: Main.self, identifier: "GameListViewController")

    internal static let inputViewController = SceneType<TLoC_Teams.InputViewController>(storyboard: Main.self, identifier: "InputViewController")

    internal static let locationViewController = SceneType<TLoC_Teams.LocationViewController>(storyboard: Main.self, identifier: "LocationViewController")

    internal static let loginNavigationController = SceneType<UIKit.UINavigationController>(storyboard: Main.self, identifier: "LoginNavigationController")

    internal static let loginViewController = SceneType<TLoC_Teams.LoginViewController>(storyboard: Main.self, identifier: "LoginViewController")

    internal static let settingsViewController = SceneType<TLoC_Teams.SettingsViewController>(storyboard: Main.self, identifier: "SettingsViewController")

    internal static let tabBarController = SceneType<TLoC_Teams.TabBarViewController>(storyboard: Main.self, identifier: "TabBarController")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: Bundle(for: BundleToken.self))
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

private final class BundleToken {}
