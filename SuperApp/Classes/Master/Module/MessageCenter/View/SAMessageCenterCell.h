//
//  SAMessageCenterCell.h
//  SuperApp
//
//  Created by Tia on 2023/4/23.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "SATableHeaderFooterView.h"
#import "SASystemMessageModel.h"
#import "SAMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SAMessageCenterTableHeaderFooterView;

@protocol SAMessageCenterTableHeaderFooterViewDelegate <NSObject>

- (void)headerViewClick:(SAMessageCenterTableHeaderFooterView *)headerView;

@end


@interface SAMessageCenterTableHeaderFooterView : SATableHeaderFooterView

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowView;

@property (nonatomic, weak) id<SAMessageCenterTableHeaderFooterViewDelegate> delegate;
/// 未读数
@property (nonatomic, assign) NSInteger number;

@property (nonatomic, assign) NSInteger section;


@end


@interface SAMessageCenterCell : SATableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *redPoint;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL isLastCell;

@property (nonatomic, strong) SASystemMessageModel *model;

@property (nonatomic, strong) SAMessageModel *chatModel; ///< 数据模型

@end

NS_ASSUME_NONNULL_END
