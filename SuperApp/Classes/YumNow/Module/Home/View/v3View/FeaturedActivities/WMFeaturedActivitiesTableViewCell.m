//
//  WMFeaturedActivitiesTableViewCell.m
//  SuperApp
//
//  Created by Tia on 2023/7/12.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMFeaturedActivitiesTableViewCell.h"
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
#import "SAWindowItemModel.h"

#define kItemWidth ((kScreenWidth - 12 - 2 * 8) / 2.4)


@interface WMFeaturedActivitiesTableViewCell ()
///标题
@property (nonatomic, strong) HDLabel *titleLB;


@end


@implementation WMFeaturedActivitiesTableViewCell

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.bgView addSubview:self.titleLB];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.titleLB.hidden) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(self.layoutModel.layoutConfig.inSets.top);
            make.height.mas_greaterThanOrEqualTo(24);
        }
    }];

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.cardHeight).priorityHigh();
        make.right.mas_equalTo(-self.layoutModel.layoutConfig.inSets.right);
        make.left.mas_equalTo(self.layoutModel.layoutConfig.inSets.left);
        if (!self.titleLB.hidden) {
            make.top.equalTo(self.titleLB.mas_bottom).offset(12).priorityHigh();
        } else {
            make.top.mas_equalTo(self.layoutModel.layoutConfig.inSets.top);
        }
        make.bottom.mas_lessThanOrEqualTo(-self.layoutModel.layoutConfig.inSets.bottom);
    }];
}

- (CGFloat)cardHeight {
    if (self.dataSource.count <= 4) {
        return self.cardItemSize.height;
    } else {
        return 2 * self.cardItemSize.height + self.lineCardSpace + 1;
    }
}

- (void)setGNModel:(NSArray<WMAdadvertisingModel *> *)data {
    self.model = data;
    if ([self.model isKindOfClass:NSArray.class]) {
        //如果是活动精选大于5个，而且还是单数，补一个空的，
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.model];
        if (self.model.count > 4 && self.model.count % 2 != 0) {
            [mArr addObject:[NSObject new]];
        }
        self.dataSource = [NSMutableArray arrayWithArray:mArr];
    }
    [super setGNModel:data];
}

- (void)cellWillDisplayWithCollection:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count <= indexPath.row)
        return;
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:WMAdadvertisingModel.class]) {
        WMAdadvertisingModel *tmpModel = (WMAdadvertisingModel *)model;
        NSDictionary *param = @{@"exposureSort": @(indexPath.row).stringValue, @"advertId": @(tmpModel.id), @"type": @"featuredActivity", @"plateId": WMManage.shareInstance.plateId};
        [collectionView recordStoreExposureCountWithValue:[NSString stringWithFormat:@"%ld", tmpModel.id] key:tmpModel.mShowTime indexPath:indexPath info:param eventName:@"takeawayAdvertExposure"];
    }
}


- (void)card:(UICollectionView *)card itemClick:(NSIndexPath *)indexPath {
    if (self.dataSource.count <= indexPath.row)
        return;
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:WMAdadvertisingModel.class]) {
        WMAdadvertisingModel *tmpModel = (WMAdadvertisingModel *)model;
        if ([tmpModel.link containsString:@"specialActivity"] || [tmpModel.link containsString:@"storeDetail"]) {
            [self openLink:tmpModel.link dic:@{
                @"collectType": self.layoutModel.event[@"type"],
                @"plateId": @(tmpModel.id).stringValue,
            }];

            //埋点
            NSDictionary *param = @{@"exposureSort": @(indexPath.row).stringValue, @"advertId": @(tmpModel.id), @"type": @"featuredActivity", @"plateId": WMManage.shareInstance.plateId};
            [LKDataRecord.shared traceEvent:@"takeawayAdvertClick" name:@"takeawayAdvertClick" parameters:param SPM:nil];


        } else {
            [self openLink:tmpModel.link dic:nil];
        }
    }
}

- (CGFloat)lineCardSpace {
    return 12;
}

- (CGFloat)cardSpace {
    return 8;
}

- (CGSize)cardItemSize {
    return CGSizeMake(kItemWidth, kItemWidth / 144 * 80);
}

- (Class)cardClass {
    return WMFeaturedActivitiesItemCardCell.class;
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B3;
        label.font = HDAppTheme.font.sa_standard16SB;
        _titleLB = label;
        NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey:@"yunnow_home_huodongjingxuan"];
        if (HDIsStringNotEmpty(text)) {
            _titleLB.text = text;
            _titleLB.hidden = NO;
        } else {
            _titleLB.hidden = YES;
        }
    }
    return _titleLB;
}

@end


@interface WMFeaturedActivitiesItemCardCell ()
/// image
@property (nonatomic, strong) SDAnimatedImageView *imageIV;

@end


@implementation WMFeaturedActivitiesItemCardCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.imageIV];
}

- (void)setGNModel:(WMAdadvertisingModel *)data {
    CGSize size = CGSizeMake(kItemWidth, kItemWidth / 144 * 80);
    if ([data isKindOfClass:WMAdadvertisingModel.class]) {
        [self.imageIV sd_setImageWithURL:[NSURL URLWithString:data.nImages] placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:size]];
    } else if ([data isKindOfClass:NSObject.class]) {
        if (SAMultiLanguageManager.isCurrentLanguageCN)
            self.imageIV.image = [UIImage imageNamed:@"wm_home_jqqd_zh"];
        if (SAMultiLanguageManager.isCurrentLanguageKH)
            self.imageIV.image = [UIImage imageNamed:@"wm_home_jqqd_kh"];
        if (SAMultiLanguageManager.isCurrentLanguageEN)
            self.imageIV.image = [UIImage imageNamed:@"wm_home_jqqd_en"];
    }
}

- (void)updateConstraints {
    [self.imageIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [super updateConstraints];
}

- (SDAnimatedImageView *)imageIV {
    if (!_imageIV) {
        _imageIV = SDAnimatedImageView.new;
        _imageIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _imageIV;
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
