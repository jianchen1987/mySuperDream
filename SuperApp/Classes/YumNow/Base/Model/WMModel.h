//
//  WMModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAUser.h"
#import "WMEnum.h"
#import "WMOrderRelatedEnum.h"
#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMModel : SAModel
@property (nonatomic, strong) NSIndexPath *indexPath;
/// 展示出来的时间
@property (nonatomic, copy) NSString *mShowTime;

@end

NS_ASSUME_NONNULL_END
