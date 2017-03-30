//
//  ToAnimationViewController.m
//  TwitterHeart
//
//  Created by vvlong on 2017/3/28.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "ToAnimationViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Place.h"

@interface ToAnimationViewController ()<CLLocationManagerDelegate,NSURLSessionDataDelegate,NSURLSessionDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) CLLocation *previousPoint;
@property (nonatomic, assign) CLLocationDistance totalMovementDistance;
@property (nonatomic, strong) UILabel *latitudeLabel;
@property (nonatomic, strong) UILabel *longitudeLabel;
@property (nonatomic, strong) UILabel *altitudeLabel;
@end

@implementation ToAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor lightGrayColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 40, 60, 30)];
    [btn setBackgroundColor:[UIColor greenColor]];
    [btn setTitle:@"back" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(_close) forControlEvents:UIControlEventTouchUpInside];
    
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 500)];
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 500, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-500)];
    _contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
    title1.text = @"经度:";
    self.longitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 100, 20)];
    UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 100, 20)];
    title2.text = @"纬度:";
    self.latitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 50, 100, 20)];
    UILabel *title3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 100, 20)];
    title3.text = @"海拔:";
    self.altitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 90, 100, 20)];
    
    
    
    
    [_contentView addSubview:title1];
    [_contentView addSubview:title2];
    [_contentView addSubview:title3];
    [_contentView addSubview:_longitudeLabel];
    [_contentView addSubview:_latitudeLabel];
    [_contentView addSubview:_altitudeLabel];

    [self.view addSubview:_contentView];
    [self.view addSubview:self.mapView];
    [self.view addSubview:btn];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    //    设置精度
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1000;
    
    ///http://api.map.baidu.com/geocoder/v2/?callback=renderReverse&location=39.983424,116.322987&output=json&pois=1&ak=您的ak
///http://api.map.baidu.com/geocoder/v2/?address=北京市海淀区上地十街10号&output=json&ak=8MYZQtcF0STll8ah9irVIqzM8jpvfQAz&callback=showLocation
    [self.locationManager requestWhenInUseAuthorization];
    
}

- (void)getLocationInfo {
    NSURL *url =[NSURL URLWithString:@"http://api.map.baidu.com/geocoder/v2/?callback=renderReverse&location=39.983424,116.322987&output=json&pois=1&ak=8MYZQtcF0STll8ah9irVIqzM8jpvfQAz"];
    
//    NSURL *url =[NSURL URLWithString:@"http://api.map.baidu.com/geocoder/v2/?address=北京市海淀区上地十街10号&output=json&ak=8MYZQtcF0STll8ah9irVIqzM8jpvfQAz&callback=showLocation"];
    
    //创建session对象
    NSURLSession *session =[NSURLSession sharedSession];
//    __weak typeof(self)temp =self;
    //创建task（该方法内部默认使用get）直接进行传递url即可
    NSURLSessionDataTask *dataTask =[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //数据操作
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dic);
    }];
    //数据操作
    [dataTask resume];

}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"Authorization status changed to %d",status);
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self.locationManager startUpdatingLocation];
                dispatch_async(dispatch_get_main_queue(), ^{
                    _mapView.showsUserLocation = YES;
                });
            });
       
        }
            break;
            
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self.locationManager stopUpdatingLocation];
                dispatch_async(dispatch_get_main_queue(), ^{
                    _mapView.showsUserLocation = NO;
                });
            });
            
            break;
    }
}




- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = [locations lastObject];
    NSString *latitudeString = [NSString stringWithFormat:@"%g\u00B0",newLocation.coordinate.latitude];
    self.latitudeLabel.text = latitudeString;
    
    
    NSString *longitudeString = [NSString stringWithFormat:@"%g\u00B0",newLocation.coordinate.longitude];
    self.longitudeLabel.text = longitudeString;
    
    
//    NSString *horizontalAccuracyString = [NSString stringWithFormat:@"%gm",newLocation.horizontalAccuracy];
    //NSLog(@"horizontalAccuracyString%@",horizontalAccuracyString);
    
    NSString *altitudeString = [NSString stringWithFormat:@"%gm",newLocation.altitude];
    self.altitudeLabel.text = altitudeString;
    
    
//    NSString *verticalAccuracyString = [NSString stringWithFormat:@"%gm",newLocation.verticalAccuracy];
    //NSLog(@"verticalAccuracyString%@",verticalAccuracyString);
    
    if (newLocation.verticalAccuracy < 0 || newLocation.horizontalAccuracy < 0) {
//        无效的精度
        return;
    }
    if (newLocation.verticalAccuracy > 50 || newLocation.horizontalAccuracy > 100) {
//        精度过大
        return;
    }

    
    
    if (self.previousPoint == nil) {
        self.totalMovementDistance = 0;
        
        Place *start = [[Place alloc] init];
        start.coordinate = newLocation.coordinate;
        start.title = @"Start Point";
        start.subTitle = @"This is where we started!";
        [_mapView addAnnotation:start];
        MKCoordinateRegion region;
        region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1000, 1000);
        [_mapView  setRegion:region];
        
    } else {
        //NSLog(@"movement distance: %f", [newLocation distanceFromLocation:self.previousPoint]);
        self.totalMovementDistance += [newLocation distanceFromLocation:self.previousPoint];
    }
    
    self.previousPoint = newLocation;
    
}


- (void)_close {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSString *errorType = error.code == kCLErrorDenied ? @"Access Denied" : [NSString stringWithFormat:@"Error %ld",(long)error.code,nil];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Location Manager Error" message:errorType preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
