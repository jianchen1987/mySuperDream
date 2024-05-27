//
//  WMKingKongTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2022/3/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMKingKongTableViewCell.h"
#import "HDPopTip.h"
#import "LKDataRecord.h"
#import "SACacheManager.h"
#import "SAKingKongAreaItemConfig.h"
#import "SAMultiLanguageManager.h"
#import "SANotificationConst.h"
#import "SATalkingData.h"
#import "SAWindowManager.h"
#import "WMAppFunctionModel.h"
#import <HDServiceKit/HDLocationManager.h>
#import "SAMultiLanguageManager.h"

static const CGFloat kMaxRowCount = 2.f;
// static const CGFloat kItemCountPerRow = 5.f;


@interface WMKingKongTableViewCell ()

@end


@implementation WMKingKongTableViewCell

- (CGFloat)cardHeight {
    int count = MIN(kMaxRowCount, MAX(0, self.dataSource.count));
    if (count == 2) {
        return count * self.cardItemSize.height + self.lineCardSpace;
    }
    return count * self.cardItemSize.height;
}

- (void)setGNModel:(NSArray<WMKingKongAreaModel *> *)data {
    self.model = data;
    if ([self.model isKindOfClass:NSArray.class]) {
        self.dataSource = [NSMutableArray arrayWithArray:self.model];
    }
    [super setGNModel:data];
}

- (void)card:(UICollectionView *)card itemClick:(NSIndexPath *)indexPath {
    if (self.dataSource.count <= indexPath.row)
        return;
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:WMKingKongAreaModel.class]) {
        WMKingKongAreaModel *config = model;
        NSString *url = config.link;
        if ([SAWindowManager canOpenURL:url]) {
            [LKDataRecord.shared traceEvent:@"clickBtn" name:@"clickBtn" parameters:@{@"clickType": @"KKD", @"content": config.link} SPM:[LKSPM SPMWithPage:@"WMHomeViewController" area:nil node:nil]];
            
            if ([url containsString:@"specialActivity"] || [url containsString:@"storeDetail"]) {
                [SAWindowManager openUrl:url withParameters:@{
                    @"plateId": @"",
                    @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖首页.金刚区@%zd", indexPath.row] : [NSString stringWithFormat:@"外卖首页.金刚区@%zd", indexPath.row],
                    @"associatedId" : self.viewModel.associatedId
                }];
            } else {
                [SAWindowManager openUrl:url withParameters:@{
                    @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖首页.金刚区@%zd", indexPath.row] : [NSString stringWithFormat:@"外卖首页.金刚区@%zd", indexPath.row],
                    @"associatedId" : self.viewModel.associatedId
                }];
            }
        } else {
            [NAT showAlertWithMessage:WMLocalizedString(@"coming_soon", @"敬请期待") buttonTitle:WMLocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                              handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                  [alertView dismiss];
                              }];
        }
    } else if ([model isKindOfClass:SAKingKongAreaItemConfig.class]) {
        SAKingKongAreaItemConfig *item = (id)model;
        NSString *url = item.url;
        if ([SAWindowManager canOpenURL:url]) {
            [SAWindowManager openUrl:url withParameters:@{
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖首页.金刚区@%zd", indexPath.row] : [NSString stringWithFormat:@"外卖首页.金刚区@%zd", indexPath.row],
                @"associatedId" : self.viewModel.associatedId
            }];
        } else {
            [NAT showAlertWithMessage:WMLocalizedString(@"coming_soon", @"敬请期待") buttonTitle:WMLocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                              handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                  [alertView dismiss];
                              }];
        }
    }
}

- (BOOL)cardUseSlider {
    return YES;
}

- (NSInteger)cardSliderCount {
    return 9;
}

- (CGFloat)cardSpace {
    return kRealWidth(8);
}

- (CGSize)cardItemSize {
    //    CGFloat itemWidth = (kScreenWidth + kRealWidth(20)) / kItemCountPerRow;
    if ([SAMultiLanguageManager isCurrentLanguageCN]) {
        return CGSizeMake(kRealWidth(70), kRealWidth(80));
    }
    return CGSizeMake(kRealWidth(70), kRealWidth(94));
}

- (Class)cardClass {
    return WMKingKongItemCardCell.class;
}

@end


@interface WMKingKongItemCardCell ()
/// image
@property (nonatomic, strong) SDAnimatedImageView *imageIV;
/// image
@property (nonatomic, strong) HDLabel *nameLB;

@end


@implementation WMKingKongItemCardCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.imageIV];
    [self.contentView addSubview:self.nameLB];
}

- (void)setGNModel:(WMKingKongAreaModel *)data {
    self.nameLB.numberOfLines = SAMultiLanguageManager.isCurrentLanguageCN ? 1 : 2;
    if ([data isKindOfClass:WMKingKongAreaModel.class]) {
        self.nameLB.text = WMFillEmptySpace(data.name);
        [HDWebImageManager setGIFImageWithURL:data.icon size:CGSizeMake(kRealWidth(54), kRealWidth(54))
                             placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(kRealWidth(54), kRealWidth(54))]
                                    imageView:self.imageIV];
    } else if ([data isKindOfClass:SAKingKongAreaItemConfig.class]) {
        SAKingKongAreaItemConfig *config = (id)data;
        self.nameLB.text = WMFillEmptySpace(config.name.desc);
        [HDWebImageManager setGIFImageWithURL:config.iconURL size:CGSizeMake(kRealWidth(54), kRealWidth(54))
                             placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(kRealWidth(54), kRealWidth(54))]
                                    imageView:self.imageIV];
    }
}

- (void)updateConstraints {
    [self.imageIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kRealWidth(8));
        make.right.mas_equalTo(kRealWidth(-8));
        make.height.equalTo(self.imageIV.mas_width).multipliedBy(1);
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageIV.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
    }];

    [super updateConstraints];
}

- (SDAnimatedImageView *)imageIV {
    if (!_imageIV) {
        _imageIV = SDAnimatedImageView.new;
    }
    return _imageIV;
}

- (HDLabel *)nameLB {
    if (!_nameLB) {
        HDLabel *label = HDLabel.new;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = HDAppTheme.WMColor.B3;
        label.font = [HDAppTheme.WMFont wm_ForSize:12];
        _nameLB = label;
    }
    return _nameLB;
}

+ (CGFloat)skeletonViewHeight {
    return kRealWidth(103);
}

- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *r0 = [[HDSkeletonLayer alloc] init];
    [r0 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(kRealWidth(54));
        make.height.hd_equalTo(kRealWidth(54));
        make.top.hd_equalTo(0);
        make.left.hd_equalTo(kRealWidth(10));
    }];

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(74);
        make.height.hd_equalTo(kRealWidth(15));
        make.top.hd_equalTo(r0.hd_bottom + kRealWidth(5));
        make.left.hd_equalTo(r0.hd_left);
    }];
    return @[r0, r1];
}

@end
