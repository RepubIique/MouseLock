import CoreGraphics
import Foundation

final class CursorLockService {
    private var timer: Timer?
    private var targetDisplayID: CGDirectDisplayID?
    private(set) var isLocked = false

    /// Inset from display edges. Also keeps the cursor off the exclusive maxX/maxY
    /// boundary that CGRect.contains treats as outside.
    private let edgeMargin: CGFloat = 2

    func lock(to displayID: CGDirectDisplayID) {
        targetDisplayID = displayID
        isLocked = true
        moveCursorToDisplayCenter(displayID)
        startMonitoring()
    }

    func unlock() {
        isLocked = false
        targetDisplayID = nil
        stopMonitoring()
    }

    private func startMonitoring() {
        stopMonitoring()
        let timer = Timer(timeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            self?.enforceLock()
        }
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }

    private func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }

    private func enforceLock() {
        guard isLocked, let displayID = targetDisplayID else { return }

        let bounds = lockBounds(for: displayID)
        guard !bounds.isNull, !bounds.isEmpty else { return }
        guard let location = currentMouseLocation() else { return }

        guard isInside(location, bounds: bounds) else {
            CGWarpMouseCursorPosition(clamp(location, to: bounds))
            return
        }
    }

    private func moveCursorToDisplayCenter(_ displayID: CGDirectDisplayID) {
        let bounds = CGDisplayBounds(displayID)
        guard !bounds.isNull, !bounds.isEmpty else { return }
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        CGWarpMouseCursorPosition(center)
    }

    private func lockBounds(for displayID: CGDirectDisplayID) -> CGRect {
        CGDisplayBounds(displayID).insetBy(dx: edgeMargin, dy: edgeMargin)
    }

    private func isInside(_ point: CGPoint, bounds: CGRect) -> Bool {
        // CGRect.contains treats points on maxX/maxY as outside, which caused
        // an infinite warp loop when the cursor was clamped to the right/bottom edge.
        point.x >= bounds.minX && point.x < bounds.maxX &&
            point.y >= bounds.minY && point.y < bounds.maxY
    }

    private func currentMouseLocation() -> CGPoint? {
        CGEvent(source: nil)?.location
    }

    private func clamp(_ point: CGPoint, to bounds: CGRect) -> CGPoint {
        let maxX = bounds.maxX - edgeMargin
        let maxY = bounds.maxY - edgeMargin
        return CGPoint(
            x: min(max(point.x, bounds.minX), maxX),
            y: min(max(point.y, bounds.minY), maxY)
        )
    }
}
