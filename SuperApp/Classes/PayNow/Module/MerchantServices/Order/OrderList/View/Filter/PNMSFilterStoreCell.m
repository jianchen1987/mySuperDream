//
//  PNMSFilterStoreCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSFilterStoreCell.h"
#import "PNMSBillFilterModel.h"


@interface PNMSFilterStoreCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) SALabel *valueLaebl;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) HDUIButton *btn;
@end


@implementation PNMSFilterStoreCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.valueLaebl];
    [self.bgView addSubview:self.arrowImgView];
    [self.bgView addSubview:self.btn];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [self.valueLaebl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.bgView);
        make.right.mas_equalTo(self.arrowImgView.mas_left).offset(-kRealWidth(16));
    }];

    [self.arrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.arrowImgView.image.size);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
    }];

    [self.btn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
    [super updateConstraints];
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    //     获取自适应size
    //    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.width = kScreenWidth - kRealWidth(30);
    newFrame.size.height = kRealWidth(44);
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

#pragma mark
- (void)setValueTitle:(NSString *)valueTitle {
    _valueTitle = valueTitle;
    self.valueLaebl.text = self.valueTitle;
}

#pragma mark
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    }
    return _bgView;
}

- (SALabel *)valueLaebl {
    if (!_valueLaebl) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(12), kRealWidth(12), 0);
        label.text = PNLocalizedString(@"pn_all_store", @"全部门店");
        _valueLaebl = label;
    }
    return _valueLaebl;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_arrow_down_small"];
        _arrowImgView = imageView;
    }
    return _arrowImgView;
}

- (HDUIButton *)btn {
    if (!_btn) {
        _btn = [HDUIButton buttonWithType:UIButtonTypeCustom];

        @HDWeakify(self);
        [_btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.clickBtnBlock ?: self.clickBtnBlock();
        }];
    }
    return _btn;
}
@end
