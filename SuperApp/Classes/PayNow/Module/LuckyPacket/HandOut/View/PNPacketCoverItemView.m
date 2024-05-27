//
//  PNPacketCoverItemView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketCoverItemView.h"
#import "PNHandOutViewModel.h"
#import "UIColor+Extend.h"


@interface PNPacketCoverItemView ()
@property (nonatomic, strong) PNHandOutViewModel *viewModel;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView;
@end


@implementation PNPacketCoverItemView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:kRealWidth(8)];
        view.backgroundColor = [UIColor tn_colorGradientChangeWithSize:view.frame.size direction:TNGradientChangeDirectionLevel startColor:[UIColor hd_colorWithHexString:@"#FFF8F7"]
                                                              endColor:[UIColor hd_colorWithHexString:@"#FFE0E4"]];
    };

    [self addSubview:self.titleLabel];
    [self addSubview:self.imgView];
}

- (void)updateConstraints {
    [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.size.mas_equalTo(self.imgView.image.size);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(48), kRealWidth(48)));
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(12));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kRealWidth(12));
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.imgView.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
    }];

    [super updateConstraints];
}

- (void)refreshFlagImage {
    [HDWebImageManager setImageWithURL:self.viewModel.model.imageUrl placeholderImage:[UIImage imageNamed:@"pn_handout_cover"] imageView:self.imgView];
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14M;
        label.text = PNLocalizedString(@"pn_cover_default", @"封面（默认）");
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_handout_cover"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        _imgView = imageView;
    }
    return _imgView;
}

@end
