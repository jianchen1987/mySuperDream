//
//  TransTypeCell.h
//  SuperApp
//
//  Created by Quin on 2021/11/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNTableViewCell.h"
#import "PNTransTypeModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNTransTypeCell : PNTableViewCell
@property (nonatomic, strong) PNTransTypeModel *model;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) SDAnimatedImageView *iconImg;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImg;

@end

NS_ASSUME_NONNULL_END
