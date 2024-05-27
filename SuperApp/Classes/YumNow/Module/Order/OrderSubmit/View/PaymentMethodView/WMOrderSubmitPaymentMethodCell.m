//
//  WMOrderSubmitPaymentMethodCell.m
//  SuperApp
//
//  Created by VanJay on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitPaymentMethodCell.h"


@interface WMOrderSubmitPaymentMethodCell ()
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 子标题
@property (nonatomic, strong) SALabel *subTitleLB;
/// 打勾
@property (nonatomic, strong) UIImageView *tickIV;
/// 顶部线
@property (nonatomic, strong) UIView *topLine;
/// 底部线
@property (nonatomic, strong) UIView *bottomLine;
/// 所有的支付方式图片
@property (nonatomic, strong) NSMutableArray *paymethodImageViewArray;
@end


@implementation WMOrderSubmitPaymentMethodCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.subTitleLB];
    [self.contentView addSubview:self.tickIV];
    [self.contentView addSubview:self.topLine];
    [self.contentView addSubview:self.bottomLine];

    [self.subTitleLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

#pragma mark - setter
- (void)setModel:(WMOrderSubmitPaymentMethodCellModel *)model {
    _model = model;

    self.topLine.hidden = !model.needTopLine;
    self.bottomLine.hidden = !model.needBottomLine;

    self.titleLB.text = model.title;
    self.subTitleLB.hidden = HDIsStringEmpty(model.subTitle);
    if (!self.subTitleLB.isHidden) {
        self.subTitleLB.text = model.subTitle;
    }
    [self.paymethodImageViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.paymethodImageViewArray removeAllObjects];

    for (NSString *imageName in model.imageNames) {
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        [self.contentView addSubview:imageV];
        [self.paymethodImageViewArray addObject:imageV];
    }
    [self setNeedsUpdateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.tickIV.hidden = !selected;
    [self setNeedsUpdateConstraints];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
        if (self.tickIV.isHidden) {
            make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        } else {
            make.right.equalTo(self.tickIV.mas_left).offset(-5);
        }
        make.top.equalTo(self.contentView).offset(kRealWidth(15));
        if (self.subTitleLB.isHidden && HDIsArrayEmpty(self.paymethodImageViewArray)) {
            make.bottom.equalTo(self.contentView).offset(-kRealWidth(15));
        }
    }];
    [self.subTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.subTitleLB.isHidden) {
            make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(10));
            make.left.equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
            if (self.tickIV.isHidden) {
                make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
            } else {
                make.right.equalTo(self.tickIV.mas_left).offset(-5);
            }
            if (HDIsArrayEmpty(self.paymethodImageViewArray)) {
                make.bottom.equalTo(self.contentView).offset(-kRealWidth(15));
            }
        }
    }];
    UIImageView *lastView;
    UIView *refView = self.subTitleLB.isHidden ? self.titleLB : self.subTitleLB;
    for (UIImageView *imageV in self.paymethodImageViewArray) {
        [imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
            //            make.top.greaterThanOrEqualTo(refView.mas_bottom).offset(kRealWidth(10));
            make.bottom.lessThanOrEqualTo(self.contentView).offset(-kRealWidth(15));
            if (!lastView) {
                make.left.equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
                make.top.equalTo(refView.mas_bottom).offset(kRealWidth(10));
            } else {
                make.left.equalTo(lastView.mas_right).offset(kRealWidth(7));
                //                make.centerY.equalTo(lastView);
                make.top.equalTo(lastView.mas_top);
            }
            make.size.mas_equalTo(imageV.image.size);
        }];
        lastView = imageV;
    }
    [self.tickIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.tickIV.isHidden) {
            make.size.mas_equalTo(self.tickIV.image.size);
            make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
            make.centerY.equalTo(self.contentView);
        }
    }];
    [self.topLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.topLine.isHidden) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo(PixelOne);
        }
    }];
    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.bottomLine.isHidden) {
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
            make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
            make.height.mas_equalTo(PixelOne);
        }
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2Bold;
        label.textColor = HDAppTheme.color.G2;
        label.numberOfLines = 0;
        _titleLB = label;
    }
    return _titleLB;
}

- (SALabel *)subTitleLB {
    if (!_subTitleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G3;
        label.numberOfLines = 0;
        _subTitleLB = label;
    }
    return _subTitleLB;
}

- (UIImageView *)tickIV {
    if (!_tickIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [[UIImage imageNamed:@"icon_tick"] hd_imageWithTintColor:HDAppTheme.color.C3];
        _tickIV = imageView;
    }
    return _tickIV;
}

- (NSMutableArray *)paymethodImageViewArray {
    if (!_paymethodImageViewArray) {
        _paymethodImageViewArray = NSMutableArray.array;
    }
    return _paymethodImageViewArray;
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = UIView.new;
        _topLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _topLine;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _bottomLine;
}
@end
