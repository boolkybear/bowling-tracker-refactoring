//
//  String+localization.swift
//  refactoringApp
//

import Foundation

extension String {
    init(localized resource: LocalizedStringResource, to languageCode: String) {
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            self = String(localized: resource)
            return
        }

        let updatedResource = LocalizedStringResource(
            resource.defaultValue,
            table: resource.table,
            locale: Locale(identifier: languageCode),
            bundle: .atURL(bundle.bundleURL),
            comment: nil
        )

        self = String(localized: updatedResource)
    }

    var localized: String {
        var language = persistence.string(forKey: "appLanguage") ?? "en"
        let validLanguages = ["es", "en"]
        if !validLanguages.contains(language) {
            language = "en"
        }

        return String(localized: LocalizedStringResource(stringLiteral: self), to: language)
    }
}
