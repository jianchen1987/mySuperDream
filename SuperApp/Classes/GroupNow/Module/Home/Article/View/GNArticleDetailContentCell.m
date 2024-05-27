//
//  GNArticleDetailContentCell.m
//  SuperApp
//
//  Created by wmz on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNArticleDetailContentCell.h"
#import "GNStoreProductHeadCell.h"
#import <YYText/YYText.h>


@interface GNArticleDetailContentCell () <HDCyclePagerViewDataSource, HDCyclePagerViewDelegate>
/// title
@property (nonatomic, strong) YYLabel *titleLB;
/// content
@property (nonatomic, strong) YYLabel *contentLB;
/// 轮播
@property (nonatomic, strong) HDCyclePagerView *bannerView;
/// pageLabel
@property (nonatomic, strong) HDLabel *pageLabel;

@end


@implementation GNArticleDetailContentCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bannerView];
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.contentLB];
    [self.contentView addSubview:self.pageLabel];
}

- (void)updateConstraints {
    [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(self.model.showHigh);
    }];

    [self.pageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bannerView.mas_bottom).offset(-kRealWidth(8));
        make.right.equalTo(self.bannerView.mas_right).offset(-kRealWidth(16));
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.mas_bottom).offset(kRealWidth(16));
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
    }];

    [self.contentLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(8));
        make.left.right.equalTo(self.titleLB);
        make.bottom.mas_equalTo(-kRealWidth(16));
    }];

    [super updateConstraints];
}

- (void)setGNModel:(GNArticleModel *)data {
    if ([data isKindOfClass:GNArticleModel.class]) {
        self.model = data;
        [self.bannerView reloadData];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:GNFillEmpty(data.articleName.desc)];
        str.yy_color = HDAppTheme.color.gn_333Color;
        str.yy_font = [HDAppTheme.font gn_boldForSize:20];
        str.yy_paragraphSpacing = kRealWidth(5);
        self.titleLB.attributedText = str;
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[GNFillEmpty(data.content.desc) dataUsingEncoding:NSUnicodeStringEncoding]
                                                                            options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                                 documentAttributes:nil
                                                                              error:nil];
        self.contentLB.attributedText = attributeStr;
        [self setNeedsUpdateConstraints];
    }
}

#pragma mark - HDCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(HDCyclePagerView *)pageView {
    return self.model.imagePathArr.count;
}

- (UICollectionViewCell *)pagerView:(HDCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    GNProductBannerItem *cell = [GNProductBannerItem cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
    NSString *pathModel = self.model.imagePathArr[index];
    cell.iconIV.contentMode = UIViewContentModeCenter;
    [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:pathModel] placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(355), kRealWidth(150)) logoWidth:kRealWidth(32)]
                          completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                              if (image.size.width != kScreenWidth) {
                                  cell.iconIV.image = [image imageCompressForWidth:image targetWidth:kScreenWidth];
                              }
                          }];
    cell.iconIV.layer.cornerRadius = 0;
    cell.iconIV.couponLB.hidden = YES;
    return cell;
}

- (HDCyclePagerViewLayout *)layoutForPagerView:(HDCyclePagerView *)pageView {
    HDCyclePagerViewLayout *layout = [[HDCyclePagerViewLayout alloc] init];
    layout.layoutType = HDCyclePagerTransformLayoutNormal;
    const CGFloat width = CGRectGetWidth(pageView.frame);
    const CGFloat height = CGRectGetHeight(pageView.frame);
    layout.itemSpacing = 0;
    layout.itemSize = CGSizeMake(width, height);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return layout;
}

- (void)pagerView:(HDCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    if (fromIndex < self.model.imagePathArr.count) {
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", toIndex + 1, self.model.imagePathArr.count];
    }
}

- (HDLabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = HDLabel.new;
        _pageLabel.layer.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.6].CGColor;
        _pageLabel.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(3), kRealWidth(8.5), kRealWidth(3), kRealWidth(8.5));
        _pageLabel.textColor = HDAppTheme.color.gn_whiteColor;
        _pageLabel.font = [HDAppTheme.font gn_ForSize:10];
        _pageLabel.layer.cornerRadius = kRealWidth(10);
        _pageLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = precedingFrame.size.height / 2.0;
        };
    }
    return _pageLabel;
}

- (YYLabel *)titleLB {
    if (!_titleLB) {
        YYLabel *la = YYLabel.new;
        la.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(24);
        la.numberOfLines = 0;
        _titleLB = la;
    }
    return _titleLB;
}

- (YYLabel *)contentLB {
    if (!_contentLB) {
        YYLabel *la = YYLabel.new;
        la.textColor = HDAppTheme.color.gn_999Color;
        la.font = [HDAppTheme.font gn_ForSize:14];
        la.numberOfLines = 0;
        la.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(24);
        la.displaysAsynchronously = YES;
        _contentLB = la;
    }
    return _contentLB;
}

- (HDCyclePagerView *)bannerView {
    if (!_bannerView) {
        _bannerView = HDCyclePagerView.new;
        _bannerView.autoScrollInterval = 0;
        _bannerView.dataSource = self;
        _bannerView.delegate = self;
        [_bannerView registerClass:GNProductBannerItem.class forCellWithReuseIdentifier:NSStringFromClass(GNProductBannerItem.class)];
    }
    return _bannerView;
}

@end
