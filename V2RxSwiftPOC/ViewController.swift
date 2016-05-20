//
//  ViewController.swift
//  V2RxSwiftPOC
//
//  Created by aanchal on 09/05/16.
//  Copyright © 2016 aanchal. All rights reserved.
//

import UIKit
import Foundation
import RxCocoa
import RxSwift
import Alamofire


class ViewController: UIViewController, UIAlertViewDelegate {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var showCities: UILabel!
  
    let disposeBag = DisposeBag()
    var viewModel = WeatherViewModel()
    var weather = Weather()
    var boundToViewModel = false
    var array = [AnyObject]()
  
  //NOTE : This is a ViewModel array
  var pointToModelViewArray: ObservableArray<String> = ["foo", "bar", "buzz"]
  
  //NOTE : This is Model class array - from Objective C class
  var pointToObjectiveCArray = ObservableArray<NSMutableArray>()
  
    func bindSourceToLabel(source: PublishSubject<String?>, label: UILabel) {
        source
            .subscribeNext { text in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    label.text = text
                })
            }
            .addDisposableTo(disposeBag)
    }
  
  func bindArraySourceToLabel(source: PublishSubject<[AnyObject]>, label: UILabel) {
    source
      .subscribeNext { text in
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          label.text = "\(text)"
        })
      }
      .addDisposableTo(disposeBag)
  }
  
  
    var alertController: UIAlertController? {
        didSet {
            if let alertController = alertController {
                alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
      // NOTE : This array represent the objective c array in model class which we expected to be observable and respond on any change in it but it's not, our bad luck :(
      
      pointToObjectiveCArray.append(weather.languageArray)
      
      pointToObjectiveCArray.rx_elements().subscribeNext({print($0)})
      
      weather.languageArray.addObject("New Value")
      
      // NOTE : This array represent the modelView array and respond as expected
      
      pointToModelViewArray.rx_elements().subscribeNext { print($0) }
      
      pointToModelViewArray.append("coffee")
      
      
        cityTextField.rx_text
            .debounce(0.3, scheduler: MainScheduler.instance)
            
            .subscribeNext { searchText in
                self.viewModel.searchText = searchText
            }
            .addDisposableTo(disposeBag)
        
        
        bindSourceToLabel(viewModel.cityName, label: cityNameLabel)
        bindSourceToLabel(viewModel.degrees, label: tempLabel)
        bindSourceToLabel(viewModel.weatherDescription, label: descriptionLabel)
      
      
     
        
        viewModel.observableLanguageArray.subscribeNext { data in
            self.array = data
            print(self.array)
          
          for i in 0  ..< self.array.count  {
            self.showCities.text = self.showCities.text! + "\(self.array[i])"
          }
          
          

        }
        .addDisposableTo(disposeBag)
      
        viewModel.errorAlertController.subscribeNext { alertController in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.alertController = alertController
            })
        }
        .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  @IBAction func addCity(sender: AnyObject) {
    
    // adding value to viewModel array and working fine
    pointToModelViewArray.append("Test")
    
    // adding value to model class array and it's not responding
    weather.languageArray.addObject("change made")
  }

}

