//
//  IndexViewController.h
//  njbike
//
//  Created by suny on 13-4-22.
//  Copyright (c) 2013年 suny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAMapKit.h"

@interface IndexViewController : UIViewController
{
    MAMapView *myMapView; 
}

@property (strong, nonatomic) IBOutlet UIImageView *ico;

@property (strong, nonatomic) IBOutlet UILabel *today;
@property (strong, nonatomic) IBOutlet UILabel *weather;
@property (strong, nonatomic) IBOutlet UILabel *temperature;
 
@property (strong, nonatomic) IBOutlet UIView *map;

+(NSDictionary*)getWeatherXmlForZipCode: (NSString*)zipCode;

@end
