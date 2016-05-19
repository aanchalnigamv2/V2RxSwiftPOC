//
//  WeatherViewModel.swift
//  V2RxSwiftPOC
//
//  Created by aanchal on 09/05/16.
//  Copyright © 2016 aanchal. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SwiftyJSON
import Alamofire

extension NSDate {
    var dayString:String {
        let formatter = NSDateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("d M")
        return formatter.stringFromDate(self)
    }
}

class WeatherViewModel {
    
    struct Constants {
        static let baseURL = "http://api.openweathermap.org/data/2.5/forecast?q="
        static let urlExtension = "&units=metric&type=like&APPID=6a700a1e919dc96b0a98901c9f4bec47"
        static let baseImageURL = "http://openweathermap.org/img/w/"
        static let imageExtension = ".png"
    }
    
    var cityName = PublishSubject<String?>()
    var degrees = PublishSubject<String?>()
    var weatherDescription = PublishSubject<String?>()
    private var forecast:[AnyObject]?
    var weatherImage = PublishSubject<UIImage?>()
    var disposeBag = DisposeBag()
    var errorAlertController = PublishSubject<UIAlertController>()
    
    var observableLanguageArray = PublishSubject<[AnyObject]>()
  
    var weather: Weather? {
        didSet {
            if weather?.city != nil {
                updateModel()
            }
        }
    }
    
    func updateModel() {
        cityName.on(.Next(weather?.city))
        
        if let temp = weather?.currentWeather.temp {
            degrees.on(.Next(String(temp)))
        }
        
        weatherDescription.on(.Next(weather?.currentWeather.desc))
        
        if let id = weather?.currentWeather.imageID {
            setWeatherImageForImageID(id)
        }
        
        forecast = weather!.cityDetailArray as [AnyObject]
        if forecast != nil {
            sendTableViewData()
        }
        
      
       /* observableLanguageArray.on(.Next(Array(arrayLiteral: (weather?.languageArray)!)))
        if let temp = weather?.weatherForecast?.temp {
            degrees.on(.Next(String(temp)))
        }
        if let weatherDesc = weather?.weatherForecast?.desc {
            weatherDescription.on(.Next(String(weatherDesc)))
        }
        forecast = (weather?.weatherArray)! as NSArray as? [String]
        if forecast != nil {
            sendTableViewData()
        }*/
    }
    
    func setWeatherImageForImageID(imageID: String) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            if let url = NSURL(string: Constants.baseImageURL + imageID + Constants.imageExtension) {
                if let data = NSData(contentsOfURL: url) {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.weatherImage.on(.Next(UIImage(data: data)))
                    }
                }
            }
        }
    }
    
    func sendTableViewData() {
        if let currentForecast = forecast {
            var dailyForecast = [[WeatherForecast]]()
            var days = [String]()
            days.append(NSDate(timeIntervalSinceNow: 0).dayString)
        }
    }
    
    var searchText:String? {
        didSet {
            if let text = searchText {
                let urlString = Constants.baseURL + text.stringByReplacingOccurrencesOfString(" ", withString: "%20") + Constants.urlExtension
                getWeatherForRequest(urlString)
            }
        }
    }
    
    func getWeatherForRequest(urlString: String) {
        Alamofire.request(Method.GET, urlString).rx_responseJSON()
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { json in
                    let jsonForValidation = JSON(json)
                    if let error = jsonForValidation["message"].string {
                        print("got error \(error)")
                        self.postError("Error", message: error)
                        return
                    }
                    self.weather = Weather(data: json as! [NSObject : AnyObject])
                    
                },
                onError: { error in
                    print("Got error")
                    let gotError = error as NSError
                    
                    print(gotError.domain)
                    self.postError("\(gotError.code)", message: gotError.domain)
            })
            .addDisposableTo(disposeBag)
    }
    
    func postError(title: String, message: String) {
        errorAlertController.on(.Next(UIAlertController(title: title, message: message, preferredStyle: .Alert)))
    }
}