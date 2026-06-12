import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject private var controller: MouseLockController

    var body: some View {
        if !controller.accessibilityGranted {
            Text("Accessibility is optional. If locking fails, enable Mouse Lock in System Settings, then quit and reopen the app.")
                .font(.caption)
            Button("Open Accessibility Settings…") {
                controller.openAccessibilitySettings()
            }
            Divider()
        }

        Picker("Lock to display", selection: $controller.selectedDisplayID) {
            ForEach(controller.displays) { display in
                Text(display.label).tag(Optional(display.id))
            }
        }
        .disabled(controller.isLocked)

        Button(controller.isLocked ? "Unlock Mouse" : "Lock Mouse") {
            controller.toggleLock()
        }
        .keyboardShortcut("l", modifiers: [.control, .option])

        Text("Shortcut: ⌃⌥L")
            .font(.caption)
            .foregroundStyle(.secondary)

        Divider()

        Button("Refresh Displays") {
            controller.refreshDisplays()
        }

        Button("Quit Mouse Lock") {
            NSApplication.shared.terminate(nil)
        }
        .keyboardShortcut("q")
    }
}

private extension DisplayInfo {
    var label: String {
        let mainSuffix = isMain ? " (Main)" : ""
        return "\(name) — \(width)×\(height)\(mainSuffix)"
    }
}
