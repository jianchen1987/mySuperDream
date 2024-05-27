//
//  SAImFeedbackOptionModel.h
//  SuperApp
//
//  Created by Tia on 2023/3/3.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAOptionModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAImFeedbackOptionModel : SAOptionModel
///反馈标识
@property (nonatomic, copy) NSString *feedbackType;
/// 文本宽度
@property (nonatomic) NSInteger width;

@end

NS_ASSUME_NONNULL_END
