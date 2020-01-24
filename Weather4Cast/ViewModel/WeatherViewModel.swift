//
//  WeatherViewModel.swift
//  Weather4Cast
//
//  Created by Kushal on 02/01/20.
//  Copyright © 2020 Kushal. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherViewModel {
    
    var currentWeather: Weather?
    
    func refreshWeather(params: [String: String],completion: @escaping () -> ()) {
        
        currentWeather = nil
        getWeather(params: params) { (weather) in
            
            self.currentWeather = weather
            completion()
        }
    }
    
    
    func getWeather(params:[String:String], completion:@escaping (Weather?) -> () ) {
        
        APIManager.shared.makeWeatherRequest(params: params) { (data, res, err) in
            
            
            guard let data = data else {return}
            
            if err != nil {
                completion(nil)
            }
            
            else {
                do {
                    
                    let weather = try JSONDecoder().decode(Weather.self, from: data)
                    completion(weather)
                } catch {
                    print("Error parsing weather JSON: ",error.localizedDescription)
                    completion(nil)
                }
            }
        }
        
    }
    
    func getCurrentTempInCelsius() -> Double? {
        
        guard let currentWeather = currentWeather else {return nil}
        return (currentWeather.weatherMain.temp - 273)
        
    }
    
    func getMinTempInCelsius() -> Double? {
        
        guard let currentWeather = currentWeather else {return nil}
        
        return (currentWeather.weatherMain.tempMin - 273)
        
        
    }
    
    func getMaxTempInCelsius() -> Double? {
           
           guard let currentWeather = currentWeather else {return nil}
           
           return (currentWeather.weatherMain.tempMax - 273)
           
           
    }
    
    func getWeatherDescription() -> String? {
        
        guard let currentWeather = currentWeather else {return nil}
        
        return currentWeather.weatherDescriptions.first?.description
        
        
        
    }
    
    func getWeatherIcon() -> String? {
        
        guard let currentWeather = currentWeather else {return nil}

        return currentWeather.weatherDescriptions.first?.icon
        
    }
    
    func getReverseGeoCode(completion: @escaping (CLPlacemark?) -> ())  {
        
        
        guard let currentWeather = currentWeather else {return}
        guard let coordinates = currentWeather.coordinates else {return}
        
        
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, err) in
            
            guard let placemark = placemarks?.first else {return}
            completion(placemark)
            
        }
    }
    
    
    
}

var jsonString = """
{"coord":{"lon":77.59,"lat":12.97},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04d"}],"base":"stations","main":{"temp":298.09,"feels_like":301.66,"temp_min":296.48,"temp_max":299.82,"pressure":1020,"humidity":83},"visibility":6000,"wind":{"speed":1.5,"deg":190},"clouds":{"all":75},"dt":1577948545,"sys":{"type":1,"id":9205,"country":"IN","sunrise":1577927509,"sunset":1577968465},"timezone":19800,"id":1277333,"name":"Bangalore","cod":200}
"""
