import Foundation

extension String {
    /// Возвращает локализованную строку для текущего языка
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// Позволяет подставлять параметры в локализованные строки
    func localizedFormat(_ args: CVarArg...) -> String {
        return String(format: self.localized, arguments: args)
    }
} 