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
        self.weatherForecast = [[WeatherForecast alloc]init];
        self.city = [[weatherDict objectForKey:@"city"] valueForKey:@"name"];
        self.weatherForecast.temp = [[[[weatherDict objectForKey:@"list"] objectAtIndex:0] objectForKey:@"main"] valueForKey:@"temp"];
        self.weatherForecast.date = [[[weatherDict objectForKey:@"list"] objectAtIndex:0] valueForKey:@"dt"];
        self.weatherForecast.imageID = [[[[[weatherDict objectForKey:@"list"] objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] valueForKey:@"icon"];
        self.weatherForecast.desc = [[[[[weatherDict objectForKey:@"list"] objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] valueForKey:@"description"];
        
        self.languageArray = [[NSMutableArray alloc]initWithObjects:@"Objective-C", @"Swift", @"Java", nil];
    }
    return self;
}

@end
