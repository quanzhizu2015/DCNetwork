//
//  DCRequestHandler.h
//  DCNetwork
//
//  Created by quanzhizu on 2017/4/8.
//  Copyright © 2017年 quanzhizud2c. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSInteger, DCHTTPMethod) {
    DCHTTPMethodGet,
    DCHTTPMethodPost,
};

@class DCRequest;

@protocol DCRequestHandlerDelegate <NSObject>

/**
 *  请求完成后回调
 *
 *  @param responseObject <#responseObject description#>
 *  @param error          <#error description#>
 */
- (void)requestHandleCompletionResponse:(NSHTTPURLResponse *)response responseObject:(id)responseObject error:(NSError *)error;

@end



@interface DCRequestHandler : NSObject

/**
 *  请求超时时间
 */
@property (assign, nonatomic) NSTimeInterval timeoutInterval;
/**
 *  请求Token
 */
@property (strong, nonatomic) NSString *accesstoken;
@property (strong, nonatomic) NSURL *baseURL;

@property (strong, nonatomic, readonly) NSDictionary<NSString *, id> *builtinParameters;
@property (strong, nonatomic, readonly) NSDictionary<NSString *, NSString *> *builtinHeaders;

+ (instancetype)sharedInstance;

- (NSURLSessionDataTask *)handleRequest:(DCRequest *)request;

- (void)setValue:(NSString *)value forBuiltinParameterField:(NSString *)field;
- (void)setValue:(NSString *)value forBuiltinHeaderField:(NSString *)field;
- (void)setCar:(NSString *)value ofType:(NSString *)type;
- (void)setValue:(NSString *)value forRequestContentType:(NSString *)type;
- (void)setValueforRespondContentType:(NSSet *)type;
@end
