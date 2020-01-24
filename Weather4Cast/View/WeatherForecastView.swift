//
//  WeatherForecastView.swift
//  Weather4Cast
//
//  Created by Kushal on 03/01/20.
//  Copyright © 2020 Kushal. All rights reserved.
//

import UIKit

class WeatherForecastView: UIView {
    
    class DayForecastView: UIView {
        
        var dayLabel: UILabel!
        var forecastImageView: UIImageView!
        var forecastDetailLabel: UILabel!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            dayLabel = UILabel()
            dayLabel.textColor = .black
            dayLabel.text = "day label"
            dayLabel.textAlignment = .center
            forecastImageView = UIImageView()
            forecastImageView.contentMode = .scaleAspectFit
            forecastDetailLabel = UILabel()
            forecastDetailLabel.textAlignment = .center
            forecastDetailLabel.textColor = .black
            forecastDetailLabel.text = "Forecast detail"
            
            self.addSubview(dayLabel)
            self.addSubview(forecastImageView)
            self.addSubview(forecastDetailLabel)
            
            dayLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
            forecastDetailLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func updateConstraints() {
            super.updateConstraints()
            
            dayLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                
                dayLabel.topAnchor.constraint(equalTo: self.topAnchor),
                dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                dayLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                dayLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2)
            
            
            ])
            
            forecastImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                
                forecastImageView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor),
                forecastImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                forecastImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                forecastImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6)
            ])
            
            forecastDetailLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                
                forecastDetailLabel.topAnchor.constraint(equalTo: forecastImageView.bottomAnchor),
                forecastDetailLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                forecastDetailLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                forecastDetailLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
    }
    
    
    var forecastStackView: UIStackView!
    var dayViews = [DayForecastView(),
                    DayForecastView(),
                    DayForecastView(),
                    DayForecastView(),
                    DayForecastView()]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        forecastStackView = UIStackView()
        forecastStackView.alignment = .center
        forecastStackView.spacing = 5
        forecastStackView.axis = .horizontal
        forecastStackView.distribution = .fillEqually
        
        for view in dayViews {
            forecastStackView.addArrangedSubview(view)
        }
        self.addSubview(forecastStackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        
        
        forecastStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        
            forecastStackView.topAnchor.constraint(equalTo: self.topAnchor),
            forecastStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            forecastStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 10),
            forecastStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -10)
        ])
    }
    
    
    
    
    
}
