//
//  DCRequestCache.h
//  DCNetwork
//
//  Created by quanzhizu on 2017/4/8.
//  Copyright © 2017年 quanzhizud2c. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DCRequest;

@interface DCRequestCache : NSObject

/**
 *  存储数据的硬盘目录路径
 */
@property (strong, nonatomic, readonly) NSString *storeCachePath;
/**
 *  当前缓存的字节
 */
@property(assign, nonatomic, readonly) NSUInteger cacheSize;



+ (instancetype)sharedInstance;


/**
 *  存储数据
 *
 *  @param request <#request description#>
 */
- (void)storeCachedJSONObjectForRequest:(DCRequest *)request;
/**
 *  获取缓存数据
 *
 *  @param request   <#request description#>
 *  @param isTimeout <#isTimeout description#>
 *
 *  @return <#return value description#>
 */
- (NSObject *)cachedJSONObjectForRequest:(DCRequest *)request isTimeout:(BOOL *)isTimeout;
/**
 *  移除缓存
 *
 *  @param request <#request description#>
 */
- (void)removeCachedJSONObjectForRequest:(DCRequest *)request;

/**
 *  存储数据
 *
 *  @param cachedData 数据
 *  @param path       路径
 */
- (void)storeCachedData:(NSData *)cachedData ForPath:(NSString *)path;
/**
 *  获取缓存数据
 *
 *  @param path            缓存路径
 *  @param timeoutInterval 缓存超时时间
 *  @param isTimeout       是否超时
 *
 *  @return <#return value description#>
 */
- (NSData *)cachedDataForPath:(NSString *)path TimeoutInterval:(NSTimeInterval)timeoutInterval IsTimeout:(BOOL *)isTimeout;
/**
 *  移除缓存
 *
 *  @param path 缓存路径
 */
- (void)removeCachedDataForPath:(NSString *)path;

/**
 *  移除所有缓存
 */
- (void)removeAllCachedData;


@end
