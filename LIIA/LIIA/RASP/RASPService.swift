/*
 I DO NOT RECOMMEND USING THESE RASP FUNCTIONS IN REAL APP SINCE
 THESE ARE MEANT TO BE BYPASSED FOR THE SAKE OF THE EXPERIMENT
 */

import UIKit

class RASPService {

    // MARK: - Jailbreak detection
    static let appsPaths = [
        "/Applications/Cydia.app",
        "/Applications/blackra1n.app",
        "/Applications/Sileo.app"
        // ...
    ]

    static let systemPaths = [
        "/etc/apt",
        "/bin/bash",
        "/usr/bin/sshd",
        "/usr/libexec/sftp-server",
        "/usr/sbin/sshd",
        "/private/var/lib/apt",
        "/private/var/lib/cydia",
        "/private/var/mobile/Library/SBSettings/Themes",
        "/private/var/stash",
        "/private/var/tmp/cydia.log"
        // ...
    ]

    static func isDeviceJailbroken() -> Bool {
        // Checking for Cydia URL scheme
        if UIApplication.shared.canOpenURL(URL(string: "cydia://")!) { return true }

        // Checking for suspicious apps like Cydia, blackra1n, Sileo
        for path in appsPaths {
            if FileManager.default.fileExists(atPath: path) { return true }
        }

        // Checking for access to system files
        for path in systemPaths {
            if FileManager.default.fileExists(atPath: path) { return true }
        }

        // Checking if editing system files is possible
        do {
            try "test".write(toFile: "test.txt", atomically: true, encoding: .utf8)
            return true
        } catch { return false }
    }

    // MARK: - Anti debugging detection
    /// Anti debugging detection is also run at the start of the app in the 'main.swift'

    static func isDebuggerAttached() -> Bool {
        getppid() != 1
    }

}
