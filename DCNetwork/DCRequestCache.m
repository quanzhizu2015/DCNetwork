//
//  DCRequestCache.m
//  DCNetwork
//
//  Created by quanzhizu on 2017/4/8.
//  Copyright © 2017年 quanzhizud2c. All rights reserved.
//

#import "DCRequestCache.h"

#import "DCRequest.h"

typedef void (^PathCallback)(NSString *path);


/**
 遍历目录
 
 @param path  <#path description#>
 @param block <#block description#>
 */
void traverseDirectory(NSString *path, PathCallback block);

@implementation DCRequestCache

- (NSUInteger)cacheSize; {
    __block NSUInteger size = 0;
    traverseDirectory(self.storeCachePath, ^(NSString *path) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSDictionary *dict = [[NSFileManager defaultManager] fileAttributesAtPath:path traverseLink:true];
#pragma clang diagnostic pop
        size += [[dict valueForKey:NSFileSize] integerValue];
    });
    return size;
}

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        NSString *cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        _storeCachePath = [cachesDirectory stringByAppendingString:@"/RequestCache"];
        [[NSFileManager defaultManager] createDirectoryAtPath:_storeCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return self;
}


#pragma mark request

- (void)storeCachedJSONObjectForRequest:(DCRequest *)request {
    NSData *cachedData = [NSJSONSerialization dataWithJSONObject:request.responseObject options:kNilOptions error:NULL];
    [self storeCachedData:cachedData ForPath:[self cachedPathForRequest:request]];
}

- (NSObject *)cachedJSONObjectForRequest:(DCRequest *)request isTimeout:(BOOL *)isTimeout {
    NSData *cachedData = [self cachedDataForPath:[self cachedPathForRequest:request] TimeoutInterval:request.cacheTimeoutInterval IsTimeout:isTimeout];
    if (cachedData) {
        return [NSJSONSerialization JSONObjectWithData:cachedData options:kNilOptions error:NULL];
    }
    else {
        return NULL;
    }
}

- (void)removeCachedJSONObjectForRequest:(DCRequest *)request {
    [self removeCachedDataForPath:[self cachedPathForRequest:request]];
}

- (NSString *)cachedPathForRequest:(DCRequest *)request {
    return [NSString stringWithFormat:@"%@/%@/%@", _storeCachePath, request.groupName, request.identifier];
}

- (void)removeCacheForGroup:(NSString *)groupName {
    
}


#pragma mark path

- (void)storeCachedData:(NSData *)cachedData ForPath:(NSString *)path {
    if (cachedData == NULL) {
        [self removeCachedDataForPath:path];
        return;
    }
    NSString *directoryPath = [path stringByDeletingLastPathComponent];
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if (!isDirectory) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:NULL error:NULL];
    }
    [cachedData writeToFile:path atomically:YES];
}

- (NSData *)cachedDataForPath:(NSString *)path TimeoutInterval:(NSTimeInterval)timeoutInterval IsTimeout:(BOOL *)isTimeout {
    if (![path length]) {
        return NULL;
    }
    NSData *cachedData = [[NSData alloc] initWithContentsOfFile:path];
    if (!cachedData) {
        return NULL;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] fileAttributesAtPath:path traverseLink:true];
#pragma clang diagnostic pop
    NSDate *fileModificationDate = [fileAttributes valueForKey:NSFileModificationDate];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:fileModificationDate];
    *isTimeout = (timeInterval > timeoutInterval);
    return cachedData;
}

- (void)removeCachedDataForPath:(NSString *)path {
    if (![path length]) {
        return;
    }
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}



#pragma mark remove

- (void)removeAllCachedData {
    [[NSFileManager defaultManager] removeItemAtPath:_storeCachePath error:NULL];
}

@end


void traverseDirectory(NSString *directorPath, PathCallback block) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager contentsOfDirectoryAtPath:directorPath error:nil];
    for (NSString *fileName in files) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", directorPath, fileName];
        BOOL flag = YES;
        [fileManager fileExistsAtPath:filePath isDirectory:&flag];
        if (flag) {
            traverseDirectory(filePath, block);
        }
        else {
            block(filePath);
        }
    }
}



