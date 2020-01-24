//
//  WeatherViewController.swift
//  Weather4Cast
//
//  Created by Kushal on 01/01/20.
//  Copyright © 2020 Kushal. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    var selectedCity: CLPlacemark!
    var topContainerView: CurrentWeatherView!
    var bottomContainerView: WeatherForecastView!
    
    var progressIndicator: UIActivityIndicatorView!
    
    
    var locationManager: CLLocationManager!
    var weatherViewModelInstance = WeatherViewModel()
    var forecastViewModelInstance = ForecastViewModel()
    
    //top container contains temp label, min max label, weather description and image
    fileprivate func setupTopContainer() {
        topContainerView = CurrentWeatherView()
        topContainerView.selectCityButton.addTarget(self, action: #selector(selectCity), for: .touchUpInside)
        view.addSubview(topContainerView)
        
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topContainerView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 0),
            topContainerView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 0),
            topContainerView.trailingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.trailingAnchor, multiplier: 0),
            topContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        ])
    }
    
    
    fileprivate func setupBottomContainer() {
        
        bottomContainerView = WeatherForecastView()
        view.addSubview(bottomContainerView)
        
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
               
                   bottomContainerView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor),
                   bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                   bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                   bottomContainerView.heightAnchor.constraint(equalToConstant: 100)
               ])
    }
    
    
    fileprivate func setupActivityIndicator() {
        
        progressIndicator = UIActivityIndicatorView()
        progressIndicator.center = self.view.center
        self.view.addSubview(progressIndicator)
        progressIndicator.style = .medium
        progressIndicator.color = .red
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFirstLaunch() {
            selectCity()
            UserDefaults.standard.set(true, forKey: "hasLaunchedPreviously")
        }
            
        setupTopContainer()
        setupBottomContainer()
        setupActivityIndicator()
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest

            locationManager.requestLocation()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if weatherViewModelInstance.currentWeather == nil || forecastViewModelInstance.currentForecast == nil {
            emptyUI()
        }
    }
   
    
    func emptyUI() {
        topContainerView.isHidden = true
        bottomContainerView.isHidden = true
        progressIndicator.startAnimating()
        
        
    }
    
    
    @objc func selectCity() {
        
        let selectCityVC = SelectCityViewController()
        selectCityVC.delegate = self
        selectCityVC.view.backgroundColor = .systemBackground
        self.navigationController?.pushViewController(selectCityVC, animated: isFirstLaunch() ? false : true)
        selectCityVC.navigationController?.navigationBar.isHidden = isFirstLaunch() ? true : false
    }
    
    
    //for refreshing ui state after receiving update
    func refreshWeatherUIState() {
        
        if weatherViewModelInstance.currentWeather != nil {
            
            topContainerView.tempLabel.text = "\(round(10*weatherViewModelInstance.getCurrentTempInCelsius()!)/10) °c"
            topContainerView.minTempLabel.text = "\(round(10*weatherViewModelInstance.getMinTempInCelsius()!)/10) °c"
            topContainerView.maxTempLabel.text = "\(round(10*weatherViewModelInstance.getMaxTempInCelsius()!)/10) °c"
            topContainerView.weatherDescriptionLabel.text = weatherViewModelInstance.getWeatherDescription()?.capitalized
            topContainerView.weatherImageView.downloadWeatherImage(imgId: weatherViewModelInstance.getWeatherIcon()!)
            topContainerView.selectCityButton.isHidden = false
            
            weatherViewModelInstance.getReverseGeoCode { (placemark) in
                
                DispatchQueue.main.async {
                    self.topContainerView.cityLabel.text = placemark?.locality
                    self.topContainerView.isHidden = false
                    self.progressIndicator.stopAnimating()
                }
                
            }
            
        }
    }
    
    
    func refreshForecastUIState() {
        
        for i in 0..<forecastViewModelInstance.getFollowingFiveDays().count {
            let view = bottomContainerView.dayViews[i]
            view.dayLabel.text = forecastViewModelInstance.getFollowingFiveDays()[i]
            view.forecastDetailLabel.text = forecastViewModelInstance.getHighLowForFollowingFiveDays()[i]
            
            
            var weatherConditionImageId = forecastViewModelInstance.getAvgWeatherConditionImageStringsForFiveDays()[i]          
            weatherConditionImageId+="d"
            view.forecastImageView.downloadWeatherImage(imgId: weatherConditionImageId)
        }
        bottomContainerView.isHidden = false
    }
    
    func isFirstLaunch() -> Bool {
        return !UserDefaults.standard.bool(forKey: "hasLaunchedPreviously")
    }
    

}
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let latitude = "\(locations.first!.coordinate.latitude)"
        let longitude = "\(locations.first!.coordinate.longitude)"
        
        weatherViewModelInstance.refreshWeather(params: ["latitude": latitude,"longitude": longitude]) {
            
            DispatchQueue.main.async {
                self.refreshWeatherUIState()
            }
        }
        
        forecastViewModelInstance.refreshWeatherForecast(params: ["latitude": latitude,"longitude": longitude]) {
           
            DispatchQueue.main.async {
                self.refreshForecastUIState()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}

extension WeatherViewController: SelectCityDelegate {
    
    func onSelectCity(placemark: CLPlacemark) {
        
        self.selectedCity = placemark
        
        let latitude = "\(placemark.location!.coordinate.latitude)"
        let longitude = "\(placemark.location!.coordinate.longitude)"
        
        weatherViewModelInstance.refreshWeather(params: ["latitude": latitude,"longitude": longitude]) {
            
            DispatchQueue.main.async {
                self.refreshWeatherUIState()
            }
        }
        
        forecastViewModelInstance.refreshWeatherForecast(params: ["latitude": latitude,"longitude": longitude]) {
           
            DispatchQueue.main.async {
                self.refreshForecastUIState()
            }
        }
        
    }
    
}


extension UIImageView {
    
    
    func downloadWeatherImage(imgId: String) {
        
        let imgUrlString = "https://openweathermap.org/img/wn/\(imgId)@2x.png"
        print(imgUrlString)
        
        guard let imgUrl = URL(string: imgUrlString) else {return}
        
        URLSession.shared.dataTask(with: imgUrl) { (data, _, _) in
            
            guard let imgData = data else {return}
            
            guard let img = UIImage(data: imgData) else {return}
            
            DispatchQueue.main.async {
                self.image = img
            }
        }.resume()
    }
    
}
