//
//  SAAddOrModifyAddressTagsView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddOrModifyAddressTagsView.h"


@interface SAAddOrModifyAddressTagsView ()
/// 容器
@property (nonatomic, strong) HDFloatLayoutView *floatLayoutView;
/// 选中的按钮
@property (nonatomic, strong) HDUIButton *selectedBTN;
@end


@implementation SAAddOrModifyAddressTagsView

- (void)hd_setupViews {
    self.titleLB.text = SALocalizedString(@"tag", @"标签");

    [self addSubview:self.floatLayoutView];
    [super hd_setupViews];
}

- (void)updateConstraints {
    [self.floatLayoutView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.titleLB.mas_right);
        make.size.mas_equalTo([self.floatLayoutView sizeThatFits:CGSizeMake(kScreenWidth - 100 - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding), CGFLOAT_MAX)]);
    }];
    [super updateConstraints];
}

#pragma mark - event response
- (void)clickedTagButtonHandler:(HDUIButton *)btn {
    if (btn.isSelected) {
        btn.selected = false;
        btn.layer.borderWidth = PixelOne;
        self.selectedBTN = nil;
        return;
    }

    btn.selected = true;
    btn.layer.borderWidth = 0;
    self.selectedBTN.selected = false;
    self.selectedBTN.layer.borderWidth = PixelOne;
    self.selectedBTN = btn;
}

#pragma mark - setter
- (void)setTags:(NSArray<NSString *> *)tags {
    _tags = tags;

    if (!HDIsArrayEmpty(tags)) {
        [self selectedButtonWithTag:tags.firstObject];
    }
}

#pragma mark - private methods
- (void)selectedButtonWithTag:(NSString *)type {
    for (HDUIGhostButton *button in self.floatLayoutView.subviews) {
        NSString *t = button.hd_associatedObject;
        if ([t isEqualToString:type]) {
            [self clickedTagButtonHandler:button];
            break;
        }
    }
}

#pragma mark - lazy load
- (HDFloatLayoutView *)floatLayoutView {
    if (!_floatLayoutView) {
        HDFloatLayoutView *floatLayoutView = HDFloatLayoutView.new;
        floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 8, 10);

        NSArray<NSDictionary<NSString *, NSString *> *> *tagDictList = @[
            @{@"title": SALocalizedString(@"house", @"家"), @"value": @"HOME", @"background": [HDAppTheme.color.C1 colorWithAlphaComponent:0.1]},
            @{@"title": SALocalizedString(@"office", @"公司"), @"value": @"OFFICE", @"background": [HDAppTheme.color.C3 colorWithAlphaComponent:0.1]},
            @{@"title": SALocalizedString(@"school", @"学校"), @"value": @"SCHOOL", @"background": [HexColor(0x1989FA) colorWithAlphaComponent:0.1]},
            @{@"title": SALocalizedString(@"cKBhk0SG", @"其他"), @"value": @"OTHER", @"background": [HexColor(0x41B34D) colorWithAlphaComponent:0.1]}
        ];

        for (NSDictionary *tagDict in tagDictList) {
            HDUIButton *button = HDUIButton.new;
            button.layer.cornerRadius = 5;
            button.layer.borderColor = HDAppTheme.color.G4.CGColor;
            button.layer.borderWidth = PixelOne;
            button.layer.masksToBounds = true;
            [button setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
            [button setTitle:tagDict[@"title"] forState:UIControlStateNormal];
            button.titleLabel.font = HDAppTheme.font.standard4;
            [button setBackgroundImage:[UIImage hd_imageWithColor:tagDict[@"background"]] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage hd_imageWithColor:UIColor.whiteColor] forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
            [button sizeToFit];
            button.hd_associatedObject = tagDict[@"value"];
            [button addTarget:self action:@selector(clickedTagButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
            [floatLayoutView addSubview:button];
        }
        _floatLayoutView = floatLayoutView;
    }
    return _floatLayoutView;
}
@end
