import SwiftUI

@main
struct MouseLockApp: App {
    @StateObject private var controller = MouseLockController()

    var body: some Scene {
        MenuBarExtra("Mouse Lock", systemImage: controller.isLocked ? "lock.display" : "display") {
            MenuBarView()
                .environmentObject(controller)
        }
        .menuBarExtraStyle(.menu)
    }
}
