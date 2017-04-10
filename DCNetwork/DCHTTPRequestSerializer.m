//
//  DCHTTPRequestSerializer.m
//  DCNetwork
//
//  Created by quanzhizu on 2017/4/8.
//  Copyright © 2017年 quanzhizud2c. All rights reserved.
//

#import "DCHTTPRequestSerializer.h"

@implementation DCHTTPRequestSerializer
- (instancetype)init {
    if (self = [super init]) {
        __weak typeof(self) weakself = self;
        [self setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
            return [weakself queryStringSerialization:request parameters:parameters error:error];
        }];
    }
    return self;
}

- (NSString *)queryStringSerialization:(NSURLRequest *)request parameters:(id)parameters error:(NSError *__autoreleasing *)error {
    NSArray* (^DictToArray)(NSDictionary *dictionary) = ^(NSDictionary *dictionary) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:dictionary.count];
        for (NSObject *key in dictionary.allKeys) {
            [array addObject:[NSString stringWithFormat:@"%@=%@", key, [dictionary objectForKey:key]]];
        }
        return [NSArray arrayWithArray:array];
    };
    NSString *(^ArrayToString)(NSArray *array) = ^(NSArray *array) {
        return [array componentsJoinedByString:@"&"];
    };
    
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = parameters;
        if (dict.count == 0) {
            return NULL;
        }
        return ArrayToString(DictToArray(parameters));
    }
    else if ([parameters isKindOfClass:[NSArray class]]) {
        NSArray *array = parameters;
        if (array.count == 0) {
            return NULL;
        }
        return ArrayToString(parameters);
    }
    else if ([parameters isKindOfClass:[NSString class]]) {
        return parameters;
    }
    else {
        return NULL;
    }
}
@end
