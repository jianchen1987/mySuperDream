//
//  TNOrderListMoreProductCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNOrderListMoreProductCell.h"
#import "HDAppTheme+TinhNow.h"


@interface TNOrderListMoreProductCell ()
/// 查看更多按钮
@property (strong, nonatomic) HDUIButton *watchMoreBtn;
/// 三张图片数组
@property (strong, nonatomic) NSMutableArray *imageViewArray;
///  图片背景视图
@property (strong, nonatomic) UIView *imageBackView;
@end


@implementation TNOrderListMoreProductCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.watchMoreBtn];
    [self.contentView addSubview:self.imageBackView];
    [self.imageViewArray removeAllObjects];
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
        [self.imageBackView addSubview:imageView];
        [self.imageViewArray addObject:imageView];
    }

    [self.watchMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.imageBackView.mas_centerY);
        make.height.equalTo(self.imageBackView.mas_height);
        make.width.mas_equalTo(kRealWidth(70));
    }];
    [self.imageBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.right.equalTo(self.watchMoreBtn.mas_left);
    }];

    [self.imageViewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:kRealWidth(10) leadSpacing:kRealWidth(15) tailSpacing:0];
    UIView *imageView = self.imageViewArray.firstObject;
    [self.imageViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageBackView);
        make.bottom.equalTo(self.imageBackView);
        make.height.equalTo(imageView.mas_width);
    }];
}
- (void)setProductPicArr:(NSArray<NSString *> *)productPicArr {
    _productPicArr = productPicArr;
    for (int i = 0; i < self.imageViewArray.count; i++) {
        UIImageView *imageView = self.imageViewArray[i];
        NSString *imgStr;
        if (i < productPicArr.count) {
            imgStr = productPicArr[i];
        }
        [imageView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[HDHelper placeholderImage]];
    }
}
/** @lazy watchMoreBtn */
- (HDUIButton *)watchMoreBtn {
    if (!_watchMoreBtn) {
        _watchMoreBtn = [[HDUIButton alloc] init];
        _watchMoreBtn.imagePosition = HDUIButtonImagePositionTop;
        _watchMoreBtn.spacingBetweenImageAndTitle = 5;
        _watchMoreBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:10];
        [_watchMoreBtn setImage:[UIImage imageNamed:@"tn_watch_more"] forState:UIControlStateNormal];
        [_watchMoreBtn setTitle:TNLocalizedString(@"9fdM8aV0", @"查看更多") forState:UIControlStateNormal];
        [_watchMoreBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        _watchMoreBtn.userInteractionEnabled = NO;
    }
    return _watchMoreBtn;
}
/** @lazy imageViewArray */
- (NSMutableArray *)imageViewArray {
    if (!_imageViewArray) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}
/** @lazy imageBackView */
- (UIView *)imageBackView {
    if (!_imageBackView) {
        _imageBackView = [[UIImageView alloc] init];
    }
    return _imageBackView;
}
@end


@implementation TNOrderListMoreProductCellModel

@end
