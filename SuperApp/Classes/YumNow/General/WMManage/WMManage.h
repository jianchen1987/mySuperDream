//
//  WMManage.h
//  SuperApp
//
//  Created by wmz on 2021/8/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAApolloManager.h"
#import "WMEnum.h"
#import <UIKit/UIkit.h>
#import "WMViewControllerProtocol.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMManage : NSObject
+ (instancetype)shareInstance;

@property (nonatomic, copy, nullable) NSString *selectGoodId;
/// 链路id
@property (nonatomic, copy, nullable) NSString *plateId;
/// 异常链路id
@property (nonatomic, copy, nullable) NSString *defaultPlateId;
/// 星期对应的三语
@property (nonatomic, copy, nullable) NSDictionary<NSString *, NSString *> *weekInfo;
/// 领券失败对应的三语
@property (nonatomic, copy, nullable) NSDictionary<WMGiveCouponError, NSString *> *giveCouponErrorInfo;
/// 切换语言
- (void)changeLanguage;
/// 获取当前控制器来源链路
- (NSString *)currentCompleteSource:(UIViewController<WMViewControllerProtocol> *)VC includeSelf:(BOOL)include;
@end

NS_ASSUME_NONNULL_END
