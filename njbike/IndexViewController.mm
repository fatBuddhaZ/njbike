//
//  IndexViewController.m
//  njbike
//
//  Created by suny on 13-4-22.
//  Copyright (c) 2013年 suny. All rights reserved.
//

#import "IndexViewController.h"
#import "MAGeometry.h"


@interface IndexViewController ()
{
   NSMutableArray *mapaintArray;
}
    

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
    //地图
    _map = [[MAMapView alloc] initWithFrame:CGRectMake(2, 2, 294, 148)];
    _map.mapType = MAMapTypeStandard;
    _map.showsUserLocation = YES;
    _map.delegate = self;
    mapaintArray = [NSMutableArray array];
    
    
    //设置logo边框
    CALayer * layer = [_ico layer];
    layer.borderColor = [
                         [UIColor whiteColor] CGColor];
    layer.borderWidth = 2.0f;
    [layer setCornerRadius:10.0];
    _ico.contentMode=UIViewContentModeScaleAspectFit;
    _ico.clipsToBounds = YES;
    
    //天气
    NSDictionary* weatherXml = [IndexViewController getWeatherXmlForZipCode:@"101190101"];
    
    _today.text = [weatherXml objectForKey:@"date_y"];
    _weather.text=[weatherXml objectForKey:@"weather1"];
    _temperature.text=[weatherXml objectForKey:@"temp1"];
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_myMapView addSubview:_map];
    [_ico setImage:[UIImage imageNamed:@"ico.png"]];
    
   

}


#pragma mark - Initialization

- (void)initOverlay:(CLLocationCoordinate2D)coordinate
{
    _overlays = [NSMutableArray array];
    
    
   // CGPoint point = [_map convertCoordinate:coordinate toPointToView:_myMapView];
    
    
  /*  CLLocationCoordinate2D polylineCoords[2];
    polylineCoords[0]=coordinate;
    
    
    
    polylineCoords[1].latitude = coordinate.latitude+0.01;
    polylineCoords[1].longitude = coordinate.longitude-0.01;
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:polylineCoords count:1];
    [_overlays insertObject:polyline atIndex:0];
   */
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
    mapView.region =  MACoordinateRegionMake(location,
                                            MACoordinateSpanMake(0.04, 0.06));
   
    
   MAMapPoint centerMapPoint = MAMapPointForCoordinate(location);
     
    //[mapaintArray addObject:point];
    mapView.showsUserLocation=NO;
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
