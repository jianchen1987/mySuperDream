//
//  WMHomeNoticeTipView.h
//  SuperApp
//
//  Created by wmz on 2022/4/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMHomeNoticeModel.h"
#import "WMLocationTipView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMHomeNoticeTipView : WMLocationTipView

@property (nonatomic, strong) WMHomeNoticeModel *model;
///手动关闭回调
@property (nonatomic, copy) void (^eventHandClose)(BOOL handClose);

@end

NS_ASSUME_NONNULL_END
