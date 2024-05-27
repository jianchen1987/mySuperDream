//
//  SAChangeAreaCodeView.m
//  SuperApp
//
//  Created by Tia on 2022/9/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SALoginAreaCodeView.h"
#import "SACacheManager.h"
#import "SAChangeCountryViewProvider.h"
#import "SALoginSelectAreaCodeAlertView.h"


@interface SALoginAreaCodeView ()
/// 标题
@property (nonatomic, strong) UILabel *titleLB;
/// 箭头
@property (nonatomic, strong) UIImageView *imageView;
/// 底部线条
@property (nonatomic, strong) UIView *bottomLine;
/// 当前国家码模型
@property (nonatomic, strong) SACountryModel *currentCountryModel;

@end


@implementation SALoginAreaCodeView
- (void)hd_setupViews {
    [self addSubview:self.titleLB];
    [self addSubview:self.imageView];
    [self addSubview:self.bottomLine];

    // 获取默认标题
    SACountryModel *cachedModel = [SACacheManager.shared objectPublicForKey:kCacheKeyUserLastChoosedAreaCode];
    NSArray<SACountryModel *> *filtered;
    if (!cachedModel || ![cachedModel isKindOfClass:SACountryModel.class]) {
        filtered = [SAChangeCountryViewProvider.areaCodedataSource hd_filterWithBlock:^BOOL(SACountryModel *_Nonnull item) {
            return [item.countryCode isEqualToString:@"855"];
        }];
        cachedModel = filtered.firstObject;
        [SACacheManager.shared setPublicObject:cachedModel forKey:kCacheKeyUserLastChoosedAreaCode];
    } else {
        filtered = [SAChangeCountryViewProvider.areaCodedataSource hd_filterWithBlock:^BOOL(SACountryModel *_Nonnull item) {
            return [item.countryCode isEqualToString:cachedModel.countryCode];
        }];
        cachedModel = filtered.firstObject;
    }
    self.currentCountryModel = cachedModel;
    self.titleLB.text = cachedModel.fullCountryCode;

    [self addGestureRecognizer:self.hd_tapRecognizer];
}

- (void)updateConstraints {
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.imageView.image.size);
        make.centerY.equalTo(self.titleLB);
        make.left.equalTo(self);
    }];

    [self.titleLB sizeToFit];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(kRealWidth(4));
        make.width.mas_equalTo(kRealWidth(36));
        make.right.equalTo(self);
        make.centerY.equalTo(self);
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.bottom.equalTo(self);
        make.height.mas_equalTo(1.f);
    }];
    [super updateConstraints];
}

#pragma mark - event response
- (void)hd_clickedViewHandler {
    [self.window endEditing:true];
    SALoginSelectAreaCodeAlertView *alertView = SALoginSelectAreaCodeAlertView.new;
    alertView.selectedItemHandler = ^(SACountryModel *_Nonnull model) {
        if (model) {
            [SACacheManager.shared setPublicObject:model forKey:kCacheKeyUserLastChoosedAreaCode];
            if ([self.currentCountryModel.countryCode isEqualToString:model.countryCode])
                return;
            self.currentCountryModel = model;
            !self.choosedCountryBlock ?: self.choosedCountryBlock(model);
        }
    };
    [alertView show];
}

#pragma mark - public methods
- (void)setCountryWithCountryCode:(NSString *)countryCode {
    if (HDIsStringEmpty(countryCode))
        return;

    NSArray<SACountryModel *> *filtered = [SAChangeCountryViewProvider.areaCodedataSource hd_filterWithBlock:^BOOL(SACountryModel *_Nonnull item) {
        return [item.countryCode isEqualToString:countryCode];
    }];
    if (filtered.count > 0) {
        SACountryModel *model = filtered.firstObject;
        [SACacheManager.shared setPublicObject:model forKey:kCacheKeyUserLastChoosedAreaCode];
        if ([self.currentCountryModel.countryCode isEqualToString:model.countryCode])
            return;
        self.currentCountryModel = model;
        self.titleLB.text = model.fullCountryCode;
    }
}

- (UILabel *)titleLabel {
    return self.titleLB;
}

#pragma mark - setter
- (void)setCurrentCountryModel:(SACountryModel *)model {
    _currentCountryModel = model;
    self.titleLB.text = model.fullCountryCode;
    self.imageView.image = [model.countryCode isEqualToString:@"86"] ? [UIImage imageNamed:@"icon_flag_cn"] : [UIImage imageNamed:@"icon_flag_km"];
}

#pragma mark - lazy load
- (UILabel *)titleLB {
    if (!_titleLB) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = HDAppTheme.color.sa_C333;
        label.font = [HDAppTheme.font sa_fontDINMedium:14];
        _titleLB = label;
    }
    return _titleLB;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"icon_flag_km"];
        _imageView = imageView;
    }
    return _imageView;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _bottomLine;
}

@end
