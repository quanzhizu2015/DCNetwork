//
//  DCNetworkReachabilityManager.h
//  Pods
//
//  Created by quanzhizu on 2017/11/3.
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface DCNetworkReachabilityManager : NSObject

-(void)setNetworkReachability;


@property (readonly, nonatomic, assign) AFNetworkReachabilityStatus networkReachabilityStatus;
@property (readonly, nonatomic, strong) NSString *networkStatu;
/**
 *  点击tabBar信号
 */
@property (strong, nonatomic) RACSubject   *netChangeSignal;


+ (id)sharedManager;

@end
