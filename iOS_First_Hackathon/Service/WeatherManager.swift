import Foundation
import UIKit

enum NetworkError: Error {
    case badUrl
    case noData
    case decodingError
}

class WeatherManager {
    
    let cityName: String
    
    init(cityName: String){
        self.cityName = cityName
    }
    
    func getWeather(completion: @escaping (Result<WeatherModel, NetworkError>) -> Void) {
        
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else { return }
        
        // API 호출을 위한 URL
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&q=\(cityName)&units=metric")
        
//        let url = "http://api.openweathermap.org/data/2.5/weather?lat=\(currentLocation!.coordinate.latitude)&lon=\(currentLocation!.coordinate.longitude)"

        guard let url = url else {
            return completion(.failure(.badUrl))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            let weatherResponse = try? JSONDecoder().decode(WeatherModel.self, from: data)

            if let weatherResponse = weatherResponse {
                print(weatherResponse)
                completion(.success(weatherResponse))
            } else {
                print("error")
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
