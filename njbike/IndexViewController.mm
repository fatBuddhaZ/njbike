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
@synthesize ico = _ico,today=_today,weather=_weather,temperature=_temperature,myMapView=_myMapView,stratTime=_stratTime,endBtu=_endBtu,endTime=_endTime,overlays = _overlays;


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
<<<<<<< HEAD
    _map = [[MAMapView alloc] initWithFrame:CGRectMake(10, 80, 300, 200)];
=======
    _map = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    _map.delegate = self;
    //地图
    _map.showsUserLocation = YES;
    [_myMapView addSubview:_map];
    
>>>>>>> 修改缩放值
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //设置logo
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
<<<<<<< HEAD
     _map.delegate = self;
    //地图
   // _map.showsUserLocation = YES;
   // _map.userTrackingMode  = MAUserTrackingModeFollow;
   // _map.mapType = MAMapTypeStandard;
   // _map.delegate = self;
    //CLLocationCoordinate2D currentLocation = {39.855539,116.419037};
   // _map.visibleMapRect = MAMapRectMake(10,200,300,200);
   // MACoordinateSpan span = {0.04,0.03};
    //MACoordinateRegion region = {currentLocation,span};
    //[_map setRegion:region];
    
    //画线
    [self initOverlay];

    [_map addOverlays:_overlays];
    [self.view addSubview:_map];
=======
    
    
    
>>>>>>> 修改缩放值
}
#pragma mark - Initialization

- (void)initOverlay:(CLLocationCoordinate2D)coordinate
{
    _overlays = [NSMutableArray array];
    CLLocationCoordinate2D polylineCoords[2];
    polylineCoords[0]=coordinate;
    
    polylineCoords[1].latitude = coordinate.latitude+0.01;
    polylineCoords[1].longitude = coordinate.longitude+0.01;
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:polylineCoords count:2];
    [_overlays insertObject:polyline atIndex:0];
}
#pragma mark - MAMapViewDelegate
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth   = 2.f;
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
        
        return polylineView;
    }
        return nil;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
{
    CLLocationCoordinate2D location=userLocation.location.coordinate;
   /* if (userLocation != nil) {
        
        CLLocationCoordinate2D currentLocation = {userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude};
        //画线
        [self initOverlay:currentLocation];
        
        MACoordinateSpan span = {0.05,0.05};
        MACoordinateRegion region = {currentLocation,span};
        [mapView setRegion:region];
        [_map addOverlays:_overlays];
    */
    //CLLocationCoordinate2D location=userLocation.location.coordinate;
    

   // MACoordinateSpan span = [mapView coordinateSpanWithMapView:mapView centerCoordinate:userLocation andZoomLevel:18];
    
  //  span.latitudeDelta=0.3;
   // span.longitudeDelta=0.2;
    //MACoordinateRegion rrr = MACoordinateRegionMake(location, span);
   // [mapView setRegion:rrr animated:NO];
    [mapView setCenterCoordinate:location];
    [mapView setRegion:MACoordinateSpanMake(0.3,0.2)];
    //[mapView setShowsUserLocation:YES];
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


@end
