//
//  APIManager.swift
//  Weather4Cast
//
//  Created by Kushal on 02/01/20.
//  Copyright © 2020 Kushal. All rights reserved.
//

import Foundation

class APIManager {
    
    
    static let shared = APIManager()
    
    private var BASE_URL_WEATHER = "https://api.openweathermap.org/data/2.5/weather"
    private var BASE_URL_FORECAST = "https://api.openweathermap.org/data/2.5/forecast"
    private var API_ID = "aeeed94a96013f85857502616707d896"
    
    func makeWeatherRequest(params:[String:String],completion:@escaping (Data?,URLResponse?,Error?)->()) {
        
        var urlComponent = URLComponents(string: BASE_URL_WEATHER)
        let queryItemOne = URLQueryItem(name: "lat", value: params["latitude"])
        let queryItemTwo = URLQueryItem(name: "lon", value: params["longitude"])
        let queryItemApiId = URLQueryItem(name: "appid", value: API_ID)
        
        urlComponent?.queryItems = [queryItemOne,queryItemTwo,queryItemApiId]
        
        guard let url = urlComponent?.url else {return}
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            
            if err != nil {
                print("error:",err?.localizedDescription as Any)

            } else {
                completion(data,res,err)
            }

        }.resume()
        
    }
    
    func makeForecastRequest(params: [String: String], completion: @escaping (Data?,URLResponse?,Error?) -> ()) {
        
        
        var urlComponent = URLComponents(string: BASE_URL_FORECAST)
               let queryItemOne = URLQueryItem(name: "lat", value: params["latitude"])
               let queryItemTwo = URLQueryItem(name: "lon", value: params["longitude"])
               let queryItemApiId = URLQueryItem(name: "appid", value: API_ID)
               
               urlComponent?.queryItems = [queryItemOne,queryItemTwo,queryItemApiId]
               
               guard let url = urlComponent?.url else {return}
               
               URLSession.shared.dataTask(with: url) { (data, res, err) in
                   
                   if err != nil {
                       print("error:",err?.localizedDescription as Any)

                   } else {
                       completion(data,res,err)
                   }

               }.resume()
        
    }
    
    
}


