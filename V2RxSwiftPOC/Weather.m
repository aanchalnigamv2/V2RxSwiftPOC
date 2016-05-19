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
        self.weatherArray = [[NSArray alloc]init];
        self.cityDetailArray = [[NSMutableArray alloc]init];
        self.currentWeather = [[WeatherForecast alloc]init];
        
        self.weatherArray = [weatherDict objectForKey:@"list"];
        self.city = [[weatherDict objectForKey:@"city"] valueForKey:@"name"];
        self.currentWeather.temp = [[[self.weatherArray objectAtIndex:0] objectForKey:@"main"] valueForKey:@"temp"];
        self.currentWeather.imageID = [[[[self.weatherArray objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] valueForKey:@"icon"];
        self.currentWeather.desc = [[[[self.weatherArray objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] valueForKey:@"description"];
        NSString * weatherDate;
        
        for (NSDictionary *weatherDictionary in self.weatherArray) {
            WeatherForecast *weatherForecast = [[WeatherForecast alloc]init];
            weatherForecast.temp = [[weatherDictionary objectForKey:@"main"] valueForKey:@"temp"];
           weatherDate = [weatherDictionary valueForKey:@"dt"];
            weatherForecast.date = [NSDate dateWithTimeIntervalSince1970:(weatherDate.doubleValue)];
            weatherForecast.imageID = [[[weatherDictionary objectForKey:@"weather"] objectAtIndex:0] valueForKey:@"icon"];
            weatherForecast.desc = [[[weatherDictionary objectForKey:@"weather"] objectAtIndex:0] valueForKey:@"description"];
            [self.cityDetailArray addObject:weatherForecast];
        }
        NSLog(@"City Details : %@", self.cityDetailArray);
    }
    return self;
}

@end

/*        self.weatherForecast.temp = [[[[weatherDict objectForKey:@"list"] objectAtIndex:0] objectForKey:@"main"] valueForKey:@"temp"];
        self.weatherForecast.date = [[[weatherDict objectForKey:@"list"] objectAtIndex:0] valueForKey:@"dt"];
        self.weatherForecast.imageID = [[[[[weatherDict objectForKey:@"list"] objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] valueForKey:@"icon"];
        self.weatherForecast.desc = [[[[[weatherDict objectForKey:@"list"] objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] valueForKey:@"description"];

        self.languageArray = [[NSMutableArray alloc]initWithObjects:@"ObjectiveC", @"Swift", @"Java", nil];
*/
