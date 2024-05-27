//
//  WMFoucsAdvertiseTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2022/3/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMFoucsAdvertiseTableViewCell.h"
#import "SAWindowItemModel.h"


@implementation WMFoucsAdvertiseTableViewCell

- (void)setGNModel:(NSArray<WMAdadvertisingModel *> *)data {
    self.model = data;

    if ([self.model isKindOfClass:NSArray.class])
        self.dataSource = [NSMutableArray arrayWithArray:self.model];

    [super setGNModel:data];
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
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖首页.焦点广告@%zd", indexPath.row] : [NSString stringWithFormat:@"外卖首页.焦点广告@%zd", indexPath.row],
                @"associatedId" : self.viewModel.associatedId
            }];
        } else {
            [self openLink:tmpModel.link dic:@{
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖首页.焦点广告@%zd", indexPath.row] : [NSString stringWithFormat:@"外卖首页.焦点广告@%zd", indexPath.row],
                @"associatedId" : self.viewModel.associatedId
            }];
        }
    } else if ([model isKindOfClass:SAWindowItemModel.class]) {
        SAWindowItemModel *tmpModel = (SAWindowItemModel *)model;
        [self openLink:tmpModel.jumpLink dic:@{
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖首页.焦点广告@%zd", indexPath.row] : [NSString stringWithFormat:@"外卖首页.焦点广告@%zd", indexPath.row],
            @"associatedId" : self.viewModel.associatedId
        }];
    }
}

- (CGSize)cardItemSize {
    CGFloat itemWidth = 150 / 375.0 * kScreenWidth;
    return CGSizeMake(itemWidth, 170.0 * kScreenWidth / 375.0);
}

- (CGFloat)cardSpace {
    return kRealWidth(8);
}

- (Class)cardClass {
    return WMAdvertiseItemCardCell.class;
}

@end


@interface WMAdvertiseItemCardCell ()
/// image
@property (nonatomic, strong) UIImageView *imageIV;

@end


@implementation WMAdvertiseItemCardCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.imageIV];
}

- (void)setGNModel:(WMAdadvertisingModel *)data {
    if ([data isKindOfClass:WMAdadvertisingModel.class]) {
        [self.imageIV sd_setImageWithURL:[NSURL URLWithString:data.images]
                        placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(150 / 375.0 * kScreenWidth, 170.0 * kScreenWidth / 375.0)]];
    } else if ([data isKindOfClass:NSString.class]) {
        [self.imageIV sd_setImageWithURL:[NSURL URLWithString:(NSString *)data]
                        placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(152 / 375.0 * kScreenWidth, 112 * kScreenWidth / 375.0)]];
    }
}

- (void)updateConstraints {
    [self.imageIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [super updateConstraints];
}

- (UIImageView *)imageIV {
    if (!_imageIV) {
        _imageIV = UIImageView.new;
        _imageIV.contentMode = UIViewContentModeScaleAspectFill;
        _imageIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = kRealWidth(8);
            view.clipsToBounds = YES;
        };
    }
    return _imageIV;
}

+ (CGFloat)skeletonViewHeight {
    return 170.0 * kScreenWidth / 375.0;
}

- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    CGFloat width = 170.0 * kScreenWidth / 375.0;
    HDSkeletonLayer *r0 = [[HDSkeletonLayer alloc] init];
    [r0 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(width);
        make.height.hd_equalTo(width);
        make.top.hd_equalTo(0);
        make.left.hd_equalTo(kRealWidth(10));
    }];
    return @[r0];
}

@end
