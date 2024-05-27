//
//  SAContactPhoneView.m
//  SuperApp
//
//  Created by Chaos on 2021/1/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAContactPhoneView.h"
#import "SACacheManager.h"
#import "SAContactPhoneModel.h"
#import "SAImageLeftFillButton.h"
#import "SAApolloManager.h"


@interface SAContactPhoneView ()
/// 分割线
@property (nonatomic, strong) UIView *sepLine;
/// 客服号码按钮
@property (nonatomic, strong) NSArray<SAImageLeftFillButton *> *callCenterNumberBTNs;
/// 临时号码按钮
@property (nonatomic, strong) NSArray<SAImageLeftFillButton *> *tempNumberBTNs;
/// 新号码数组
@property (nonatomic, strong) NSArray<SAContactPhoneModel *> *callCenterNumbers;
/// 临时号码数组
@property (nonatomic, strong) NSArray<SAContactPhoneModel *> *tempNumbers;
@end


@implementation SAContactPhoneView

- (void)hd_setupViews {
    [self initData];

    for (SAImageLeftFillButton *button in self.callCenterNumberBTNs) {
        [self addSubview:button];
    }
    [self addSubview:self.sepLine];
    for (SAImageLeftFillButton *button in self.tempNumberBTNs) {
        [self addSubview:button];
    }
}

- (void)initData {
    NSArray<SAContactPhoneModel *> *callCenter = [NSArray yy_modelArrayWithClass:SAContactPhoneModel.class json:[SAApolloManager getApolloConfigForKey:ApolloConfigKeyCallCenter]];
    self.callCenterNumbers = [callCenter hd_filterWithBlock:^BOOL(SAContactPhoneModel *_Nonnull item) {
        return [item.name isEqualToString:SAContactPhoneNameCallCenter];
    }];
    self.tempNumbers = [callCenter hd_filterWithBlock:^BOOL(SAContactPhoneModel *_Nonnull item) {
        return [item.name isEqualToString:SAContactPhoneNameTemp];
    }];
    self.callCenterNumberBTNs = [self.callCenterNumbers mapObjectsUsingBlock:^id _Nonnull(SAContactPhoneModel *_Nonnull obj, NSUInteger idx) {
        return [self createContactPhoneBtnWithModel:obj];
    }];
    self.tempNumberBTNs = [self.tempNumbers mapObjectsUsingBlock:^id _Nonnull(SAContactPhoneModel *_Nonnull obj, NSUInteger idx) {
        return [self createContactPhoneBtnWithModel:obj];
    }];
}

#pragma mark - private methods
- (SAImageLeftFillButton *)createContactPhoneBtnWithModel:(SAContactPhoneModel *)model {
    UIImage *bgImage = [UIImage imageNamed:@"button_image_bg"];
    SAImageLeftFillButton *button = [SAImageLeftFillButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:model.num forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickedPhoneNumberBTNHandler:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderColor = HDAppTheme.color.G4.CGColor;
    button.borderWidth = 1;
    [button setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
    UIImage *placeholderImage = [HDHelper placeholderImageWithBgColor:UIColor.clearColor cornerRadius:0 size:CGSizeMake(50, 50)];
    [button setImage:[SAGeneralUtil mergeImage:placeholderImage onBackgroundImageCenter:bgImage] forState:UIControlStateNormal];
    [HDWebImageManager setImageWithURL:model.img placeholderImage:nil imageView:UIImageView.new
                             completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                                 UIImage *mergeImage = [image hd_imageResizedWithScreenScaleInLimitedSize:CGSizeMake(image.size.width / image.size.height * bgImage.size.height, bgImage.size.height)];
                                 [button setImage:[SAGeneralUtil mergeImage:mergeImage onBackgroundImageCenter:bgImage] forState:UIControlStateNormal];
                             }];
    return button;
}

#pragma mark - HDCustomViewActionViewProtocol
- (void)layoutyImmediately {
    self.sepLine.hidden = HDIsArrayEmpty(self.tempNumberBTNs);

    [self updateLayout];
    [self setNeedsLayout];
    [self layoutIfNeeded];

    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.frame = (CGRect){0, 0, CGRectGetWidth(self.frame), size.height};
}

#pragma mark - event response
- (void)clickedPhoneNumberBTNHandler:(UIButton *)btn {
    !self.clickedPhoneNumberBlock ?: self.clickedPhoneNumberBlock(btn.currentTitle);
}

#pragma mark - layout
- (void)updateLayout {
    NSArray<UIView *> *showViews = [self.subviews hd_filterWithBlock:^BOOL(__kindof UIView *_Nonnull item) {
        return !item.isHidden;
    }];
    UIView *lastView;
    for (UIView *view in showViews) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!view.isHidden) {
                if ([view isKindOfClass:SAImageLeftFillButton.class]) {
                    make.width.equalTo(self).multipliedBy(0.66);
                } else {
                    make.width.equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
                }
                if (!lastView) {
                    make.top.equalTo(self).offset(kRealWidth(20));
                    [view sizeToFit];
                    make.height.mas_equalTo(view.height);
                } else {
                    if ([lastView isKindOfClass:SAImageLeftFillButton.class]) {
                        if ([view isKindOfClass:SAImageLeftFillButton.class]) {
                            make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(10));
                            [view sizeToFit];
                            make.height.mas_equalTo(view.height);
                        } else {
                            make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(20));
                            make.height.mas_equalTo(1);
                        }
                    } else {
                        make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(20));
                        [view sizeToFit];
                        make.height.mas_equalTo(view.height);
                    }
                }
                if (view == showViews.lastObject) {
                    make.bottom.equalTo(self).offset(-kRealWidth(30));
                }
                make.centerX.equalTo(self);
            }
        }];
        if (!view.isHidden) {
            lastView = view;
        }
    }
}

#pragma mark - lazy load
- (UIView *)sepLine {
    if (!_sepLine) {
        _sepLine = UIView.new;
        _sepLine.backgroundColor = HDAppTheme.color.G5;
    }
    return _sepLine;
}

@end
