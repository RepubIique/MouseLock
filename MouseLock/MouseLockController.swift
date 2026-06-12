import AppKit
import ApplicationServices
import Carbon
import Combine
import Foundation

@MainActor
final class MouseLockController: ObservableObject {
    private enum Keys {
        static let edgeWrapEnabled = "edgeWrapEnabled"
    }

    @Published private(set) var displays: [DisplayInfo] = []
    @Published var selectedDisplayID: CGDirectDisplayID?
    @Published private(set) var isLocked = false
    @Published private(set) var accessibilityGranted = false
    @Published var edgeWrapEnabled = UserDefaults.standard.bool(forKey: Keys.edgeWrapEnabled) {
        didSet {
            UserDefaults.standard.set(edgeWrapEnabled, forKey: Keys.edgeWrapEnabled)
            lockService.edgeWrapEnabled = edgeWrapEnabled
        }
    }

    private let lockService = CursorLockService()
    private let hotKeyManager = HotKeyManager()
    private var screenChangeObserver: NSObjectProtocol?
    private var appActiveObserver: NSObjectProtocol?

    init() {
        lockService.edgeWrapEnabled = edgeWrapEnabled
        refreshDisplays()
        refreshAccessibilityStatus()
        registerHotKey()
        observeScreenChanges()
        observeAppActivation()
    }

    deinit {
        if let screenChangeObserver {
            NotificationCenter.default.removeObserver(screenChangeObserver)
        }
        if let appActiveObserver {
            NotificationCenter.default.removeObserver(appActiveObserver)
        }
    }

    func refreshDisplays() {
        displays = NSScreen.screens.compactMap(DisplayInfo.from)

        if let selectedDisplayID,
           displays.contains(where: { $0.id == selectedDisplayID }) {
            return
        }

        if let main = displays.first(where: \.isMain) {
            selectedDisplayID = main.id
        } else {
            selectedDisplayID = displays.first?.id
        }
    }

    func refreshAccessibilityStatus() {
        accessibilityGranted = AXIsProcessTrusted()
    }

    func promptForAccessibility() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        _ = AXIsProcessTrustedWithOptions(options)
        refreshAccessibilityStatus()
    }

    func openAccessibilitySettings() {
        promptForAccessibility()
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
            NSWorkspace.shared.open(url)
        }
    }

    func toggleLock() {
        if isLocked {
            unlock()
        } else {
            lock()
        }
    }

    func lock() {
        refreshAccessibilityStatus()
        guard let selectedDisplayID else { return }

        lockService.lock(to: selectedDisplayID)
        isLocked = true
    }

    func unlock() {
        lockService.unlock()
        isLocked = false
    }

    private func registerHotKey() {
        // Control + Option + L
        let keyCode: UInt32 = 37
        let modifiers = UInt32(controlKey | optionKey)
        _ = hotKeyManager.register(keyCode: keyCode, modifiers: modifiers) { [weak self] in
            Task { @MainActor in
                self?.toggleLock()
            }
        }
    }

    private func observeScreenChanges() {
        screenChangeObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.refreshDisplays()
            }
        }
    }

    private func observeAppActivation() {
        appActiveObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.refreshAccessibilityStatus()
            }
        }
    }
}
