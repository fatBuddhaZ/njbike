//
//  IndexViewController.m
//  njbike
//
//  Created by suny on 13-4-22.
//  Copyright (c) 2013年 suny. All rights reserved.
//

#import "IndexViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface IndexViewController ()

@end

@implementation IndexViewController
@synthesize ico = _ico,today=_today,weather=_weather,temperature=_temperature,map=_map;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CALayer * layer = [_ico layer];
    layer.borderColor = [
                         [UIColor whiteColor] CGColor];
    layer.borderWidth = 2.0f;
    [layer setCornerRadius:10.0]; 
    UIImage *img = [UIImage imageNamed:@"ico.png"];
    
    _ico.contentMode=UIViewContentModeScaleAspectFit;
    _ico.clipsToBounds = YES;
    [_ico setImage:img];
    
    //天气
    NSDictionary* weatherXml = [IndexViewController getWeatherXmlForZipCode:@"101190101"];
    
    _today.text = [weatherXml objectForKey:@"date_y"];
    _weather.text=[weatherXml objectForKey:@"weather1"];
    _temperature.text=[weatherXml objectForKey:@"temp1"];
    
    //地图
     myMapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, 280, 170)];
     myMapView.mapType = MAMapTypeStandard;
    
    CLLocationCoordinate2D center = {39.91669,116.39716};
    MACoordinateSpan span = {0.04,0.03};
    MACoordinateRegion region = {center,span};
    [myMapView setRegion:region animated:NO];
    CALayer * layer2 = [_map layer];
    layer2.borderColor = [
                         [UIColor whiteColor] CGColor];
    layer2.borderWidth = 4.0f;
    
    [_map addSubview:myMapView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(NSDictionary*)getWeatherXmlForZipCode: (NSString*)zipCode {
    NSError *error;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"http://m.weather.com.cn/data/%@.html", zipCode]]];
    NSData *dataResponse = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    NSDictionary *dictionaryWeather = [NSJSONSerialization JSONObjectWithData: dataResponse options: NSJSONReadingMutableLeaves error: &error];
    NSDictionary *dictionaryWeatherInfo = [dictionaryWeather objectForKey: @"weatherinfo"];
    return dictionaryWeatherInfo;
}

@end
