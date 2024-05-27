//
//  PNUploadIDImageView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/1/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNUploadIDImageView.h"
#import "PNUploadImageItemView.h"


@interface PNUploadIDImageView ()

@property (nonatomic, strong) SALabel *titleLabl;
@property (nonatomic, strong) PNUploadImageItemView *leftView;
@property (nonatomic, strong) PNUploadImageItemView *rightView;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;
@end


@implementation PNUploadIDImageView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    // 4: 3
    self.itemWidth = (kScreenWidth - (kRealWidth(15) * 2 + kRealWidth(25))) / 2.f;
    self.itemHeight = self.itemWidth * 3 / 4;

    [self addSubview:self.titleLabl];
    [self addSubview:self.leftView];
    [self addSubview:self.rightView];
    [self addSubview:self.line];
}

- (void)updateConstraints {
    [self.titleLabl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(15));
    }];

    /// 4：3
    [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.size.mas_equalTo(CGSizeMake(self.itemWidth, self.itemHeight));
        make.top.mas_equalTo(self.titleLabl.mas_bottom).offset(kRealWidth(15));
    }];

    [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftView.mas_right).offset(kRealWidth(25));
        make.size.mas_equalTo(CGSizeMake(self.itemWidth, self.itemHeight));
        make.top.mas_equalTo(self.leftView.mas_top);
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(PixelOne));
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.leftView.mas_bottom).offset(kRealWidth(15));
        make.bottom.mas_equalTo(self.mas_bottom);
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setLeftURL:(NSString *)leftURL {
    _leftURL = leftURL;
    self.leftView.urlStr = leftURL;
}

- (void)setRightURL:(NSString *)rightURL {
    _rightURL = rightURL;
    self.rightView.urlStr = rightURL;
}

- (void)setLeftTitleStr:(NSString *)leftTitleStr {
    _leftTitleStr = leftTitleStr;
    if (WJIsStringNotEmpty(self.leftTitleStr)) {
        self.leftView.tipsStr = leftTitleStr;
    } else {
        self.leftView.tipsStr = PNLocalizedString(@"upload_front_photo", @"点击上传证件正面照片");
    }
    [self setNeedsUpdateConstraints];
}

- (void)setRightTitleStr:(NSString *)rightTitleStr {
    _rightTitleStr = rightTitleStr;
    if (WJIsStringNotEmpty(self.rightTitleStr)) {
        self.rightView.tipsStr = rightTitleStr;
    } else {
        self.rightView.tipsStr = PNLocalizedString(@"upload_back_photo", @"点击上传证件反面照片");
    }
    [self setNeedsUpdateConstraints];
}

- (void)setIsCanSelectDefaultPhoto:(BOOL)isCanSelectDefaultPhoto {
    _isCanSelectDefaultPhoto = isCanSelectDefaultPhoto;
    self.rightView.isCanSelectDefaultPhoto = self.isCanSelectDefaultPhoto;
}

- (void)setIsHiddeRightView:(BOOL)isHiddeRightView {
    _isHiddeRightView = isHiddeRightView;
    self.rightView.hidden = isHiddeRightView;
}

#pragma mark
- (SALabel *)titleLabl {
    if (!_titleLabl) {
        _titleLabl = [[SALabel alloc] init];
        _titleLabl.textColor = HDAppTheme.PayNowColor.c343B4D;
        _titleLabl.font = HDAppTheme.PayNowFont.standard15;
        _titleLabl.text = PNLocalizedString(@"upload_legal_photo", @"请上传证件照片");
    }
    return _titleLabl;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HDAppTheme.PayNowColor.lineColor;
    }
    return _line;
}

- (PNUploadImageItemView *)leftView {
    if (!_leftView) {
        _leftView = [[PNUploadImageItemView alloc] init];
        _leftView.tipsStr = PNLocalizedString(@"upload_front_photo", @"点击上传证件正面照片");
        @HDWeakify(self);
        _leftView.buttonEnableBlock = ^(NSString *_Nonnull url) {
            @HDStrongify(self);
            !self.refreshLeftResultBlock ?: self.refreshLeftResultBlock(url);
        };
    }
    return _leftView;
}

- (PNUploadImageItemView *)rightView {
    if (!_rightView) {
        _rightView = [[PNUploadImageItemView alloc] init];
        _rightView.tipsStr = PNLocalizedString(@"upload_back_photo", @"点击上传证件反面照片");
        @HDWeakify(self);
        _rightView.buttonEnableBlock = ^(NSString *_Nonnull url) {
            @HDStrongify(self);
            !self.refreshRightResultBlock ?: self.refreshRightResultBlock(url);
        };
    }
    return _rightView;
}
@end
