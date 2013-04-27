//
//  IndexViewController.m
//  njbike
//
//  Created by suny on 13-4-22.
//  Copyright (c) 2013年 suny. All rights reserved.
//

#import "IndexViewController.h"


@interface IndexViewController ()
@end

@implementation IndexViewController
@synthesize ico = _ico,today=_today,weather=_weather,temperature=_temperature,map=_map,stratTime=_stratTime,endBtu=_endBtu,endTime=_endTime,overlays = _overlays;


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
    _map.frame=self.view.bounds;
        
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
     _map.delegate = self;
    //地图
   // _map.showsUserLocation = YES;
   // _map.userTrackingMode  = MAUserTrackingModeFollow;
   // _map.mapType = MAMapTypeStandard;
   // _map.delegate = self;
    //CLLocationCoordinate2D currentLocation = {39.855539,116.419037};
    _map.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
   // MACoordinateSpan span = {0.04,0.03};
    //MACoordinateRegion region = {currentLocation,span};
    //[_map setRegion:region];
    
    //画线
    [self initOverlay];

    [_map addOverlays:_overlays];
}
#pragma mark - Initialization

- (void)initOverlay
{
    _overlays = [NSMutableArray array];
    CLLocationCoordinate2D polylineCoords[2];
    polylineCoords[0].latitude = 39.855539;
    polylineCoords[0].longitude = 116.419037;
    
    polylineCoords[1].latitude = 39.858172;
    polylineCoords[1].longitude = 116.520285;
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:polylineCoords count:2];
    [_overlays insertObject:polyline atIndex:0];
}
#pragma mark - MAMapViewDelegate
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth   = 8.f;
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
        
        return polylineView;
    }
        return nil;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
{
    if (userLocation != nil) {
        CLLocationCoordinate2D currentLocation = {userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude};
        
        MACoordinateSpan span = {0.04,0.03};
        MACoordinateRegion region = {currentLocation,span};
        [mapView setRegion:region];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)startRiding:(id)sender {
    NSDate* date = [NSDate date];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"HH:MM:SS"];
    
    NSString* str = [formatter stringFromDate:date];
    _stratTime.text=str;
    [_endBtu setHidden:NO];
    [sender setHidden:YES];
}

- (IBAction)endRiding:(id)sender {
    NSDate* date = [NSDate date];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"HH:MM:SS"];
    
    NSString* str = [formatter stringFromDate:date];
    _endTime.text=str;
    
    //会话ge
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"给你的旅程起个名字吧" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alert show];
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self performSegueWithIdentifier:@"record" sender:self];
}



+(NSDictionary*)getWeatherXmlForZipCode: (NSString*)zipCode {
    NSError *error;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"http://m.weather.com.cn/data/%@.html", zipCode]]];
    NSData *dataResponse = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    NSDictionary *dictionaryWeather = [NSJSONSerialization JSONObjectWithData: dataResponse options: NSJSONReadingMutableLeaves error: &error];
    NSDictionary *dictionaryWeatherInfo = [dictionaryWeather objectForKey: @"weatherinfo"];
    return dictionaryWeatherInfo;
}

#pragma mark - Life Cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initOverlay];
    }
    
    return self;
}

@end
