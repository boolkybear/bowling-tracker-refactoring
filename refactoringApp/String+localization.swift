//
//  String+localization.swift
//  refactoringApp
//
//  Created by Jose Servet Font on 29/09/2026.
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
            resource.defaultValue, // Mantiene la clave/valor interpolado nativo
            table: resource.table,
            locale: Locale(identifier: languageCode),
            bundle: .atURL(bundle.bundleURL), // Forzamos el sub-bundle
            comment: nil
        )

        self = String(localized: updatedResource)
    }

    var localized: String {
        var language = UserDefaults.standard.string(forKey: "appLanguage") ?? "en"
        let validLanguages = ["es", "en"]
        if !validLanguages.contains(language) {
            language = "en"
        }

        return String(localized: LocalizedStringResource(stringLiteral: self), to: language)
    }
}
