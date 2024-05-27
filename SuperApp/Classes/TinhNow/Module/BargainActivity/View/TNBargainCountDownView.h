//
//  TNBargainCountDownView.h
//  SuperApp
//
//  Created by 张杰 on 2021/3/12.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNBargainCountDownView : TNView
/// 后置文本  例如  后结束
@property (nonatomic, copy) NSString *suffixText;
/// 更新 时分秒
/// @param hour 时
/// @param minute 分
/// @param second 秒
- (void)updateHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
@end

NS_ASSUME_NONNULL_END
