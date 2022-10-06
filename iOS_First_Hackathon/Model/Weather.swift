import Foundation

struct WeatherModel: Codable {
    var weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String
    let visibility: Int // 시정
}

struct Main: Codable {
    let temp: Double // 현재 기온
    let feels_like: Double // 체감 기온
    let temp_min: Double // 최저 기온
    let temp_max: Double // 최고 기온
    let humidity: Int // 현재 습도
    let pressure: Int // 기압
}

struct Wind: Codable {
    let speed: Double // 풍속
}

struct Weather: Codable {
    let id: Int
    let main: String // 날씨
    let description: String // 날씨설명
    let icon: String // 아이콘
}

// API 값 받으면 return 하는 city name -> 한글 name 으로 변경
var CityKoreaListDic: [[String: String]] = [
    ["Gongju": "공주"], ["Mokpo": "목포"], ["Gumi": "구미"], ["Busan": "부산"], ["Seosan City": "서산"], ["Seoul": "서울"], ["Daegu": "대구"], ["Gwangju": "광주"], ["Gunsan": "군산"], ["Daejeon": "대전"], ["Sokcho": "속초"], ["Iksan": "익산"], ["Suwon-si": "수원"], ["Suncheon": "순천"], ["Ulsan": "울산"], ["Jeonju": "전주"], ["Jeju City": "제주"], ["Cheonan": "천안"], ["Cheongju-si": "청주"], ["Chuncheon": "춘천"]
]
