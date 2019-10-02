// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSColor
  internal typealias Color = NSColor
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIColor
  internal typealias Color = UIColor
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Colors

// swiftlint:disable identifier_name line_length type_body_length
internal struct ColorName {
  internal let rgbaValue: UInt32
  internal var color: Color { return Color(named: self) }

  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#2b5518"></span>
  /// Alpha: 100% <br/> (0x2b5518ff)
  internal static let darkGreen = ColorName(rgbaValue: 0x2b5518ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#838383"></span>
  /// Alpha: 100% <br/> (0x838383ff)
  internal static let gray = ColorName(rgbaValue: 0x838383ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#44c224"></span>
  /// Alpha: 100% <br/> (0x44c224ff)
  internal static let green = ColorName(rgbaValue: 0x44c224ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#c0c0c0"></span>
  /// Alpha: 100% <br/> (0xc0c0c0ff)
  internal static let lightGray = ColorName(rgbaValue: 0xc0c0c0ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#6ede2a"></span>
  /// Alpha: 100% <br/> (0x6ede2aff)
  internal static let lightGreen = ColorName(rgbaValue: 0x6ede2aff)
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

// swiftlint:disable operator_usage_whitespace
internal extension Color {
  convenience init(rgbaValue: UInt32) {
    let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
    let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
    let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
    let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
// swiftlint:enable operator_usage_whitespace

internal extension Color {
  convenience init(named color: ColorName) {
    self.init(rgbaValue: color.rgbaValue)
  }
}
