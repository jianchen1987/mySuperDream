//
//  TNPictureSearchProductCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNPictureSearchProductCell.h"


@interface TNPictureSearchProductCell ()
/// 背景
@property (nonatomic, strong) UIView *containerView;
/// 商品图片
@property (nonatomic, strong) UIImageView *productImageView;
/// 商品名
//@property (nonatomic, strong) UILabel *productNameLabel;
///// 想买背景
//@property (strong, nonatomic) UIView *wantbuyContainerView;
///// 心图标
//@property (strong, nonatomic) UIImageView *wantbuyImageView;
///// 想买文本
//@property (strong, nonatomic) UILabel *wantbuyLabel;
/// 门店背景点击
@property (strong, nonatomic) UIControl *storeControl;
/// 门店名称
@property (nonatomic, strong) UILabel *storeNameLabel;
/// 箭头
@property (nonatomic, strong) UIImageView *arrowImageView;
@end


@implementation TNPictureSearchProductCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.productImageView];
    //    [self.containerView addSubview:self.productNameLabel];
    [self.containerView addSubview:self.storeControl];
    [self.storeControl addSubview:self.storeNameLabel];
    [self.storeControl addSubview:self.arrowImageView];
}
#pragma mark -点击前往店铺
- (void)gotoStoreClick {
    [SAWindowManager openUrl:@"SuperApp://TinhNow/StoreInfo" withParameters:@{@"storeNo": self.model.storeNo}];
}
- (void)setModel:(TNPictureSearchModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.thumbnail placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(100, 100)] imageView:self.productImageView];
    //    self.productNameLabel.attributedText = model.nameAttr;
    //    self.productNameLabel.numberOfLines = 2;
    self.storeNameLabel.text = model.storeName;
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.productImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.containerView);
        make.height.equalTo(self.contentView.mas_width).multipliedBy(1.0);
    }];
    //    [self.productNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.productImageView.mas_bottom).offset(kRealWidth(10));
    //        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(8));
    //        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(8));
    //    }];
    //    [self.wantbuyContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.productNameLabel.mas_bottom).offset(kRealWidth(10));
    //        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(8));
    //        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(8));
    //        make.height.mas_equalTo(kRealWidth(25));
    //    }];
    //    [self.wantbuyImageView sizeToFit];
    //    [self.wantbuyImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(self.wantbuyContainerView.mas_centerY);
    //        make.left.equalTo(self.self.wantbuyContainerView.mas_left).offset(kRealWidth(6));
    //    }];
    //    [self.wantbuyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(self.wantbuyContainerView.mas_centerY);
    //        make.left.equalTo(self.self.wantbuyImageView.mas_right).offset(kRealWidth(2));
    //        make.right.equalTo(self.self.wantbuyContainerView.mas_right).offset(-kRealWidth(6));
    //    }];
    [self.storeControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self.productNameLabel.mas_bottom).offset(kRealWidth(10));
        make.top.equalTo(self.productImageView.mas_bottom).offset(kRealWidth(10));
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(8));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(8));
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-kRealWidth(10));
    }];
    [self.storeNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storeControl);
        make.centerY.equalTo(self.storeControl);
        //        make.top.equalTo(self.storeControl.mas_top).offset(kRealWidth(5));
        //        make.bottom.equalTo(self.storeControl.mas_bottom).offset(-kRealWidth(5));
        make.right.lessThanOrEqualTo(self.arrowImageView.mas_left).offset(-kRealWidth(8));
    }];
    [self.arrowImageView sizeToFit];
    [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.storeNameLabel.mas_centerY);
        make.right.equalTo(self.storeControl.mas_right);
        make.size.mas_equalTo(self.arrowImageView.image.size);
    }];
    [super updateConstraints];
}
/** @lazy containerView */
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8.0];
        };
    }
    return _containerView;
}
/** @lazy goodImageView */
- (UIImageView *)productImageView {
    if (!_productImageView) {
        _productImageView = [[UIImageView alloc] init];
    }
    return _productImageView;
}
/** @lazy goodNameLabel */
//- (UILabel *)productNameLabel {
//    if (!_productNameLabel) {
//        _productNameLabel = [[UILabel alloc] init];
//        _productNameLabel.font = HDAppTheme.TinhNowFont.standard15;
//        _productNameLabel.textColor = HDAppTheme.TinhNowColor.G1;
//        _productNameLabel.numberOfLines = 2;
//    }
//    return _productNameLabel;
//}
/** @lazy storeControl */
- (UIControl *)storeControl {
    if (!_storeControl) {
        _storeControl = [[UIControl alloc] init];
        [_storeControl addTarget:self action:@selector(gotoStoreClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _storeControl;
}
/** @lazy storeNameLabel */
- (UILabel *)storeNameLabel {
    if (!_storeNameLabel) {
        _storeNameLabel = [[UILabel alloc] init];
        _storeNameLabel.font = HDAppTheme.TinhNowFont.standard12;
        _storeNameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _storeNameLabel.numberOfLines = 2;
    }
    return _storeNameLabel;
}
/** @lazy arrowImageView */
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_gray_small"]];
    }
    return _arrowImageView;
}
///** @lazy wantbuyContainerView */
//- (UIView *)wantbuyContainerView {
//    if (!_wantbuyContainerView) {
//        _wantbuyContainerView = [[UIView alloc] init];
//        _wantbuyContainerView.backgroundColor = [UIColor colorWithRed:255/255.0 green:143/255.0 blue:26/255.0 alpha:0.15];
//        _wantbuyContainerView.hd_frameDidChangeBlock = ^(__kindof UIView * _Nonnull view, CGRect precedingFrame) {
//            [view setRoundedCorners:UIRectCornerAllCorners radius:13];
//        };
//    }
//    return _wantbuyContainerView;
//}
///** @lazy wantbuyImageView */
//- (UIImageView *)wantbuyImageView {
//    if (!_wantbuyImageView) {
//        _wantbuyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_picture_search_like"]];
//    }
//    return _wantbuyImageView;
//}
///** @lazy wantbuyLabel */
//- (UILabel *)wantbuyLabel {
//    if (!_wantbuyLabel) {
//        _wantbuyLabel = [[UILabel alloc] init];
//        _wantbuyLabel.textColor = HDAppTheme.TinhNowColor.C1;
//        _wantbuyLabel.font = HDAppTheme.TinhNowFont.standard14;
//    }
//    return _wantbuyLabel;
//}
@end
