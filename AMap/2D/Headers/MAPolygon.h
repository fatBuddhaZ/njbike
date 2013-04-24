//
//  MAPolygon.h
//  MAMapKit
//
//  
//  Copyright (c) 2011年 Autonavi Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAMultiPoint.h"
#import "MAOverlay.h"

/// 此类用于定义一个由多个点组成的闭合多边形, 点与点之间按顺序尾部相连, 第一个点与最后一个点相连.
/// 通常MAPolygon是MAPolygonView的model
@interface MAPolygon : MAMultiPoint <MAOverlay>

/**
 *根据经纬度坐标数据生成闭合多边形
 *@param coords 经纬度坐标点数据,coords对应的内存会拷贝,调用者负责该内存的释放
 *@param count 经纬度坐标点数组个数
 *@return 新生成的多边形
 */
+ (MAPolygon *)polygonWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;

/**
 *根据map point数据生成多边形
 *@param points map point数据,points对应的内存会拷贝,调用者负责该内存的释放
 *@param count 点的个数
 *@return 新生成的多边形
 */
+ (MAPolygon *)polygonWithPoints:(MAMapPoint *)points count:(NSUInteger)count;

@end