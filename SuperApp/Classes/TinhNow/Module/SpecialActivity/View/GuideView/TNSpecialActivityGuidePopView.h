//
//  TNSpecialActivityGuidePopView.h
//  SuperApp
//
//  Created by 张杰 on 2022/4/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNSpeciaActivityDetailModel.h"
#import "TNView.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNSpecialActivityGuidePopView : TNView
- (instancetype)initWithSpecialType:(TNSpecialStyleType)styleType;
- (void)showFromSourceView:(UIView *)sourceView;
@end

NS_ASSUME_NONNULL_END
