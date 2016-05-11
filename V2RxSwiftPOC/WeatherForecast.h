//
//  WeatherForecast.h
//  V2RxSwiftPOC
//
//  Created by aanchal on 09/05/16.
//  Copyright © 2016 aanchal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherForecast : NSObject

@property(weak, nonatomic) NSDate *date;
@property(weak, nonatomic) NSString *imageID;
@property(assign, nonatomic) NSDecimalNumber *temp;
@property(weak, nonatomic) NSString *desc;

@end
