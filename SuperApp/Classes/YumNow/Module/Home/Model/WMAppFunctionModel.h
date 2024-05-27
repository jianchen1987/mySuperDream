//
//  WMAppFunctionModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMTraceableAssociatedModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMAppFunctionModel : WMTraceableAssociatedModel
@property (nonatomic, copy) NSString *routeScheme;     ///< 路由 scheme
@property (nonatomic, copy) NSString *routePath;       ///< 路由路径
@property (nonatomic, copy) NSDictionary *routeParams; ///< 路由参数

+ (instancetype)appFunctionModelWithRouteScheme:(NSString *)routeScheme routePath:(NSString *)routePath routeParams:(NSDictionary *_Nullable)routeParams trackName:(NSString *)trackName;
- (instancetype)initWithRouteScheme:(NSString *)routeScheme routePath:(NSString *)routePath routeParams:(NSDictionary *_Nullable)routeParams trackName:(NSString *)trackName;
@end

NS_ASSUME_NONNULL_END
