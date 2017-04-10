//
//  DCHTTPResponseSerializer.m
//  DCNetwork
//
//  Created by quanzhizu on 2017/4/8.
//  Copyright © 2017年 quanzhizud2c. All rights reserved.
//

#import "DCHTTPResponseSerializer.h"

@implementation DCHTTPResponseSerializer

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/xml", nil];
    return self;
}


- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error {
    
    id responseObject = nil;
    NSError *serializationError = nil;
    
    
    BOOL isSpace = [data isEqualToData:[NSData dataWithBytes:" " length:1]];
    if (data.length > 0 && !isSpace) {
        if ([response.MIMEType isEqualToString:@"application/json"] ||
            [response.MIMEType isEqualToString:@"text/json"]) {
            responseObject = [self JSONObjectWithData:data error:&serializationError];
        }
        else if ([response.MIMEType isEqualToString:@"text/javascript"]) {
            responseObject = [self JSONObjectWithData:data error:&serializationError];
        }
    }
    else {
        return nil;
    }
    
    
    if (error && serializationError) {
        NSMutableDictionary *mutableUserInfo = [serializationError.userInfo mutableCopy];
        mutableUserInfo[NSUnderlyingErrorKey] = *error;
        *error = [[NSError alloc] initWithDomain:serializationError.domain code:serializationError.code userInfo:mutableUserInfo];
    }
    
    return responseObject;
    
}

- (id)JSONObjectWithData:(NSData *)data error:(NSError **)error {
    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:error];
    if (*error) {
        NSMutableString *JSONString = [NSMutableString stringWithUTF8String:data.bytes];
        if ([JSONString hasPrefix:@"seasonListCallback("]) {
            [JSONString deleteCharactersInRange:NSMakeRange(0, @"seasonListCallback(".length)];
            [JSONString deleteCharactersInRange:NSMakeRange(JSONString.length-2, @");".length)];
            data = [NSData dataWithBytes:JSONString.UTF8String length:[JSONString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
            *error = NULL;
            responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:error];
        }
    }
    return responseObject;
}

@end
