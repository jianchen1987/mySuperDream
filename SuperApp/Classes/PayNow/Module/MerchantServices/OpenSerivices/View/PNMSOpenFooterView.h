//
//  PNMSOpenFooterView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/5/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SubmitBtnClickBlock)(void);


@interface PNMSOpenFooterView : PNView
@property (nonatomic, copy) SubmitBtnClickBlock submitBtnClickBlock;
@end

NS_ASSUME_NONNULL_END
