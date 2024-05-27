//
//  TNPopMenuCell.h
//  SuperApp
//
//  Created by xixi on 2021/1/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

typedef NS_ENUM(NSUInteger, TNPopMenuType) { TNPopMenuTypeContactMerchant, TNPopMenuTypeHome, TNPopMenuTypeSearch, TNPopMenuTypeContactPlatform };


@interface TNPopMenuCellModel : NSObject
/// icon name
@property (nonatomic, strong) NSString *icon;
/// 文本title
@property (nonatomic, strong) NSString *title;
/// 展示类型
@property (nonatomic, assign) TNPopMenuType type;
@end


@interface TNPopMenuCell : SATableViewCell

/// 坐标的icon
@property (nonatomic, strong) UIImageView *iconImgView;
/// 右边的文本
@property (nonatomic, strong) UILabel *titleLabel;

///
@property (nonatomic, strong) TNPopMenuCellModel *model;
@end
