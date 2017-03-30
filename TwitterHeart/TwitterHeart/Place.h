//
//  Place.h
//  TwitterHeart
//
//  Created by vvlong on 2017/3/28.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Place : NSObject<MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
