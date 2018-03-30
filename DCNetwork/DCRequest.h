//
//  DCRequest.h
//  DCNetwork
//
//  Created by quanzhizu on 2017/4/8.
//  Copyright © 2017年 quanzhizud2c. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCRequestCache.h"
#import "DCRequestHandler.h"


/// 请求优先级
typedef NS_ENUM(NSInteger, ESRequestPriority) {
    ESRequestPriorityDefault,
    ESRequestPriorityLow,
    ESRequestPriorityHigh
};

@class DCRequest;

typedef void (^DCRequestBlock)(__kindof DCRequest *request);

@protocol DCRequestDelegate <NSObject>

/**
 *  请求完成后回调
 *
 *  @param request <#request description#>
 */
- (void)requestCompletion:(__kindof DCRequest *)request;

@end

@interface DCRequest : NSObject
<DCRequestHandlerDelegate>

@property (copy, nonatomic) NSString *URLString;
@property (copy, nonatomic) NSObject *parameters;
@property (strong, nonatomic, readonly) NSDictionary<NSString *, NSString *> *headers;
@property (copy, nonatomic) NSDictionary *body;
//保存第一次请求参数
@property (copy, nonatomic) NSObject *orginParameters;
@property (assign, nonatomic) DCHTTPMethod method;


/**
 请求优先级，默认ESRequestPriorityDefault
 */
@property (assign, nonatomic) ESRequestPriority priority;


/**
 内置的请求头是否有效，默认YES
 */
@property (assign, nonatomic) BOOL builtinHeaderEnable;
/**
 内置的参数是否有效，默认YES
 */
@property (assign, nonatomic) BOOL builtinParameterEnable;


@property (assign, nonatomic) BOOL mustFromNetwork;
@property (readonly) NSURLSessionTaskState state;
@property (assign, nonatomic) NSInteger tag;
@property (strong, nonatomic, readonly) NSURLSessionTask *task;


#pragma mark Cache

/**
 *  缓存时间，0不缓存
 */
@property (assign, nonatomic) NSTimeInterval cacheTimeoutInterval;
/**
 *  缓存-组名称 默认MD5(URLString)
 */
@property (copy, nonatomic, readonly) NSString *groupName;
/**
 *  缓存-标识  MD5(URLString+parameters)
 */
@property (copy, nonatomic, readonly) NSString *identifier;
/**
 数据从缓存中读取
 */
@property (assign, nonatomic, readonly, getter=isDataFromCache) BOOL dataFromCache;


#pragma mark Response
@property (strong, nonatomic, readonly) NSHTTPURLResponse *response;
@property (strong, nonatomic, readonly) id responseObject;
@property (strong, nonatomic, readonly) NSError *error;


#pragma mark Callback

@property (weak, nonatomic) id<DCRequestDelegate> delegate;
/**
 *  请求完成后会释放
 */
@property (copy, nonatomic) DCRequestBlock completionBlock;



+ (instancetype)request;


- (__kindof DCRequest *)startWithDelegate:(id<DCRequestDelegate>)delegate;

- (__kindof DCRequest *)startWithCompletionBlock:(DCRequestBlock)completionBlock;

- (__kindof DCRequest *)start;

- (__kindof DCRequest *)stop;


- (void)willStart __attribute__((objc_requires_super));

- (void)completed __attribute__((objc_requires_super));

- (void)setValue:(NSString *)value forHeaderField:(NSString *)field;

@end
