//
//  SAChangeCountryEntryView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAChangeCountryEntryView.h"
#import "SACacheManager.h"
#import "SAChangeCountryViewPresenter.h"
#import "SAChangeCountryViewProvider.h"
#import "SALoginSelectAreaCodeAlertView.h"


@interface SAChangeCountryEntryView ()
/// 标题
@property (nonatomic, strong) UILabel *titleLB;
/// 箭头
@property (nonatomic, strong) UIImageView *arrowImageView;
/// 底部线条
@property (nonatomic, strong) UIView *bottomLine;
/// 当前国家码模型
@property (nonatomic, strong) SACountryModel *currentCountryModel;
@end


@implementation SAChangeCountryEntryView
- (void)hd_setupViews {
    [self addSubview:self.titleLB];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.bottomLine];

    // 获取默认标题
    SACountryModel *cachedModel = [SACacheManager.shared objectPublicForKey:kCacheKeyUserLastChoosedCountry];
    NSArray<SACountryModel *> *filtered;
    if (!cachedModel || ![cachedModel isKindOfClass:SACountryModel.class]) {
        filtered = [SAChangeCountryViewProvider.dataSource hd_filterWithBlock:^BOOL(SACountryModel *_Nonnull item) {
            return [item.countryCode isEqualToString:@"855"];
        }];
        cachedModel = filtered.firstObject;
        [SACacheManager.shared setPublicObject:cachedModel forKey:kCacheKeyUserLastChoosedCountry];
    } else {
        filtered = [SAChangeCountryViewProvider.dataSource hd_filterWithBlock:^BOOL(SACountryModel *_Nonnull item) {
            return [item.countryCode isEqualToString:cachedModel.countryCode];
        }];
        cachedModel = filtered.firstObject;
    }
    self.currentCountryModel = cachedModel;
    self.titleLB.text = cachedModel.fullCountryCode;

    [self addGestureRecognizer:self.hd_tapRecognizer];
}

- (void)updateConstraints {
    [self.titleLB sizeToFit];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.mas_equalTo(kRealWidth(45));
    }];

    [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.arrowImageView.image.size);
        make.centerY.equalTo(self.titleLB);
        make.right.equalTo(self).offset(-5);
        make.left.equalTo(self.titleLB.mas_right).offset(10);
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
    [self performSelectAnimation];

    @HDWeakify(self);
    [SAChangeCountryViewPresenter showChangeCountryViewViewWithChoosedItemHandler:^(SACountryModel *_Nonnull model) {
        @HDStrongify(self);
        [self performDeSelectAnimation];
        if (model) {
            [SACacheManager.shared setPublicObject:model forKey:kCacheKeyUserLastChoosedCountry];
            if ([self.currentCountryModel.countryCode isEqualToString:model.countryCode])
                return;
            self.currentCountryModel = model;
            self.titleLB.text = model.fullCountryCode;
            !self.choosedCountryBlock ?: self.choosedCountryBlock(model);
        }
    }];

    //    SASelectAreaCodeAlertView *alertView = SASelectAreaCodeAlertView.new;
    //    alertView.selectedItemHandler = ^(SACountryModel * _Nonnull model) {
    //        HDLog(@"%@",model.displayText);
    //    };
    //    [alertView show];
}

#pragma mark - public methods
- (void)setCountryWithCountryCode:(NSString *)countryCode {
    if (HDIsStringEmpty(countryCode))
        return;

    NSArray<SACountryModel *> *filtered = [SAChangeCountryViewProvider.dataSource hd_filterWithBlock:^BOOL(SACountryModel *_Nonnull item) {
        return [item.countryCode isEqualToString:countryCode];
    }];
    if (filtered.count > 0) {
        SACountryModel *model = filtered.firstObject;
        [SACacheManager.shared setPublicObject:model forKey:kCacheKeyUserLastChoosedCountry];
        if ([self.currentCountryModel.countryCode isEqualToString:model.countryCode])
            return;
        self.currentCountryModel = model;
        self.titleLB.text = model.fullCountryCode;
    }
}

#pragma mark - private methods
- (void)performSelectAnimation {
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)performDeSelectAnimation {
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.arrowImageView.transform = CGAffineTransformMakeRotation(2 * M_PI);
    } completion:nil];
}

- (UILabel *)titleLabel {
    return self.titleLB;
}

#pragma mark - lazy load
- (UILabel *)titleLB {
    if (!_titleLB) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = HDAppTheme.color.G1;
        if (@available(iOS 11.0, *)) {
            label.font = HDAppTheme.font.standard2;
        } else {
            label.font = HDAppTheme.font.standard3;
        }
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 1;
        _titleLB = label;
    }
    return _titleLB;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"arrow_down_gray"];
        _arrowImageView = imageView;
    }
    return _arrowImageView;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _bottomLine;
}
@end
