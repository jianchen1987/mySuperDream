//
//  TNProductBannerCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNProductBannerCell.h"
#import "HDAppTheme+TinhNow.h"
#import "SASingleImageCollectionViewCell.h"
#import "TNImageModel.h"
#import "TNSingleVideoCollectionViewCell.h"


@interface TNProductBannerCell () <HDCyclePagerViewDelegate, HDCyclePagerViewDataSource>
/// banner
@property (nonatomic, strong) HDCyclePagerView *bannerView;
/// 包邮图片
@property (strong, nonatomic) UIImageView *freeShippingImageView;
/// 页码
@property (nonatomic, strong) HDLabel *pageNoLabel;
/// 轮播数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
@end


@implementation TNProductBannerCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bannerView];
    [self.contentView addSubview:self.pageNoLabel];
    [self.bannerView addSubview:self.freeShippingImageView];
}
- (void)updateConstraints {
    [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.equalTo(self.bannerView.mas_width).multipliedBy(1);
    }];
    [self.freeShippingImageView sizeToFit];
    [self.freeShippingImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.bannerView);
    }];

    if (!self.pageNoLabel.isHidden) {
        [self.pageNoLabel sizeToFit];
        [self.pageNoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bannerView.mas_centerX);
            make.bottom.equalTo(self.bannerView.mas_bottom).offset(-15);
        }];
    }
    [super updateConstraints];
}
#pragma mark - setter
- (void)setModel:(TNProductBannerCellModel *)model {
    _model = model;
    [self.dataSource removeAllObjects];
    //添加视频模型进去
    if (!HDIsArrayEmpty(model.videoList)) {
        TNImageModel *imageModel = model.images.firstObject;
        for (NSString *videoUrl in model.videoList) {
            TNSingleVideoCollectionViewCellModel *videoModel = TNSingleVideoCollectionViewCellModel.new;
            if (HDIsStringNotEmpty(imageModel.medium)) {
                videoModel.coverImageUrl = imageModel.medium;
            }
            videoModel.videoUrl = videoUrl;
            //            @"https://dh2.v.netease.com/2017/cg/fxtpty.mp4";
            videoModel.placholderImage = [HDHelper placeholderImageWithBgColor:HDAppTheme.color.G5 cornerRadius:0 size:CGSizeMake(kScreenWidth, kScreenWidth)
                                                                     logoImage:[UIImage imageNamed:@"sa_placeholder_image"]
                                                                      logoSize:CGSizeMake(100, 100)];
            videoModel.cornerRadius = 0;
            [self.dataSource addObject:videoModel];
        }
    }
    for (TNImageModel *image in _model.images) {
        SASingleImageCollectionViewCellModel *bannerModel = SASingleImageCollectionViewCellModel.new;
        bannerModel.url = image.medium;
        bannerModel.associatedObj = image;
        bannerModel.placholderImage = [HDHelper placeholderImageWithBgColor:HDAppTheme.color.G5 cornerRadius:0 size:CGSizeMake(kScreenWidth, kScreenWidth)
                                                                  logoImage:[UIImage imageNamed:@"sa_placeholder_image"]
                                                                   logoSize:CGSizeMake(100, 100)];
        bannerModel.cornerRadius = 0;
        [self.dataSource addObject:bannerModel];
    }

    [self.bannerView reloadData];

    if (self.dataSource.count > 1) {
        [self.pageNoLabel setHidden:NO];
        [self setPageNoWithIndex:self.model.currentPageIndex == 0 ? 1 : self.model.currentPageIndex];
    } else {
        [self.pageNoLabel setHidden:YES];
    }

    self.freeShippingImageView.hidden = !model.isFreeShipping;
}
// 设置页码
- (void)setPageNoWithIndex:(NSUInteger)index {
    NSString *start = [NSString stringWithFormat:@"%zd", index];
    NSString *end = [NSString stringWithFormat:@"/%zd", self.dataSource.count];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[start stringByAppendingString:end]];
    [str addAttributes:@{NSFontAttributeName: HDAppTheme.TinhNowFont.standard15B, NSForegroundColorAttributeName: UIColor.whiteColor} range:NSMakeRange(0, start.length)];
    [str addAttributes:@{NSFontAttributeName: HDAppTheme.TinhNowFont.standard12, NSForegroundColorAttributeName: UIColor.whiteColor} range:NSMakeRange(start.length, end.length)];
    self.pageNoLabel.attributedText = str;
}

- (void)clickedImageHandler:(UITapGestureRecognizer *)recognizer {
    UIImageView *imageView = (UIImageView *)recognizer.view;
    if (imageView && [imageView isKindOfClass:UIImageView.class]) {
        NSInteger index = ((NSNumber *)(imageView.hd_associatedObject)).integerValue;
        [self showImageBrowserWithInitialProjectiveView:imageView index:index];
    }
}

