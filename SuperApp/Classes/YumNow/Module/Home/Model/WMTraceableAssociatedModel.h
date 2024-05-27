//
//  WMTraceableAssociatedModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMTraceableAssociatedModel : WMModel
@property (nonatomic, copy) NSString *trackName;   ///< 埋点名称
@property (nonatomic, strong) id associatedObject; ///< 关联对象

+ (instancetype)traceableAssociatedModel:(id)associatedObject trackName:(NSString *)trackName;
- (instancetype)initModel:(id)associatedObject trackName:(NSString *)trackName;

@end

NS_ASSUME_NONNULL_END
