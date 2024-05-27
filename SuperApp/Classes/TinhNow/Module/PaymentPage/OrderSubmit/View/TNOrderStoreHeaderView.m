//
//  TNOrderStoreHeaderView.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNOrderStoreHeaderView.h"
#import "HDAppTheme+TinhNow.h"
#import "HDMediator+TinhNow.h"
#import "SATalkingData.h"
#import <HDUIKit/HDUIKit.h>
#import <Masonry/Masonry.h>


@implementation TNOrderStoreHeaderModel

@end


@interface TNOrderStoreHeaderView ()
/// 背景图
@property (strong, nonatomic) UIView *bgView;
/// 店铺图片
@property (strong, nonatomic) UIImageView *storeIV;
/// 店铺名称
@property (strong, nonatomic) HDLabel *storeNameLB;
/// 店铺类型标签
@property (strong, nonatomic) UIImageView *storeTypeTagImageView;
/// 右箭头图片
@property (strong, nonatomic) UIImageView *rightIV;
/// 店铺底部线条
@property (nonatomic, strong) UIView *storeViewLine;
@end


@implementation TNOrderStoreHeaderView
- (void)hd_setupViews {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.storeIV];
    [self.bgView addSubview:self.storeNameLB];
    [self.bgView addSubview:self.storeTypeTagImageView];
    [self.bgView addSubview:self.rightIV];
    [self.bgView addSubview:self.storeViewLine];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storeClick:)];
    [self addGestureRecognizer:tap];
}
- (void)storeClick:(UITapGestureRecognizer *)tap {
    if (self.model.isNeedShowStoreRightIV) {
        !self.goStoreTrackEventCallBack ?: self.goStoreTrackEventCallBack();
        [HDMediator.sharedInstance navigaveToTinhNowStoreInfoViewController:@{@"storeNo": self.model.storeId}];
    }
}
- (void)setModel:(TNOrderStoreHeaderModel *)model {
    _model = model;
    self.storeNameLB.text = model.storeName;
    if ([model.storeType isEqualToString:TNStoreTypeSelf]) {
        self.storeTypeTagImageView.image = [UIImage imageNamed:@"tn_offcial_k"];
    } else if ([model.storeType isEqualToString:TNStoreTypeOverseasShopping]) {
        self.storeTypeTagImageView.image = [UIImage imageNamed:@"tn_global_k"];
    } else {
        self.storeTypeTagImageView.hidden = YES;
    }
    self.rightIV.hidden = !model.isNeedShowStoreRightIV;
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.storeIV sizeToFit];
    [self.storeIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.left.equalTo(self.bgView.mas_left).offset(kRealWidth(15));
    }];
    [self.storeNameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.left.equalTo(self.storeIV.mas_right).offset(5);
        if (self.storeTypeTagImageView.isHidden) {
            make.right.lessThanOrEqualTo(self.rightIV.mas_left).offset(-10);
        }
    }];
    if (!self.storeTypeTagImageView.isHidden) {
        [self.storeTypeTagImageView sizeToFit];
        [self.storeTypeTagImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bgView.mas_centerY);
            make.left.mas_equalTo(self.storeNameLB.mas_right).offset(10);
            make.right.lessThanOrEqualTo(self.rightIV.mas_left).offset(-10);
        }];
    }
    [self.rightIV sizeToFit];
    [self.rightIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(15));
    }];
    [self.storeViewLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.bgView.mas_bottom);
        make.height.mas_equalTo(PixelOne);
    }];
    [self.storeNameLB setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [super updateConstraints];
}

/** @lazy storeIV */
- (UIImageView *)storeIV {
    if (!_storeIV) {
        _storeIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_tinhnow_store_icon"]];
    }
    return _storeIV;
}
/** @lazy storeNameLB */
- (HDLabel *)storeNameLB {
    if (!_storeNameLB) {
        _storeNameLB = [[HDLabel alloc] init];
        _storeNameLB.font = [HDAppTheme.TinhNowFont fontMedium:17];
        _storeNameLB.textColor = HDAppTheme.TinhNowColor.G1;
    }
    return _storeNameLB;
}
/** @lazy storeTypeTagImageView */
- (UIImageView *)storeTypeTagImageView {
    if (!_storeTypeTagImageView) {
        _storeTypeTagImageView = [[UIImageView alloc] init];
    }
    return _storeTypeTagImageView;
}
/** @lazy rightIV */
- (UIImageView *)rightIV {
    if (!_rightIV) {
        _rightIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_gray_small"]];
    }
    return _rightIV;
}
/** @lazy storeViewLine */
- (UIView *)storeViewLine {
    if (!_storeViewLine) {
        _storeViewLine = [[UIView alloc] init];
        _storeViewLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _storeViewLine;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
@end
