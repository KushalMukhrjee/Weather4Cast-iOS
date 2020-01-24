//
//  ForecastViewModel.swift
//  Weather4Cast
//
//  Created by Kushal on 03/01/20.
//  Copyright © 2020 Kushal. All rights reserved.
//

import Foundation

class ForecastViewModel {
    
    
    var currentForecast: Forecast?
    
    
    func refreshWeatherForecast(params: [String: String], completion: @escaping ()->()) {
        currentForecast = nil
        getWeatherForecast(params: params) { (forecast) in
            self.currentForecast = forecast
            completion()
        }
    }
    
    func getWeatherForecast(params: [String: String], completion: @escaping (Forecast?) -> ()) {
        
        
        APIManager.shared.makeForecastRequest(params: params) { (data, res, err) in
            
            if err != nil {
                
                completion(nil)
                
            } else {
                guard let data = data else {return}
                do{
                    let forecast = try JSONDecoder().decode(Forecast.self, from: data)
                    completion(forecast)
                } catch {
                    print(error.localizedDescription)
                    completion(nil)
                }
            }
        }
    }
    
    func getFollowingFiveDays() -> [String] {
        
        var daysArray: [String]?
        let today = Date()
        let datetFormatter = DateFormatter()
        datetFormatter.dateFormat = "yyyy-MM-dd"
        let todayDateInString = datetFormatter.string(from: today) + " 23:59:59"
        
        let nextFiveDays = currentForecast?.weatherList.filter{
            
            guard let date = $0.date else {return false}
            return date > todayDateInString

        }
        
        daysArray = (nextFiveDays?.map {
            
            let dtFormatter = DateFormatter()
            dtFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dtFormatter.date(from: $0.date!)
            dtFormatter.dateFormat = "E"
            let string = dtFormatter.string(from: date!)
            return string
            })
        
        
        return daysArray?.removingDuplicates() ?? []
    }
    
    func getHighLowForFollowingFiveDays() -> [String] {
        
        var maxMins = [String]()
        
        for currentday in getFollowingFiveDays() {
            
            
            let weatherList = currentForecast?.weatherList.filter {
                
                let dtFormatter = DateFormatter()
                dtFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dayDate = dtFormatter.date(from: $0.date!)
                dtFormatter.dateFormat = "E"
                let day = dtFormatter.string(from: dayDate!)
                
                return day == currentday
            }
            
            var max = weatherList?.first?.weatherMain.tempMax ?? 0.0
            var min = weatherList?.first?.weatherMain.tempMin ?? 373.0
            
            for weather in weatherList! {
                
                if weather.weatherMain.tempMax > max {
                    max = weather.weatherMain.tempMax
                }
                
                if weather.weatherMain.tempMin < min {
                    min = weather.weatherMain.tempMin
                }
                
            }
            
            let maxInCenti = Int(round(max-273))
            let minInCenti = Int(round(min-273))
            
            maxMins.append("\(maxInCenti)/\(minInCenti)")
            
        }
        return maxMins
    }
    
    func getAvgWeatherConditionImageStringsForFiveDays() -> [String] {
        
        
        
        var weatherImages = [String]()
        
        for currentday in getFollowingFiveDays() {
               
            
            var weatherCondDict = [String: Int]()
               let weatherList = currentForecast?.weatherList.filter {
                   let dtFormatter = DateFormatter()
                   dtFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                   let dayDate = dtFormatter.date(from: $0.date!)
                   dtFormatter.dateFormat = "E"
                   let day = dtFormatter.string(from: dayDate!)
                   
                   return day == currentday
           }
            
            for weather in weatherList! {
                
                var icon = weather.weatherDescriptions.first!.icon
                icon.removeLast()
                var count = weatherCondDict[icon]
                if count == nil {
                    count = 1
                } else {
                    count! += 1
                }
                 weatherCondDict[icon] = count
                
            }
            
            for (k,v) in weatherCondDict {
                if v == weatherCondDict.values.max(){
                    weatherImages.append(k)
                    break
                }
            }
            
            
            
            
            
        }
        return weatherImages
        
        
        
    }
}




extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}



