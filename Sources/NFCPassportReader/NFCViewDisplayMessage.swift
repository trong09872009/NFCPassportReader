//
//  NFCViewDisplayMessage.swift
//  NFCPassportReader
//
//  Created by Andy Qua on 09/02/2021.
//

import Foundation

@available(iOS 13, macOS 10.15, *)
public enum NFCViewDisplayMessage {
    case requestPresentPassport
    case authenticatingWithPassport(Int)
    case readingDataGroupProgress(DataGroupId, Int)
    case error(NFCPassportReaderError)
    case activeAuthentication
    case successfulRead
}

@available(iOS 13, macOS 10.15, *)
extension NFCViewDisplayMessage {
    public var description: String {
        let isVietnamese = Locale.current.languageCode == "vi"
        switch self {
            case .requestPresentPassport:
                return isVietnamese
                    ? "Hãy đặt iPhone của bạn gần căn cước có hỗ trợ NFC."
                    : "Hold your iPhone near an NFC enabled passport."
            case .authenticatingWithPassport(let progress):
                let progressString = handleProgress(percentualProgress: progress)
                return isVietnamese
                    ? "Đang xác thực với căn cước.....\n\n\(progressString)"
                    : "Authenticating with passport.....\n\n\(progressString)"
            case .readingDataGroupProgress(let dataGroup, let progress):
                let progressString = handleProgress(percentualProgress: progress)
                return isVietnamese
                    ? "Đang đọc \(dataGroup).....\n\n\(progressString)"
                    : "Reading \(dataGroup).....\n\n\(progressString)"
            case .error(let tagError):
                switch tagError {
                    case NFCPassportReaderError.TagNotValid:
                        return isVietnamese ? "Thẻ không hợp lệ." : "Tag not valid."
                    case NFCPassportReaderError.MoreThanOneTagFound:
                        return isVietnamese
                            ? "Tìm thấy hơn 1 thẻ. Vui lòng chỉ đưa 1 thẻ gần thiết bị."
                            : "More than 1 tags was found. Please present only 1 tag."
                    case NFCPassportReaderError.ConnectionError:
                        return isVietnamese
                            ? "Lỗi kết nối. Vui lòng thử lại."
                            : "Connection error. Please try again."
                    case NFCPassportReaderError.InvalidMRZKey:
                        return isVietnamese
                            ? "Mã MRZ không hợp lệ cho tài liệu này."
                            : "MRZ Key not valid for this document."
                    case NFCPassportReaderError.ResponseError(let description, let sw1, let sw2):
                        return isVietnamese
                            ? "Xin lỗi, có sự cố khi đọc căn cước. \(description) - (0x\(sw1), 0x\(sw2))"
                            : "Sorry, there was a problem reading the passport. \(description) - (0x\(sw1), 0x\(sw2))"
                    default:
                        return isVietnamese
                            ? "Xin lỗi, có sự cố khi đọc căn cước. Vui lòng thử lại."
                            : "Sorry, there was a problem reading the passport. Please try again"
                }
            case .activeAuthentication:
                return isVietnamese ? "Đang xác thực....." : "Authenticating....."
            case .successfulRead:
                return isVietnamese ? "Đọc căn cước thành công" : "Passport read successfully"
        }
    }
    
    func handleProgress(percentualProgress: Int) -> String {
        let p = (percentualProgress/20)
        let full = String(repeating: "🟢 ", count: p)
        let empty = String(repeating: "⚪️ ", count: 5-p)
        return "\(full)\(empty)"
    }
}
