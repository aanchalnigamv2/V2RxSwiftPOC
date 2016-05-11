//
//  Weather.m
//  V2RxSwiftPOC
//
//  Created by aanchal on 09/05/16.
//  Copyright © 2016 aanchal. All rights reserved.
//

#import "Weather.h"

@implementation Weather

-(id)initWithData:(NSDictionary *)weatherDict {
    if (self = [super init]) {
        self.city = [[weatherDict objectForKey:@"city"] valueForKey:@"name"];
        self.weatherForecast.date = [[weatherDict objectForKey:@"dt"] objectForKey:@""];
        self.weatherForecast.imageID = [[[weatherDict objectForKey:@"weather"] objectAtIndex:0] valueForKey:@"icon"];
        self.weatherForecast.temp = [[weatherDict objectForKey:@"main"] valueForKey:@"temp"];
        self.weatherForecast.imageID = [[[weatherDict objectForKey:@"weather"] objectAtIndex:0] valueForKey:@"description"];
    }
    return self;
}

@end
