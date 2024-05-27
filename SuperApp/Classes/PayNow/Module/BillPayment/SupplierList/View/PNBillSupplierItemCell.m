//
//  PNBillSupplierItemCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBillSupplierItemCell.h"
#import "PNBillSupplierInfoModel.h"


@interface PNBillSupplierItemCell ()
@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) UIView *line;
@end


@implementation PNBillSupplierItemCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.logoImgView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.line];
}

- (void)updateConstraints {
    [self.logoImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(40), 40));
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.mas_equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(kRealWidth(-15));
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logoImgView.mas_right).offset(kRealWidth(5));
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-15));
        make.centerY.mas_equalTo(self.logoImgView.mas_centerY);
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-15));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(kRealWidth(-1));
        make.height.equalTo(@(PixelOne));
    }];

    [super updateConstraints];
}

- (void)setModel:(PNBillSupplierInfoModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.logo size:CGSizeMake(kRealWidth(40), kRealWidth(40)) placeholderImage:[UIImage imageNamed:@"pn_placeholderImage_square"] imageView:self.logoImgView];
    NSString *str = model.payeeMerName;
    if (WJIsStringNotEmpty(model.payeeMerNo)) {
        str = [NSString stringWithFormat:@"%@-%@", model.payeeMerNo, model.payeeMerName];
    }
    self.titleLabel.text = str;
    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UIImageView *)logoImgView {
    if (!_logoImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.masksToBounds = YES;

        _logoImgView = imageView;
        _logoImgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(2)];
        };
    }
    return _logoImgView;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.numberOfLines = 2;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIView *)line {
    if (!_line) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;
        _line = view;
    }
    return _line;
}

@end
