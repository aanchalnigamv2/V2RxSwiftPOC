//
//  Weather.h
//  V2RxSwiftPOC
//
//  Created by aanchal on 09/05/16.
//  Copyright © 2016 aanchal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherForecast.h"

@interface Weather : NSObject

@property(weak,nonatomic) NSString *city;
@property(weak,nonatomic) WeatherForecast *weatherForecast;

-(id)initWithData:(NSDictionary *)weatherDict;

@end
