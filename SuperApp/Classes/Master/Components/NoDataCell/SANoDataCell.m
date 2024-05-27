//
//  SANoDataCell.m
//  SuperApp
//
//  Created by VanJay on 2020/4/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SANoDataCell.h"


@interface SANoDataCell ()
@property (nonatomic, strong) UIView *containerView; ///< 占位 View
@property (nonatomic, strong) UIImageView *imageV;   ///< 图片
@property (nonatomic, strong) UILabel *descLabel;    ///< 描述
@property (nonatomic, strong) HDUIButton *bottomBtn; ///< 底部按钮

@end


@implementation SANoDataCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.imageV];
    [self.containerView addSubview:self.descLabel];
    [self.containerView addSubview:self.bottomBtn];
}

- (void)updateConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.width.equalTo(self.contentView);
        make.top.equalTo(self.imageV);
        make.bottom.equalTo(self.bottomBtn);
    }];

    [self.imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (CGSizeEqualToSize(CGSizeZero, self.model.imageSize)) {
            make.size.mas_equalTo(self.imageV.image.size);
        } else {
            make.size.mas_equalTo(self.model.imageSize);
        }
        make.centerX.equalTo(self.containerView);
        make.top.greaterThanOrEqualTo(self.contentView).offset(self.model.marginImageToTop);
    }];

    [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.containerView).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.top.equalTo(self.imageV.mas_bottom).offset(self.model.marginDescToImage);
        make.centerX.equalTo(self.containerView);
    }];

    [self.bottomBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(self.model.marginBtnToDesc);
        if (self.model.btnInfo[@"offset"]) {
            make.left.equalTo(self.containerView.mas_left).offset([self.model.btnInfo[@"offset"] floatValue]);
            make.right.equalTo(self.containerView.mas_right).offset(-[self.model.btnInfo[@"offset"] floatValue]);
        } else {
            make.left.equalTo(self.containerView.mas_left).offset(HDAppTheme.value.padding.left);
            make.right.equalTo(self.containerView.mas_right).offset(-HDAppTheme.value.padding.right);
        }
    }];

    [super updateConstraints];
}

#pragma mark - event response
- (void)bottomBtnHandler:(HDUIButton *)btn {
    if (_BlockOnClockBottomBtn) {
        _BlockOnClockBottomBtn();
    }
    if (self.model.BlockOnClockBottomBtn) {
        self.model.BlockOnClockBottomBtn();
    }
}

#pragma mark -  setters
- (void)setModel:(SANoDataCellModel *)model {
    _model = model;

    self.imageV.image = model.image;
    self.descLabel.text = model.descText;
    self.descLabel.font = model.descFont;
    self.bottomBtn.hidden = YES;
    if (!HDIsStringEmpty(model.bottomBtnTitle)) {
        self.bottomBtn.hidden = NO;
        self.bottomBtn.titleEdgeInsets = model.btnEdgeInsets;
        [self.bottomBtn setTitle:model.bottomBtnTitle forState:UIControlStateNormal];
        if (model.btnInfo) {
            UIColor *backColor = model.btnInfo[@"backColor"];
            UIColor *borderColor = model.btnInfo[@"borderColor"];
            self.bottomBtn.layer.backgroundColor = backColor.CGColor;
            self.bottomBtn.layer.cornerRadius = kRealWidth(20);
            self.bottomBtn.layer.borderWidth = HDAppTheme.value.pixelOne;
            self.bottomBtn.layer.borderColor = borderColor.CGColor;
        }
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIView *)containerView {
    return _containerView ?: ({ _containerView = UIView.new; });
}

- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = UIImageView.new;
        _imageV.image = [UIImage imageNamed:@"no_data_placeholder"];
    }
    return _imageV;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = UILabel.new;
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.textColor = HDAppTheme.color.G3;
        _descLabel.font = HDAppTheme.font.standard3;
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

- (HDUIButton *)bottomBtn {
    if (!_bottomBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDColor(250, 29, 57, 1) forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = HDAppTheme.font.standard3;
        [button addTarget:self action:@selector(bottomBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
        _bottomBtn = button;
        _bottomBtn.hidden = YES;
    }
    return _bottomBtn;
}
@end
