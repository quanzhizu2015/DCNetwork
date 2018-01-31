//
//  DCBaseRequest.h
//  DCNetwork
//
//  Created by quanzhizu on 2017/4/8.
//  Copyright © 2017年 quanzhizud2c. All rights reserved.
//
#import "DCRequest.h"
#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
@class DCBaseRequest;

typedef void (^DCBaseRequestBlock)(__kindof DCBaseRequest *request);

@interface DCBaseRequest : DCRequest

@property (assign, nonatomic, readonly) NSInteger responseStatusCode;

@property (strong, nonatomic, readonly) NSDictionary *responseData;

@property (strong, nonatomic, readonly) NSString *errorMsg;
@property (strong, nonatomic) MBProgressHUD *loadingView;

//创建请求
+(DCBaseRequest *)requestWithAPI:(NSString *)api
                           method:(DCHTTPMethod)method
                           params:(NSObject *)params;
//创建并发起请求
+(DCBaseRequest *)startRequestWithAPI:(NSString *)api
                               method:(DCHTTPMethod)method
                               params:(NSObject *)params
                        completeBlock:(DCBaseRequestBlock)completeBlock;


//body请求
+(DCBaseRequest *)startRequestWithAPI:(NSString *)api
                               method:(DCHTTPMethod)method
                               params:(NSObject *)params
                                 body:(NSObject *)body
                        completeBlock:(DCBaseRequestBlock)completeBlock;

//开始请求
- (DCBaseRequest *)startWithCompletionBlock:(DCBaseRequestBlock)completionBlock;


#pragma mark - Loading提示

/**
 *  Loading提示视图的父视图
 *  如果不为NULL，就显示Loading提示
 */
@property (weak, nonatomic, readonly) UIView *loadingInView;



/**
 *  初始化数据请求对象
 *
 *  @param loadingInView Loading提示视图的父视图
 */
+ (instancetype)requestWithLoadingInView:(UIView *)loadingInView;


#pragma mark - 数据分页的请求

/**
 *  分页数据的KeyPath
 */
@property (strong, nonatomic) NSString *pageKeyPath;

/**
 *  分页数据
 */
@property (strong, nonatomic, readonly) NSDictionary *pageDict;

/**
 *  当前数据页码
 */
@property (assign, nonatomic, readonly) NSInteger index;

/**
 *  是否存在下一页数据
 */
@property (assign, nonatomic, readonly) BOOL hasNext;

/**
 *  设置下一页分页参数
 */
- (BOOL)nextPage;


@end
