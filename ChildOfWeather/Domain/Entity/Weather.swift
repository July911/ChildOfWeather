import Foundation

struct Weather {

    let maxTemperature: Double
    let lowTemperature: Double
    let sunrise: Int
    let sunset: Int

    init?(data: [String: Any]) {
        
        guard let main = data["main"] as? [String: Any], let sys = data["sys"] as? [String:Any]
        else {
            return nil
        }
        
        guard let dataMaxTemperature = main["temp_max"] as? Double,
              let dataMinTemperature = main["temp_min"] as? Double,
              let dataSunrise = sys["sunrise"] as? Int,
                let dataSunset = sys["sunset"] as? Int
        else {
            return nil
        }
        
        self.maxTemperature = dataMaxTemperature
        self.lowTemperature = dataMinTemperature
        self.sunrise = dataSunrise
        self.sunset = dataSunset
    }
}
