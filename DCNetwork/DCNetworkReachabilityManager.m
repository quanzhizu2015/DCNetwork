//
//  DCNetworkReachabilityManager.m
//  Pods
//
//  Created by quanzhizu on 2017/11/3.
//
//

#import "DCNetworkReachabilityManager.h"

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
                
                NSLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
                NSLog(@"WIFI");
                break;
            case AFNetworkReachabilityStatusNotReachable:
               
                
                NSLog(@"没有网络(断网)");
                break;
            case AFNetworkReachabilityStatusUnknown:
                
                NSLog(@"未知网络");
                break;
            default:
                break;
            }} ];
    
}

-(void)setNetworkReachabilityStatus:(AFNetworkReachabilityStatus)networkReachabilityStatus{
    _networkReachabilityStatus = networkReachabilityStatus;
   

- (RACSubject *)netChangeSignal{
    if (NULL == _netChangeSignal) {
        _netChangeSignal = [RACSubject subject];
    }
    return _netChangeSignal;
}
     
@end
