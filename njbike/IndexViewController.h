//
//  IndexViewController.h
//  njbike
//
//  Created by suny on 13-4-22.
//  Copyright (c) 2013年 suny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "MAMapKit.h"

@interface IndexViewController : UIViewController<MAMapViewDelegate>
{
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) IBOutlet UIImageView *ico;

@property (strong, nonatomic) IBOutlet UILabel *today;
@property (strong, nonatomic) IBOutlet UILabel *weather;
@property (strong, nonatomic) IBOutlet UILabel *temperature;
@property (strong, nonatomic) IBOutlet MAMapView *map;

- (IBAction)startRiding:(id)sender;
- (IBAction)endRiding:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *stratTime;
@property (strong, nonatomic) IBOutlet UILabel *endTime;
@property (strong, nonatomic) IBOutlet UIButton *endBtu;

@property (nonatomic, strong) NSMutableArray *overlays;


+(NSDictionary*)getWeatherXmlForZipCode: (NSString*)zipCode;

@end
