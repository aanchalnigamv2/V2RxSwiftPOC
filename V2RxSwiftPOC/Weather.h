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
@property(retain) WeatherForecast *weatherForecast;
@property(retain) NSMutableArray *languageArray;

-(id)updateValue:(NSDictionary *)weatherDict;

-(id)init;

@end
