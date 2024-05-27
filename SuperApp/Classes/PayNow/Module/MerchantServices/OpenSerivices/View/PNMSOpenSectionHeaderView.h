//
//  PNMSOpenSectionHeaderView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/5/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableHeaderFooterView.h"

@class HDTableHeaderFootViewModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSOpenSectionHeaderView : SATableHeaderFooterView
@property (nonatomic, strong) HDTableHeaderFootViewModel *model;
@end

NS_ASSUME_NONNULL_END
