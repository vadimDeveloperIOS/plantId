//
//  PlantIDClient.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 29.06.25.
//

import Foundation
import Alamofire
import UIKit


// ------------------------------------------------
// MARK: - Plant.id Client
// ------------------------------------------------

/// Наборы ключей для параметра details
private enum Details {
    /// Поля для классификации растений
    static let classification = [
        "common_names",        // народные названия
        "description",         // описание из Wikipedia
        "description_all",     // объединённое описание GPT+Wiki
        "taxonomy",            // научная классификация
        "name_authority",      // научное имя с авторством
        "synonyms",            // синонимы
        "propagation_methods", // методы размножения
        "watering",            // оптимальный диапазон влажности
        "best_watering",       // текстовое описание полива
        "best_light_condition",// рекомендации по свету
        "best_soil_type"       // тип почвы
    ]
    /// Поля для диагностики заболеваний
    static let disease = [
        "local_name",   // локальное название болезни
        "description",  // описание болезни
        "treatment",    // рекомендации по лечению и профилактике
        "common_names", // народные названия болезни
        "cause"         // причина (патоген)
    ]
}

/// Обёртка над Plant.id v3 для получения данных о растении
final class PlantIDClient {
    static let shared = PlantIDClient()
    private init() {}
    
    private let apiKey = "CUpIwildxp3phXo3jrWcrEo7bNNTldkGgrBjPOseMUPv29qJaj"
//    private let apiKey = "zcO96SDxsGtFlNqCUjQPUonwvrO9cgdvYhTXbtI6bCggdmiGug"
//    private let apiKey = "yD4baNEBnwZ3EtZMKDAGzKFQzUvI8Pso0THoBRS8wUAVpZkvzz"
//    private let apiKey: String = "upAcnbpgumNKHMpzADQ4h4YfaJ4Ph7I4oRzBPF8Pvzt62LiKdk"
    private let baseURL = "https://plant.id/api/v3"
    private var headers: HTTPHeaders { ["Api-Key": apiKey, "Content-Type": "application/json"] }

    // ------------------------------------------------
    // MARK: - Основной метод идентификации
    // ------------------------------------------------
    /// Отправляет массив фото и получает ответ API с параметром health == nil (только классификация)
    func identifyPlant(
        images: [UIImage],
        completion: @escaping (Result<IdentificationResponse, AFError>) -> Void
    ) {
        let imgs = convertToDataArray(from: images)
        
        self.requestIdentification(
            images: imgs,
            health: nil,
            completion: completion
        )
    }

    /// Отправляет массив фото и получает ответ API с параметром health == "all" (вид + здоровье)
    func identifyPlantWithHealth(
        images: [UIImage],
        completion: @escaping (Result<IdentificationResponse, AFError>) -> Void
    ) {
        let imgs = convertToDataArray(from: images)
        
        self.requestIdentification(
            images: imgs,
            health: "all",
            completion: completion
        )
    }

    // ------------------------------------------------
    // MARK: - Внутренний запрос
    // ------------------------------------------------
    private func requestIdentification(
        images: [Data],
        health: String?,
        completion: @escaping (Result<IdentificationResponse, AFError>) -> Void
    ) {
        let urlString = baseURL + "/identification"
        var components = URLComponents(string: urlString)!
        
        var language = "plant_api_lang".localized
        let validLanguages = ["en", "ar", "fr", "de", "it", "pt", "zh", "es", "zh-hant"]
        if !validLanguages.contains(language) {
            language = "en"
        }
        // Query Params
        components.queryItems = [
            URLQueryItem(name: "health", value: health),
            URLQueryItem(name: "language", value: language),
            URLQueryItem(name: "similar_images", value: "false"),
            URLQueryItem(name: "classification_level", value: "species"),
            URLQueryItem(name: "classification_raw", value: "false"),
            URLQueryItem(name: "symptoms", value: "true"),
            URLQueryItem(name: "suggestion_filter", value: "houseplant OR tree OR ornamental"),
            URLQueryItem(name: "details",
                         value: (Details.classification + Details.disease).joined(separator: ","))
        ]
        let url = components.url!

        // Body Params
        var body: [String: Any] = [
            "images": images.map { $0.base64EncodedString() }
        ]
        if let h = health { body["health"] = h }
        // latitude, longitude, datetime omitted -> nil

        AF.request(
            url,
            method: .post,
            parameters: body,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .validate()
        .responseDecodable(of: IdentificationResponse.self) { response in
            completion(response.result)
        }
    }
    
    private func convertToDataArray(from images: [UIImage]) -> [Data] {
        return images.compactMap { image in
            image.pngData()
        }
    }

}

// ------------------------------------------------
// MARK: - Response Models
// ------------------------------------------------

/// Общий ответ API (идентификация + здоровье)
struct IdentificationResponse: Codable {
    let accessToken: String     // токен запроса для последующих вызовов
    let result: IdentificationResult

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case result
    }
}

/// Результаты идентификации и диагностики
struct IdentificationResult: Codable {
    let isPlant: PlantBoolean           // есть ли растение на фото?
    let classification: ClassificationResult? // варианты вида
    let disease: DiseaseResult?         // варианты болезней
    let isHealthy: isHealthyResult?

