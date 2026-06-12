import Carbon
import Foundation

final class HotKeyManager {
    typealias Handler = () -> Void

    private var hotKeyRef: EventHotKeyRef?
    private var eventHandlerRef: EventHandlerRef?
    private var handler: Handler?

    func register(keyCode: UInt32, modifiers: UInt32, handler: @escaping Handler) -> Bool {
        unregister()

        self.handler = handler

        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        let userData = Unmanaged.passUnretained(self).toOpaque()

        let installStatus = InstallEventHandler(
            GetApplicationEventTarget(),
            { _, event, userData -> OSStatus in
                guard let userData, let event else { return noErr }
                var hotKeyID = EventHotKeyID()
                let status = GetEventParameter(
                    event,
                    EventParamName(kEventParamDirectObject),
                    EventParamType(typeEventHotKeyID),
                    nil,
                    MemoryLayout<EventHotKeyID>.size,
                    nil,
                    &hotKeyID
                )
                guard status == noErr, hotKeyID.signature == hotKeySignature else { return noErr }

                let manager = Unmanaged<HotKeyManager>.fromOpaque(userData).takeUnretainedValue()
                DispatchQueue.main.async {
                    manager.handler?()
                }
                return noErr
            },
            1,
            &eventType,
            userData,
            &eventHandlerRef
        )

        guard installStatus == noErr else { return false }

        let hotKeyID = EventHotKeyID(signature: hotKeySignature, id: hotKeyIDValue)
        let registerStatus = RegisterEventHotKey(
            keyCode,
            modifiers,
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &hotKeyRef
        )

        return registerStatus == noErr
    }

    func unregister() {
        if let hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
            self.hotKeyRef = nil
        }
        if let eventHandlerRef {
            RemoveEventHandler(eventHandlerRef)
            self.eventHandlerRef = nil
        }
        handler = nil
    }

    deinit {
        unregister()
    }
}

private let hotKeySignature: OSType = 0x4D4C4F43 // "MLOC"
private let hotKeyIDValue: UInt32 = 1
