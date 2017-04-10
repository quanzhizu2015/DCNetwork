//
//  DCBaseRequest.m
//  DCNetwork
//
//  Created by quanzhizu on 2017/4/8.
//  Copyright © 2017年 quanzhizud2c. All rights reserved.
//

#import "DCBaseRequest.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <objc/message.h>


@interface DCBaseRequest ()

@property (weak, nonatomic) UIView *loadingInView;

@property (strong, nonatomic) MBProgressHUD *loadingView;

@end


@implementation DCBaseRequest

- (DCBaseRequest *)startWithCompletionBlock:(DCBaseRequestBlock)completionBlock {
    return [super startWithCompletionBlock:completionBlock];
}

- (NSInteger)responseStatusCode {
    return [[self.responseObject objectForKey:@"status"] integerValue];
}
- (NSDictionary *)responseData {
    return [self.responseObject objectForKey:@"data"];
}
- (NSString *)errorMsg {
    if (self.error) {
        return self.error.description;
    }
    else {
        return [self.responseObject objectForKey:@"msg"];
    }
}


+ (instancetype)requestWithLoadingInView:(UIView *)loadingInView {
    DCBaseRequest *request = [super request];
    request.loadingInView = loadingInView;
    return request;
}

- (MBProgressHUD *)loadingView {
    if (_loadingInView && !_loadingView) {
        _loadingView = [[MBProgressHUD alloc] initWithView:_loadingInView];
        _loadingView.removeFromSuperViewOnHide = YES;
        [_loadingInView addSubview:_loadingView];
    }
    return _loadingView;
}

- (void)willStart {
    [super willStart];
    
    if ([self.loadingView respondsToSelector:NSSelectorFromString(@"showAnimated:")]) {
        ((void (*)(id, SEL, BOOL))objc_msgSend)(self.loadingView, NSSelectorFromString(@"showAnimated:"), YES);
    }
    else if ([self.loadingView respondsToSelector:NSSelectorFromString(@"show:")]) {
        ((void (*)(id, SEL, BOOL))objc_msgSend)(self.loadingView, NSSelectorFromString(@"show:"), YES);
    }
}

- (void)completed {
    [super completed];
    
    if ([self.loadingView respondsToSelector:NSSelectorFromString(@"hideAnimated:")]) {
        ((void (*)(id, SEL, BOOL))objc_msgSend)(self.loadingView, NSSelectorFromString(@"hideAnimated:"), YES);
    }
    else if ([self.loadingView respondsToSelector:NSSelectorFromString(@"hide:")]) {
        ((void (*)(id, SEL, BOOL))objc_msgSend)(self.loadingView, NSSelectorFromString(@"hide:"), YES);
    }
    
    _loadingView = NULL;
}

- (BOOL)nextPage {
    if (!self.hasNext) {
        return NO;
    }
    if (![self.parameters isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)self.parameters];
    [mutableDict setObject:@(self.index + 1) forKey:@"p"];
    self.parameters = mutableDict;
    return YES;
}

- (NSInteger)index {
    NSDictionary *pageDict = self.pageDict;
    NSNumber *index = [pageDict objectForKey:@"index"];
    if (!index) {
        return -1;
    }
    return [index integerValue];
}

- (BOOL)hasNext {
    NSDictionary *pageDict = self.pageDict;
    NSNumber *next = [pageDict objectForKey:@"next"];
    if (!next) {
        return NO;
    }
    return [next boolValue];
}

- (NSDictionary *)pageDict {
    if (!self.responseObject) {
        return NULL;
    }
    else if (![self.responseObject isKindOfClass:[NSDictionary class]]) {
        return NULL;
    }
    else if ([self.pageKeyPath length] == 0) {
        return NULL;
    }
    return [self.responseObject valueForKeyPath:self.pageKeyPath];
}

- (NSString *)pageKeyPath {
    if (!_pageKeyPath) {
        NSMutableArray *keyPath = [NSMutableArray array];
        BOOL result = [self analysisKeyPath:@"next" forDict:self.responseObject keyPath:keyPath];
        if (result) {
            _pageKeyPath = [keyPath componentsJoinedByString:@"."];
        }
        else {
            _pageKeyPath = @"";
        }
    }
    return _pageKeyPath;
}

- (BOOL)analysisKeyPath:(NSString *)flag forDict:(NSDictionary *)dict keyPath:(NSMutableArray *)keyPath {
    for (NSString *key in [dict allKeys]) {
        id value = [dict objectForKey:key];
        if ([key isEqualToString:flag]) {
            return YES;
        }
        if ([value isKindOfClass:[NSDictionary class]]) {
            [keyPath addObject:key];
            BOOL result = [self analysisKeyPath:flag forDict:value keyPath:keyPath];
            if (result) {
                return  result;
            }
        }
    }
    [keyPath removeLastObject];
    return NO;
}


@end
