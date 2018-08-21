//
//  DCRequest.m
//  DCNetwork
//
//  Created by quanzhizu on 2017/4/8.
//  Copyright © 2017年 quanzhizud2c. All rights reserved.
//

#import "DCRequest.h"




#import <CommonCrypto/CommonDigest.h>

NSString * __MD5(NSString *str);

@interface DCRequest ()


@end

@implementation DCRequest

- (instancetype)init {
    if (self = [super init]) {
        _builtinHeaderEnable = YES;
        _builtinParameterEnable = YES;
        _offLineCache = NO;
        _priority = ESRequestPriorityDefault;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

+ (instancetype)request {
    return [[self alloc] init];
}

- (__kindof DCRequest *)startWithDelegate:(id<DCRequestDelegate>)delegate {
    _delegate = delegate;
    return [self start];
}

- (__kindof DCRequest *)startWithCompletionBlock:(DCRequestBlock)completionBlock {
    _completionBlock = completionBlock;
    return [self start];
}

- (__kindof DCRequest *)start {
    [self willStart];
    
    if ([self readCache]) {
        [self completed];
    }
    else {
        _task = [[DCRequestHandler sharedInstance] handleRequest:self];
    }
    return self;
}

- (DCRequest *)stop {
    [self.task cancel];
    return self;
}

- (NSURLSessionTaskState)state {
    return _task.state;
}


- (void)willStart {
    _dataFromCache = NO;
    _response = NULL;
    _responseObject = NULL;
    _error = NULL;
    _task = NULL;
}

- (void)completed {
    [self storeCache];
    [self readCacheOffLineCache];
    [self.delegate requestCompletion:self];
    !_completionBlock ?: _completionBlock(self);
    _completionBlock = NULL;
}

#pragma mark - RequestHandlerDelegate
- (void)requestHandleCompletionResponse:(NSHTTPURLResponse *)response responseObject:(id)responseObject error:(NSError *)error {
    _response = response;
    _responseObject = responseObject;
    _error = error;
    [self completed];
}

#pragma mark - Cache

- (NSString *)groupName {
    return __MD5(self.URLString);
}

- (NSString *)identifier {
    if (self.parameters) {
        return __MD5([self.URLString stringByAppendingString:self.parameters.description]);
    }
    else {
        return self.groupName;
    }
}

- (void)storeCache {
    if (_dataFromCache) {
        return;
    }
    if ((self.cacheTimeoutInterval <= 0 && !_offLineCache ) || !_responseObject) {
        return;
    }
    [[DCRequestCache sharedInstance] storeCachedJSONObjectForRequest:self];
}

- (BOOL)readCache {
    if (_mustFromNetwork) {
        return NO;
    }
    if (self.cacheTimeoutInterval) {
        return NO;
    }
    BOOL isTimeout;
    id cachedJSONObject = [[DCRequestCache sharedInstance] cachedJSONObjectForRequest:self isTimeout:&isTimeout];
    if (cachedJSONObject && !isTimeout) {
        _dataFromCache = YES;
        _responseObject = cachedJSONObject;
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)readCacheOffLineCache {
    if (_mustFromNetwork) {
        return NO;
    }
    if (!_offLineCache) {
        return NO;
    }
    if (_responseObject) {
        return NO;
    }
    BOOL isTimeout;
    id cachedJSONObject = [[DCRequestCache sharedInstance] cachedJSONObjectForRequest:self isTimeout:&isTimeout];
    if (cachedJSONObject && _offLineCache) {
        _dataFromCache = YES;
        _responseObject = cachedJSONObject;
        return YES;
    }
    else {
        return NO;
    }
}


- (void)setValue:(NSString *)value forHeaderField:(NSString *)field {
    if (!_headers) {
        _headers = [NSMutableDictionary dictionary];
    }
    [_headers setValue:value forKey:field];
}

@end



NSString * __MD5(NSString *str) {
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

