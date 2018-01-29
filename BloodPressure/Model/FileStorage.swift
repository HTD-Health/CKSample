import Foundation

typealias Storable = Codable & FilenameGenerating

final class FileStorage {

    static func store<T: Storable>(_ object: T) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let directoryURL = storeURL(for: type(of: object))
        let url = directoryURL.appendingPathComponent(object.fileName, isDirectory: false)

        if !FileManager.default.fileExists(atPath: directoryURL.path) {
            do {
                try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                fatalError(error.localizedDescription)
            }
        }

        do {
            let data = try encoder.encode(object)
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    static func listFiles<T: Storable>(for type: T.Type) -> [String] {
        let directoryURL = storeURL(for: type)
        do {
            let fileList = try FileManager.default.contentsOfDirectory(atPath: directoryURL.path)
            return fileList
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    static func read<T: Storable>(_ filename: String, as type: T.Type) -> T {
        let url = storeURL(for: type).appendingPathComponent(filename)

        if !FileManager.default.fileExists(atPath: url.path) {
            fatalError("\(url.path) file doesn't exist")
        }

        if let data = FileManager.default.contents(atPath: url.path) {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let object = try decoder.decode(type, from: data)
                return object
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            fatalError("No data at \(url.path)")
        }
    }

    static func remove<T: Storable>(_ object: T) {
        let url = storeURL(for: type(of: object)).appendingPathComponent(object.fileName)
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    static fileprivate func storeURL<T: Storable>(for type: T.Type) -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let directoryURL = url.appendingPathComponent(type.directory, isDirectory: true)
            return directoryURL
        } else {
            fatalError("Couldn't create URL!")
        }
    }
}

protocol FilenameGenerating {
    var fileName: String { get }
    static var directory: String { get }
}
