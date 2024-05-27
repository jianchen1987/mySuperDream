//
//  WMKingKongNewTableViewCell.m
//  SuperApp
//
//  Created by Tia on 2023/7/17.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMNewKingKongTableViewCell.h"
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


@interface WMNewKingKongTableViewCell ()
/// pageControl
@property (nonatomic, strong) HDPageControl *pageControl;

@property (nonatomic, assign) CGFloat offset;

@end


@implementation WMNewKingKongTableViewCell

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.contentView addSubview:self.pageControl];

    if ([self.collectionView isKindOfClass:[NSClassFromString(@"WMHomeCollectionView") class]]) {
        WMHomeCollectionView *collectionView = (WMHomeCollectionView *)self.collectionView;
        collectionView.pagingEnabled = YES;
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(kRealWidth(4));
        make.centerX.mas_equalTo(0);
    }];
}

- (CGFloat)cardHeight {
    if (SAMultiLanguageManager.isCurrentLanguageCN) {
        CGFloat offset = 24;

        offset *= self.offset;

        return 60 + 18 + 8 + 32 + 18 - offset;
    } else {
        CGFloat offset = 24;

        offset *= self.offset;
        return 96 + 68 + 8 - offset;
    }
}

- (void)setGNModel:(NSArray<WMKingKongAreaModel *> *)data {
    self.model = data;
    if ([self.model isKindOfClass:NSArray.class]) {
        NSMutableArray *finalArr = NSMutableArray.new;
        NSMutableArray *mArr = NSMutableArray.new;

        for (NSInteger i = 0; i < self.model.count; i++) {
            WMKingKongAreaModel *m = self.model[i];
            if (i == 0 || i == 2 || i == 4 || i == 6 || i == 8) {
                m.needBig = YES;
            }
            if (mArr.count < 10) {
                [mArr addObject:m];
                if (mArr.count == 10) {
                    [finalArr addObject:[NSArray arrayWithArray:mArr]];
                    [mArr removeAllObjects];
                }
            }
            if (i == self.model.count - 1 && mArr.count != 0) {
                [finalArr addObject:mArr];
            }
        }
        self.dataSource = [NSMutableArray arrayWithArray:finalArr];
        self.pageControl.hidden = !(self.dataSource.count > 1);
        self.pageControl.numberOfPages = self.dataSource.count;
    }
    [super setGNModel:data];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = (NSInteger)(scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.frame.size.width * 1.5));
    self.offset = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.frame.size.width);
    [self.pageControl setCurrentPage:index animate:YES];
    !self.changeDataCell ?: self.changeDataCell(self.layoutModel);
}

- (void)setOffset:(CGFloat)offset {
    _offset = offset;
    if (_offset < 0)
        _offset = 0;
    if (_offset > 1)
        _offset = 1;
}

- (void)card:(UICollectionView *)card itemClick:(NSIndexPath *)indexPath {
}

- (BOOL)cardUseSlider {
    return NO;
}

- (NSInteger)cardSliderCount {
    return 1;
}

- (CGFloat)cardSpace {
    return 0;
}

- (CGSize)cardItemSizeWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            return CGSizeMake(kScreenWidth, 60 + 18 + 8 + 32 + 18);
        }
        return CGSizeMake(kScreenWidth, 96 + 8 + 68);
    } else {
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            return CGSizeMake(kScreenWidth, 32 + 18 + 8 + 32 + 18);
        }
        return CGSizeMake(kScreenWidth, 68 + 8 + 68);
    }
}

- (Class)cardClass {
    return WMNewKingKongItemCardCell.class;
}

- (HDPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[HDPageControl alloc] init];
        _pageControl.currentPageIndicatorSize = CGSizeMake(kRealWidth(22), kRealWidth(4));
        _pageControl.pageIndicatorSize = CGSizeMake(kRealWidth(4), kRealWidth(4));
        _pageControl.pageIndicatorSpaing = kRealWidth(4);
        _pageControl.currentPageIndicatorTintColor = HDAppTheme.color.sa_C1;
        _pageControl.pageIndicatorTintColor = [UIColor hd_colorWithHexString:@"#e9eaef"];
        _pageControl.hidesForSinglePage = true;
    }
    return _pageControl;
}

@end


@interface WMNewKingKongItemView : SAView
/// image
@property (nonatomic, strong) SDAnimatedImageView *imageIV;
/// image
@property (nonatomic, strong) HDLabel *nameLB;

@property (nonatomic, strong) WMKingKongAreaModel *model;
@end


@implementation WMNewKingKongItemView

- (void)hd_setupViews {
    [self addSubview:self.imageIV];
    [self addSubview:self.nameLB];
    self.backgroundColor = UIColor.clearColor;

    UITapGestureRecognizer *recoginer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedCellHandler:)];
    [self addGestureRecognizer:recoginer];
}

