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
    private var forecast:[String]?
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
        observableLanguageArray.on(.Next(Array(arrayLiteral: (weather?.languageArray)!)))
        if let temp = weather?.weatherForecast?.temp {
            degrees.on(.Next(String(temp)))
        }
        if let weatherDesc = weather?.weatherForecast?.desc {
            weatherDescription.on(.Next(String(weatherDesc)))
        }
//        forecast = (weather?.weatherArray)! as NSArray as? [String]
//        if forecast != nil {
//            sendTableViewData()
//        }
    }
    
    func sendTableViewData() {
        
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