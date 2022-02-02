//
//  NotificationService.swift
//  PNServiceExtension
//
//  Created by Zolt Varga on 01/31/22.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        // 1. Check for custom content
        guard let bestAttemptContent = bestAttemptContent, // 1a. Make sure bestAttemptContent is not nil
              let mediaURL = bestAttemptContent.userInfo["media-url"] as? String, // 2a. The attachment-url
              let attachmentURL = URL(string: mediaURL) else { // 3a. Create URL
                  return
              }
        
        // 2. Create Custom Action Buttons and register them (Optional),
        // In AppDelegate Need to register "likeIdentifier" and "shareIdentifier" to listen for tap to be able to do custom action
        let likeAction = UNNotificationAction(identifier: "likeIdentifier", title: "Like ❤️", options: [])
        let saveAction = UNNotificationAction(identifier: "shareIdentifier", title: "Share ⬆️", options: [])
        let category = UNNotificationCategory(identifier: "myMediaServiceCategory",
                                              actions: [likeAction, saveAction],
                                              intentIdentifiers: [],
                                              options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        // 3. Download the image and pass it to attachments if not nil
        downloadImageFrom(url: attachmentURL) { (attachment) in
            if attachment != nil {
                bestAttemptContent.attachments = [attachment!]
                contentHandler(bestAttemptContent)
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // 3. Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}

// MARK: - Multi Media Helper
extension NotificationService {
    
    private func downloadImageFrom(url: URL, with completionHandler: @escaping (UNNotificationAttachment?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { (downloadedUrl, response, error) in
            guard let downloadedUrl = downloadedUrl else {
                completionHandler(nil)
                return
            }
            // 1. Application directory path
            var urlPath = URL(fileURLWithPath: NSTemporaryDirectory())
            // 2. Validate the content extension. If file is unsupported. Fallback will happend and basic Push Notifcation will be delivered
            let urlPathExt = ProcessInfo.processInfo.globallyUniqueString + ".mp4" // .png, . gid
            urlPath = urlPath.appendingPathComponent(urlPathExt)
            
            // 3. Move downloadedUrl to newly created urlPath
            try? FileManager.default.moveItem(at: downloadedUrl, to: urlPath)
            
            // 4. Try adding getting the attachment and pass it to the completion handler
            do {
                let attachment = try UNNotificationAttachment(identifier: "attachment", url: urlPath, options: nil)
                completionHandler(attachment)
            }
            catch {
                completionHandler(nil)
            }
        }
        task.resume()
    }
}
