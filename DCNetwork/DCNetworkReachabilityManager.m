//
//  DCNetworkReachabilityManager.m
//  Pods
//
//  Created by quanzhizu on 2017/11/3.
//
//

#import "DCNetworkReachabilityManager.h"

@interface DCNetworkReachabilityManager()

@property (readwrite, nonatomic, assign) AFNetworkReachabilityStatus networkReachabilityStatus;
@property (readwrite, nonatomic, strong) NSString *networkStatu;

@end

@implementation DCNetworkReachabilityManager



+ (id)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}


-(void)setNetworkReachability{
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                self.networkReachabilityStatus = AFNetworkReachabilityStatusReachableViaWWAN;
                self.networkStatu = @"WWAN";
                NSLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.networkReachabilityStatus = AFNetworkReachabilityStatusReachableViaWiFi;
                NSLog(@"WIFI");
                self.networkStatu = @"WiFi";
                break;
            case AFNetworkReachabilityStatusNotReachable:
               
                self.networkReachabilityStatus = AFNetworkReachabilityStatusNotReachable;
                self.networkStatu = @"网络断开";
                NSLog(@"没有网络(断网)");
                break;
            case AFNetworkReachabilityStatusUnknown:
                self.networkReachabilityStatus = AFNetworkReachabilityStatusUnknown;
                self.networkStatu = @"未知网络";
                NSLog(@"未知网络");
                break;
            default:
                break;
            }} ];
    
}

-(void)setNetworkReachabilityStatus:(AFNetworkReachabilityStatus)networkReachabilityStatus{
    _networkReachabilityStatus = networkReachabilityStatus;
    
    [self.netChangeSignal sendNext:@(networkReachabilityStatus)];
}


- (RACSubject *)netChangeSignal{
    if (NULL == _netChangeSignal) {
        _netChangeSignal = [RACSubject subject];
    }
    return _netChangeSignal;
}

     
@end
