//
//  WMNewCarouselAdvertiseTableViewCell.m
//  SuperApp
//
//  Created by Tia on 2023/7/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMNewCarouselAdvertiseTableViewCell.h"


@implementation WMNewCarouselAdvertiseTableViewCell

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.contentView addSubview:self.pageControl];
}

- (void)updateConstraints {
    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.right.equalTo(self.collectionView.mas_right).offset(-kRealWidth(3));
        make.centerX.equalTo(self.collectionView);
        make.bottom.equalTo(self.collectionView.mas_bottom).offset(-kRealWidth(4));
        make.width.mas_equalTo(MIN(kScreenWidth - kRealWidth(25), kRealWidth(12) * self.dataSource.count));
        make.height.mas_equalTo(kRealWidth(4));
    }];
    [super updateConstraints];
}

- (void)setGNModel:(NSArray<WMAdadvertisingModel *> *)data {
    [super setGNModel:data];
    self.pageControl.hidden = !(data.count > 1);
    self.pageControl.numberOfPages = data.count;
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
    return CGSizeMake(itemWidth, itemWidth / 350 * 130);
}

- (Class)cardClass {
    return WMNewCarouselAdvertiseItemCardCell.class;
}

- (HDPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[HDPageControl alloc] init];
        _pageControl.currentPageIndicatorSize = CGSizeMake(kRealWidth(8), kRealWidth(4));
        _pageControl.pageIndicatorSize = CGSizeMake(kRealWidth(4), kRealWidth(4));
        _pageControl.pageIndicatorSpaing = kRealWidth(4);
        _pageControl.currentPageIndicatorTintColor = UIColor.whiteColor;
        _pageControl.pageIndicatorTintColor = [[UIColor hd_colorWithHexString:@"#000000"] colorWithAlphaComponent:0.6];
        _pageControl.hidesForSinglePage = true;
    }
    return _pageControl;
}

@end


@interface WMNewCarouselAdvertiseItemCardCell ()

@end


@implementation WMNewCarouselAdvertiseItemCardCell

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
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:data.nImages]
                          placeholderImage:[HDHelper placeholderImageWithCornerRadius:kRealWidth(8) size:CGSizeMake(kScreenWidth - 12 * 2, 130 * kScreenWidth / 375.0)]];
    }
}

- (SDAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = SDAnimatedImageView.new;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = kRealWidth(8);
        };
    }
    return _imageView;
}

+ (CGFloat)skeletonViewHeight {
    return 130 * kScreenWidth / 375.0;
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