    enum CodingKeys: String, CodingKey {
        case isPlant = "is_plant"
        case classification, disease
        case isHealthy = "is_healthy"
    }
}

struct isHealthyResult: Codable {
    let binary: Bool?
    let threshold: Double?
    let probability: Double?
}

/// Булевый результат с вероятностью
struct PlantBoolean: Codable {
    let binary: Bool?       // true = модель считает, что на фото растение
    let probability: Double?// вероятность (0–1)
    let threshold: Double? // порог, который API использует (обычно 0.5)
}

/// Список предложений по таксономии
struct ClassificationResult: Codable {
    let suggestions: [PlantSuggestion]? // массив гипотез (виды)
}

/// Один вариант вида растения
struct PlantSuggestion: Codable {
    let id: String         // уникальный ID вида в базе
    let name: String       // латинское название
    let probability: Double// доверие модели (0–1)
    let similarImages: [SimilarImage]? // примеры фото вида
    let details: PlantDetails?         // дополнительные поля из details

    enum CodingKeys: String, CodingKey {
        case id, name, probability, details
        case similarImages = "similar_images"
    }
}

/// Информация о похожем изображении
struct SimilarImage: Codable {
    let url: String?        // URL полного изображения
    let licenseName: String?// название лицензии (например CC BY-SA)
    let licenseUrl: String? // ссылка на лицензию
    let citation: String?   // автор или источник фото
    let similarity: Double? // насколько похоже (0–1)
    let urlSmall: String?   // URL маленькой версии

    enum CodingKeys: String, CodingKey {
        case url, citation, similarity
        case licenseName = "license_name"
        case licenseUrl = "license_url"
        case urlSmall    = "url_small"
    }
}

/// Дополнительные сведения о растении (fields from details)
struct PlantDetails: Codable {
    let commonNames: [String]?    // народные названия
    let description: DescriptionBlock? // описание и источники
    let descriptionAll: DescriptionBlock?        // объединённое GPT+Wiki
    let taxonomy: Taxonomy?            // научная таксономия
    let nameAuthority: String?         // научное имя с автором
    let synonyms: [String]?            // синонимы
    let propagationMethods: [String]?  // методы размножения
    let watering: WateringInfo?        // диапазон влажности
    let bestWatering: String?          // текст о поливе
    let bestLightCondition: String?    // рекомендации по свету
    let bestSoilType: String?          // тип почвы

    enum CodingKeys: String, CodingKey {
        case commonNames      = "common_names"
        case description
        case descriptionAll   = "description_all"
        case taxonomy
        case nameAuthority    = "name_authority"
        case synonyms
        case propagationMethods = "propagation_methods"
        case watering
        case bestWatering     = "best_watering"
        case bestLightCondition = "best_light_condition"
        case bestSoilType     = "best_soil_type"
    }
}

/// Блок описания с метаданными лицензии
struct DescriptionBlock: Codable {
    let value: String?       // текст описания
    let citation: String?    // ссылка на источник
    let licenseName: String? // название лицензии
    let licenseUrl: String?  // URL лицензии

    enum CodingKeys: String, CodingKey {
        case value, citation
        case licenseName = "license_name"
        case licenseUrl  = "license_url"
    }
}

/// Научная классификация (genus, family и т.д.)
struct Taxonomy: Codable {
    let genus: String?
    let family: String?
    let order: String?
    let rank: String?
    let phylum: String?
}

/// Диапазон влажности для полива
struct WateringInfo: Codable {
    let min: Int? // минимальный процент влажности
    let max: Int? // максимальный процент влажности
}

/// Результаты диагностики заболеваний
struct DiseaseResult: Codable {
    let suggestions: [DiseaseSuggestion]? // массив гипотез болезней
    let question: FollowUpQuestion?      // уточняющий вопрос, если нужен
}

/// Одна гипотеза болезни
struct DiseaseSuggestion: Codable {
    let id: String
    let name: String       // название болезни
    let probability: Double// доверие к диагнозу
    let similarImages: [SimilarImage]?
    let details: DiseaseDetails? // детали болезни
    let redundant: Bool?    // true = слишком общий, можно скрыть

    enum CodingKeys: String, CodingKey {
        case id, name, probability, details, redundant
        case similarImages = "similar_images"
    }
}

/// Детали болезни (описание, лечение и т.д.)
struct DiseaseDetails: Codable {
    let description: String?        // текст определения
    let treatment: [String: [String]]? // советы по лечению (biological, chemical, prevention)
    let commonNames: [String]?      // другие названия болезни
    let cause: String?              // причина (патоген)

    enum CodingKeys: String, CodingKey {
        case description, treatment
        case commonNames = "common_names"
        case cause
    }
}

/// Уточняющий вопрос от модели (если не уверена в диагнозе)
struct FollowUpQuestion: Codable {
    let text: String?               // текст вопроса
    let options: [QuestionOption]?  // варианты «да»/«нет»
}

/// Один вариант ответа на уточняющий вопрос
struct QuestionOption: Codable {
    let suggestionIndex: Int? // индекс в suggestions
    let entityId: String?     // ID соответствующего диагноза
    let name: String?        // текст варианта (yes/no)

    enum CodingKeys: String, CodingKey {
        case suggestionIndex = "suggestion_index"
        case entityId        = "entity_id"
        case name
    }
}
