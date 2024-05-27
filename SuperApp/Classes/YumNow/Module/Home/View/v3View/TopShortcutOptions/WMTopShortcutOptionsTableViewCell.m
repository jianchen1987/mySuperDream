//
//  WMTopShortcutOptionsTableViewCell.m
//  SuperApp
//
//  Created by Tia on 2023/7/16.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMTopShortcutOptionsTableViewCell.h"


@implementation WMTopShortcutOptionsTableViewCell

- (void)setGNModel:(NSArray<WMAdadvertisingModel *> *)data {
    self.model = data;

    if ([self.model isKindOfClass:NSArray.class])
        self.dataSource = [NSMutableArray arrayWithArray:self.model];

    [super setGNModel:data];
}

//埋点
- (void)cellWillDisplayWithCollection:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count <= indexPath.row)
        return;
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:WMAdadvertisingModel.class]) {
        WMAdadvertisingModel *tmpModel = (WMAdadvertisingModel *)model;
        NSDictionary *param = @{@"exposureSort": @(indexPath.row).stringValue, @"advertId": @(tmpModel.id), @"type": @"topShortcutOption", @"plateId": WMManage.shareInstance.plateId};
        [collectionView recordStoreExposureCountWithValue:[NSString stringWithFormat:@"%ld", tmpModel.id] key:tmpModel.mShowTime indexPath:indexPath info:param eventName:@"takeawayAdvertExposure"];
    }
}

- (void)card:(UICollectionView *)card itemClick:(NSIndexPath *)indexPath {
    if (self.dataSource.count <= indexPath.row)
        return;
    id model = self.dataSource[indexPath.row];
    ///跳转link
    if ([model isKindOfClass:WMAdadvertisingModel.class]) {
        WMAdadvertisingModel *tmpModel = (WMAdadvertisingModel *)model;
        if ([tmpModel.link containsString:@"specialActivity"] || [tmpModel.link containsString:@"storeDetail"]) {
            [self openLink:tmpModel.link dic:@{
                @"collectType": self.layoutModel.event[@"type"],
                @"plateId": @(tmpModel.id).stringValue,
            }];

            //埋点
            NSDictionary *param = @{@"exposureSort": @(indexPath.row).stringValue, @"advertId": @(tmpModel.id), @"type": @"topShortcutOption", @"plateId": WMManage.shareInstance.plateId};
            [LKDataRecord.shared traceEvent:@"takeawayAdvertClick" name:@"takeawayAdvertClick" parameters:param SPM:nil];
        } else {
            [self openLink:tmpModel.link dic:nil];
        }
    }
}


- (CGSize)cardItemSizeWithIndexPath:(NSIndexPath *)indexPath {
    WMAdadvertisingModel *model = self.dataSource[indexPath.row];
    CGFloat itemWidth = model.showContentWidth + 16;
    return CGSizeMake(itemWidth, kRealWidth(20));
}

- (CGFloat)cardHeight {
    return kRealWidth(20);
}

- (CGFloat)lineCardSpace {
    return kRealWidth(8);
}

- (CGFloat)cardSpace {
    return kRealWidth(8);
}

- (Class)cardClass {
    return WMTopShortcutOptionsItemCardCell.class;
}


@end


@interface WMTopShortcutOptionsItemCardCell ()

@property (nonatomic, strong) SALabel *titleLabel;

@end


@implementation WMTopShortcutOptionsItemCardCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [super updateConstraints];
}

- (void)setGNModel:(WMAdadvertisingModel *)data {
    self.titleLabel.text = data.showContent;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = SALabel.new;
        _titleLabel.font = HDAppTheme.font.sa_standard11;
        _titleLabel.textColor = HDAppTheme.color.sa_C333;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor hd_colorWithHexString:@"#F1F1F1"];
        _titleLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(10)];
        };
    }
    return _titleLabel;
}

+ (CGFloat)skeletonViewHeight {
    CGFloat itemWidth = 200 / 375.0 * kScreenWidth;
    return itemWidth / 2.0 + kRealWidth(50);
}

- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    CGFloat itemWidth = 200 / 375.0 * kScreenWidth;
    CGFloat itemHeight = itemWidth / 2.0;

    HDSkeletonLayer *r0 = [[HDSkeletonLayer alloc] init];
    [r0 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(itemWidth);
        make.height.hd_equalTo(itemHeight);
        make.top.hd_equalTo(0);
        make.left.hd_equalTo(kRealWidth(10));
    }];

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(50);
        make.height.hd_equalTo(kRealWidth(17));
        make.top.hd_equalTo(r0.hd_bottom + kRealWidth(8));
        make.left.hd_equalTo(r0.hd_left);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(100);
        make.height.hd_equalTo(kRealWidth(20));
        make.top.hd_equalTo(r1.hd_bottom + kRealWidth(8));
        make.left.hd_equalTo(r0.hd_left);
    }];

    return @[r0, r1, r2];
}

@end