- (void)clickedCellHandler:(UITapGestureRecognizer *)recoginer {
    if ([self.model isKindOfClass:WMKingKongAreaModel.class]) {
        WMKingKongAreaModel *config = self.model;
        NSString *url = config.link;
        if ([SAWindowManager canOpenURL:url]) {
            [LKDataRecord.shared traceEvent:@"clickBtn" name:@"clickBtn" parameters:@{@"clickType": @"KKD", @"content": config.link} SPM:[LKSPM SPMWithPage:@"WMNewHomeViewController" area:nil
                                                                                                                                                       node:nil]];
            if ([url containsString:@"specialActivity"] || [url containsString:@"storeDetail"]) {
                [SAWindowManager openUrl:url withParameters:@{
                    @"plateId": @"",
                }];
            } else {
                [SAWindowManager openUrl:url withParameters:nil];
            }
        } else {
            [NAT showAlertWithMessage:WMLocalizedString(@"coming_soon", @"敬请期待") buttonTitle:WMLocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                              handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                  [alertView dismiss];
                              }];
        }
    }
}

- (void)updateConstraints {
    [self.imageIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(self.model.needBig ? CGSizeMake(60, 60) : CGSizeMake(32, 32));
        make.centerX.equalTo(self);
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageIV.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.centerX.equalTo(self);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
    }];

    [super updateConstraints];
}

- (void)setModel:(WMKingKongAreaModel *)model {
    _model = model;
    self.nameLB.numberOfLines = SAMultiLanguageManager.isCurrentLanguageCN ? 1 : 2;
    if ([model isKindOfClass:WMKingKongAreaModel.class]) {
        self.nameLB.text = WMFillEmptySpace(model.name);
        [HDWebImageManager setGIFImageWithURL:model.icon size:model.needBig ? CGSizeMake(60, 60) : CGSizeMake(32, 32)
                             placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:model.needBig ? CGSizeMake(60, 60) : CGSizeMake(32, 32)]
                                    imageView:self.imageIV];
    } else if ([model isKindOfClass:SAKingKongAreaItemConfig.class]) {
        SAKingKongAreaItemConfig *config = (id)model;
        self.nameLB.text = WMFillEmptySpace(config.name.desc);
        [HDWebImageManager setGIFImageWithURL:config.iconURL size:model.needBig ? CGSizeMake(60, 60) : CGSizeMake(32, 32)
                             placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:model.needBig ? CGSizeMake(60, 60) : CGSizeMake(32, 32)]
                                    imageView:self.imageIV];
    }
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

@end


@interface WMNewKingKongItemCardCell ()


@property (nonatomic, strong) HDGridView *topGridView;

@property (nonatomic, strong) HDGridView *bottomGridView;

@property (nonatomic, assign) BOOL needBig;

@end


@implementation WMNewKingKongItemCardCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.topGridView];
    [self.contentView addSubview:self.bottomGridView];
    self.contentView.backgroundColor = UIColor.clearColor;
    self.topGridView.backgroundColor = UIColor.clearColor;
    self.bottomGridView.backgroundColor = UIColor.clearColor;
}

- (void)setGNModel:(NSArray<WMKingKongAreaModel *> *)data {
    if (data.count) {
        [self.topGridView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

        [self.bottomGridView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

        for (int i = 0; i < data.count; i++) {
            WMKingKongAreaModel *m = data[i];
            WMNewKingKongItemView *view = WMNewKingKongItemView.new;
            view.model = m;
            if (i == 0 || i == 2 || i == 4 || i == 6 || i == 8) {
                self.needBig = m.needBig;
                [self.topGridView addSubview:view];
            } else {
                [self.bottomGridView addSubview:view];
            }
        }

        [self setNeedsUpdateConstraints];
    }
}

- (void)updateConstraints {
    [self.topGridView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(kRealWidth(-12));
        if (self.needBig) {
            if (SAMultiLanguageManager.isCurrentLanguageCN) {
                make.height.mas_equalTo(60 + 18);
            } else {
                make.height.mas_equalTo(96);
            }
        } else {
            if (SAMultiLanguageManager.isCurrentLanguageCN) {
                make.height.mas_equalTo(32 + 18);
            } else {
                make.height.mas_equalTo(32 + 36);
            }
        }
    }];

    [self.bottomGridView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topGridView.mas_bottom).offset(8);
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            make.height.mas_equalTo(32 + 18);
        } else {
            make.height.mas_equalTo(32 + 36);
        }
        make.left.right.equalTo(self.topGridView);
    }];

    [super updateConstraints];
}

- (HDGridView *)topGridView {
    if (!_topGridView) {
        _topGridView = [[HDGridView alloc] init];
        _topGridView.columnCount = 5;
        _topGridView.edgeInsets = UIEdgeInsetsZero;
        _topGridView.backgroundColor = UIColor.whiteColor;
        _topGridView.subViewHMargin = 1;
    }
    return _topGridView;
}

- (HDGridView *)bottomGridView {
    if (!_bottomGridView) {
        _bottomGridView = [[HDGridView alloc] init];
        _bottomGridView.columnCount = 5;
        _bottomGridView.edgeInsets = UIEdgeInsetsZero;
        _bottomGridView.backgroundColor = UIColor.whiteColor;
        _bottomGridView.subViewHMargin = 1;
    }
    return _bottomGridView;
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
