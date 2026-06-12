import AppKit
import CoreGraphics

struct DisplayInfo: Identifiable, Hashable {
    let id: CGDirectDisplayID
    let name: String
    let width: Int
    let height: Int
    let isMain: Bool

    static func from(_ screen: NSScreen) -> DisplayInfo? {
        guard let displayID = screen.displayID else { return nil }
        let frame = screen.frame
        return DisplayInfo(
            id: displayID,
            name: screen.localizedName,
            width: Int(frame.width),
            height: Int(frame.height),
            isMain: screen == NSScreen.main
        )
    }
}

extension NSScreen {
    var displayID: CGDirectDisplayID? {
        deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID
    }

    static func screen(for displayID: CGDirectDisplayID) -> NSScreen? {
        screens.first { $0.displayID == displayID }
    }
}
