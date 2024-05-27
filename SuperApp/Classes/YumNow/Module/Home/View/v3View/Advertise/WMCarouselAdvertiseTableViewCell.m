//
//  WMCarouselAdvertiseTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2022/4/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMCarouselAdvertiseTableViewCell.h"
#import "SAWindowItemModel.h"


@implementation WMCarouselAdvertiseTableViewCell

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.contentView addSubview:self.pageControl];
}

- (void)updateConstraints {
    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.collectionView.mas_right).offset(-kRealWidth(3));
        make.bottom.equalTo(self.collectionView.mas_bottom).offset(-kRealWidth(8));
        make.width.mas_equalTo(MIN(kScreenWidth - kRealWidth(25), kRealWidth(12) * self.dataSource.count));
        make.height.mas_equalTo(kRealWidth(6));
    }];
    [super updateConstraints];
}

- (void)setGNModel:(NSArray<WMAdadvertisingModel *> *)data {
    [super setGNModel:data];
    self.pageControl.hidden = !(data.count > 1);
    self.pageControl.numberOfPages = data.count;
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
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖首页.首页轮播广告@%zd", indexPath.row] : [NSString stringWithFormat:@"外卖首页.首页轮播广告@%zd", indexPath.row],
                @"associatedId" : self.viewModel.associatedId
            }];
        } else {
            [self openLink:tmpModel.link dic:@{
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖首页.首页轮播广告@%zd", indexPath.row] : [NSString stringWithFormat:@"外卖首页.首页轮播广告@%zd", indexPath.row],
                @"associatedId" : self.viewModel.associatedId
            }];
        }
    } else if ([model isKindOfClass:SAWindowItemModel.class]) {
        SAWindowItemModel *tmpModel = (SAWindowItemModel *)model;
        [self openLink:tmpModel.jumpLink dic:@{
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖首页.首页轮播广告@%zd", indexPath.row] : [NSString stringWithFormat:@"外卖首页.首页轮播广告@%zd", indexPath.row],
            @"associatedId" : self.viewModel.associatedId
        }];
    }
}

- (void)pagerView:(HDCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [self.pageControl setCurrentPage:toIndex animate:YES];
}

- (BOOL)cardUseBanner {
    return YES;
}

- (CGFloat)cardCycleDurtion {
    return 5.0;
}

- (CGFloat)cardSpace {
    return 0;
}

- (CGSize)cardItemSize {
    CGFloat itemWidth = kScreenWidth - 12 * 2;
    return CGSizeMake(itemWidth, 90 * itemWidth / 350.0);
}

- (Class)cardClass {
    return WMCarouselAdvertiseItemCardCell.class;
}

- (HDPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[HDPageControl alloc] init];
        _pageControl.currentPageIndicatorSize = CGSizeMake(kRealWidth(6), kRealWidth(6));
        _pageControl.pageIndicatorSize = CGSizeMake(kRealWidth(6), kRealWidth(6));
        _pageControl.pageIndicatorSpaing = kRealWidth(6);
        _pageControl.currentPageIndicatorTintColor = HDAppTheme.WMColor.mainRed;
        _pageControl.pageIndicatorTintColor = [UIColor hd_colorWithHexString:@"000000"];
        _pageControl.hidesForSinglePage = true;
    }
    return _pageControl;
}

@end


@interface WMCarouselAdvertiseItemCardCell ()
///图片
@property (nonatomic, strong) SDAnimatedImageView *imageView;

@end


@implementation WMCarouselAdvertiseItemCardCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.imageView];
}

- (void)updateConstraints {
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [super updateConstraints];
}

- (void)setGNModel:(WMAdadvertisingModel *)data {
    if ([data isKindOfClass:WMAdadvertisingModel.class]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:data.images]
                          placeholderImage:[HDHelper placeholderImageWithCornerRadius:kRealWidth(8) size:CGSizeMake(350 / 375.0 * kScreenWidth, 90.0 * kScreenWidth / 375.0)]];
    } else if ([data isKindOfClass:SAWindowItemModel.class]) {
        SAWindowItemModel *windowModel = (SAWindowItemModel *)data;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:windowModel.bannerUrl]
                          placeholderImage:[HDHelper placeholderImageWithCornerRadius:kRealWidth(8) size:CGSizeMake(350 / 375.0 * kScreenWidth, 90.0 * kScreenWidth / 375.0)]];
    }
}

- (SDAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = SDAnimatedImageView.new;
        //        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = kRealWidth(8);
        };
    }
    return _imageView;
}

+ (CGFloat)skeletonViewHeight {
    return 90.0 * kScreenWidth / 375.0;
}

- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *r0 = [[HDSkeletonLayer alloc] init];
    [r0 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(350 * kScreenWidth / 375.0);
        make.height.hd_equalTo(90.0 * kScreenWidth / 375.0);
        make.top.hd_equalTo(0);
        make.left.hd_equalTo(0);
    }];
    return @[r0];
}

@end