#pragma mark - private methods
/// 展示图片浏览器
/// @param projectiveView 默认投影 View
/// @param index 默认起始索引
- (void)showImageBrowserWithInitialProjectiveView:(UIView *)projectiveView index:(NSUInteger)index {
    NSMutableArray<YBIBImageData *> *datas = [NSMutableArray array];

    for (TNImageModel *image in self.model.images) {
        YBIBImageData *data = [YBIBImageData new];
        data.imageURL = [NSURL URLWithString:image.source];
        // 这里固定只是从此处开始投影，滑动时会更新投影控件
        data.projectiveView = projectiveView;
        [datas addObject:data];
    }

    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = datas;
    browser.currentPage = index;
    browser.autoHideProjectiveView = false;
    browser.backgroundColor = HexColor(0x343B4C);

    HDImageBrowserToolViewHandler *toolViewHandler = HDImageBrowserToolViewHandler.new;
    toolViewHandler.sourceView = self.bannerView;
    toolViewHandler.saveImageResultBlock = ^(UIImage *_Nonnull image, NSError *_Nullable error) {
        if (error != NULL) {
            [NAT showToastWithTitle:nil content:WMLocalizedString(@"discover_show_image_save_failed", @"图片保存失败") type:HDTopToastTypeError];
        } else {
            [NAT showToastWithTitle:nil content:WMLocalizedString(@"discover_show_image_save_success", @"图片保存成功") type:HDTopToastTypeSuccess];
        }
    };
    //    toolViewHandler.updateProjectiveViewBlock = ^UIView *_Nonnull(NSUInteger index) {
    //        return index < self.model.images.count ? self.model.subviews[index] : self.imageContainer.subviews.lastObject;
    //    };
    browser.toolViewHandlers = @[toolViewHandler];

    [browser show];
}
#pragma mark - HDCylePageViewDelegate
- (NSInteger)numberOfItemsInPagerView:(HDCyclePagerView *)pageView {
    return self.dataSource.count;
}

- (UICollectionViewCell *)pagerView:(HDCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    id model = self.dataSource[index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    if ([model isKindOfClass:[TNSingleVideoCollectionViewCellModel class]]) {
        TNSingleVideoCollectionViewCell *cell = [TNSingleVideoCollectionViewCell cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
        cell.videoContentView.contentMode = UIViewContentModeScaleAspectFit;
        @HDWeakify(self);
        cell.videoPlayClickCallBack = ^(NSURL *_Nonnull url) {
            @HDStrongify(self);
            if (self.videoTapClick) {
                self.videoTapClick(pagerView, indexPath, model);
            }
        };
        cell.videoAutoPlayCallBack = ^(NSURL *_Nonnull url) {
            @HDStrongify(self);
            if (!self.model.hasAutoPLay) {
                self.model.hasAutoPLay = YES;
                if (self.videoTapClick) {
                    self.videoTapClick(pagerView, indexPath, model);
                }
            }
        };
        cell.model = model;
        return cell;
    } else {
        SASingleImageCollectionViewCell *cell = [SASingleImageCollectionViewCell cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.model = model;
        return cell;
    }
}

- (void)pagerView:(HDCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    if ([cell isKindOfClass:[SASingleImageCollectionViewCell class]]) {
        NSInteger currentIndex = index - self.model.videoList.count;
        SASingleImageCollectionViewCell *trueCell = (SASingleImageCollectionViewCell *)cell;
        [self showImageBrowserWithInitialProjectiveView:trueCell.imageView index:currentIndex];
    }
}

- (HDCyclePagerViewLayout *)layoutForPagerView:(HDCyclePagerView *)pageView {
    HDCyclePagerViewLayout *layout = [[HDCyclePagerViewLayout alloc] init];
    layout.layoutType = HDCyclePagerTransformLayoutNormal;
    const CGFloat width = self.bannerView.size.width;
    const CGFloat height = self.bannerView.size.height;
    layout.itemSpacing = 0;
    layout.itemSize = CGSizeMake(width, height);

    return layout;
}

- (void)pagerView:(HDCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    if (!self.pageNoLabel.isHidden) {
        [self setPageNoWithIndex:toIndex + 1];
        self.model.currentPageIndex = toIndex + 1;
    }
    if (self.pagerViewChangePage) {
        self.pagerViewChangePage(toIndex);
    }
}
- (void)pagerViewDidScroll:(HDCyclePagerView *)pageView {
    if (self.dataSource > 0) {
        CGFloat maxOffsetX = (self.dataSource.count - 1) * self.bannerView.size.width;
        CGFloat space = pageView.contentOffset.x - maxOffsetX;
        if (space > 20) {
            // 方法节流
            [HDFunctionThrottle throttleWithInterval:0.3 key:@"pagerViewDidScroll" handler:^{
                !self.scrollerToRecommendSection ?: self.scrollerToRecommendSection();
            }];
        }
    }
}
#pragma mark - lazy load
- (HDCyclePagerView *)bannerView {
    if (!_bannerView) {
        _bannerView = HDCyclePagerView.new;
        _bannerView.autoScrollInterval = 0;
        _bannerView.isInfiniteLoop = NO;
        _bannerView.dataSource = self;
        _bannerView.delegate = self;
        [_bannerView registerClass:SASingleImageCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(SASingleImageCollectionViewCell.class)];
    }
    return _bannerView;
}

/** @lazy pageNolabel */
- (HDLabel *)pageNoLabel {
    if (!_pageNoLabel) {
        _pageNoLabel = [[HDLabel alloc] init];
        _pageNoLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _pageNoLabel.hd_edgeInsets = UIEdgeInsetsMake(2, 8, 2, 8);
        _pageNoLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = precedingFrame.size.height / 2.0;
            view.layer.masksToBounds = YES;
        };
    }
    return _pageNoLabel;
}
/** @lazy dataSource */
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
/** @lazy freeShippingImageView */
- (UIImageView *)freeShippingImageView {
    if (!_freeShippingImageView) {
        _freeShippingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_freeshipping"]];
        _freeShippingImageView.hidden = YES;
    }
    return _freeShippingImageView;
}
@end


@implementation TNProductBannerCellModel

@end
