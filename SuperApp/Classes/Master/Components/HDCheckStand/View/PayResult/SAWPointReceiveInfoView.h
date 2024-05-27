//
//  SAWPointReceiveInfoView.h
//  SuperApp
//
//  Created by seeu on 2022/5/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "SAWPontWillGetRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAWPointReceiveInfoView : SAView

///< moel
@property (nonatomic, strong) SAWPontWillGetRspModel *model;

// 根据宽度计算高度
- (CGFloat)fitHeightWithWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
