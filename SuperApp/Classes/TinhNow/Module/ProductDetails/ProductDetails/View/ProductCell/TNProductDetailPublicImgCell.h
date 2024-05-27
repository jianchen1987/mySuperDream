//
//  TNProductDetailPublicImgCell.h
//  SuperApp
//
//  Created by xixi_wen on 2021/11/11.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNProductDetailPublicImg.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNProductDetailPublicImgCellModel : TNModel

// 公共详情页 -- 图片URL
@property (nonatomic, strong) NSString *publicDetailImgUrl;
// 公共性情也 -- APP跳转URL
@property (nonatomic, strong) NSString *publicDetailAppLink;
// 公共性情也 -- H5跳转URL
@property (nonatomic, strong) NSString *publicDetailH5Link;

@property (nonatomic, assign) double imageHeight;
///  砍价页用了  砍价的不用设置内边距
@property (nonatomic, assign) BOOL notSetCellInset;

@end


@interface TNProductDetailPublicImgCell : SATableViewCell

@property (nonatomic, strong) TNProductDetailPublicImgCellModel *model;

@property (nonatomic, copy) void (^getImageViewHeightCallBack)(void);
@end

NS_ASSUME_NONNULL_END
