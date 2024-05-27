//
//  TNBargainSpecTagsCell.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainSpecTagsCell.h"

#import "HDAppTheme+TinhNow.h"
#import "SAOperationButton.h"
#import "TNProductSpecPropertieModel.h"
#import "TNProductSpecificationModel.h"
#import "UICollectionViewLeftAlignLayout.h"


@interface TNBargainSpecTagsCell ()
/// 规格名称
@property (nonatomic, strong) UILabel *specNameLabel;
/// collection高度
@property (nonatomic, assign) CGFloat collectionFitHeight;
/// 流式布局容器
@property (nonatomic, strong) HDFloatLayoutView *floatLayoutView;
/// 按钮列表
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;
@end


@implementation TNBargainSpecTagsCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.specNameLabel];
    [self.contentView addSubview:self.floatLayoutView];
    self.buttons = NSMutableArray.new;
}

- (void)updateConstraints {
    [self.specNameLabel sizeToFit];
    [self.specNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.left.equalTo(self.contentView.mas_left);
        make.right.lessThanOrEqualTo(self.contentView.mas_right);
    }];

    [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        CGFloat width = kScreenWidth - 2 * kRealWidth(15);
        make.top.equalTo(self.specNameLabel.mas_bottom).offset(kRealWidth(15));
        make.left.right.equalTo(self.contentView);
        CGSize size = [self.floatLayoutView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
        make.size.mas_equalTo(size);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(20));
    }];
    [super updateConstraints];
}
- (void)setModel:(TNProductSpecificationModel *)model {
    _model = model;
    self.specNameLabel.text = _model.specName;
    [self.floatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttons removeAllObjects];
    for (TNProductSpecPropertieModel *properties in model.specValues) {
        [self generateButtonWithModel:properties];
    }
    self.floatLayoutView.maxRowCount = model.specValues.count;
    [self setNeedsUpdateConstraints];
}

- (SAOperationButton *)generateButtonWithModel:(TNProductSpecPropertieModel *)model {
    SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
    button.ghostColor = HDAppTheme.color.G3;
    [button setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
    [button setTitleColor:HDAppTheme.TinhNowColor.C1 forState:UIControlStateSelected];
    [button setTitleColor:HDAppTheme.color.G3 forState:UIControlStateDisabled];
    button.titleLabel.font = HDAppTheme.font.standard4;
    button.titleEdgeInsets = UIEdgeInsetsMake(5, kRealWidth(15), 5, kRealWidth(15));
    button.cornerRadius = 5.0f;
    [button setTitle:model.propValue forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickOnSpecPropertiesButton:) forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageTintColorAutomatically = NO;
    [button applyPropertiesWithBackgroundColor:UIColor.whiteColor];
    if (model.isDefault) {
        [button setSelected:YES];
        button.ghostColor = HDAppTheme.TinhNowColor.C1;
    } else {
        [button setSelected:NO];
        button.ghostColor = HDAppTheme.color.G3;
        [button setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
    }
    [self.floatLayoutView addSubview:button];
    [self.buttons addObject:button];
    //设置默认选中
    [self fixesButtonsState:button status:model.status];
    return button;
}
- (void)clickOnSpecPropertiesButton:(SAOperationButton *)button {
    NSUInteger selectedIndex = [self.buttons indexOfObject:button];
    if (selectedIndex < self.model.specValues.count) {
        TNProductSpecPropertieModel *properties = self.model.specValues[selectedIndex];
        if (properties.status == TNSpecPropertyStatusSelected) {
            return;
        }
        properties.status = TNSpecPropertyStatusSelected;
        for (TNProductSpecPropertieModel *pModel in self.model.specValues) {
            if (pModel != properties) {
                if (pModel.status != TNSpecPropertyStatusdisEnble) {
                    pModel.status = TNSpecPropertyStatusNormal;
                }
            }
        }
        [self fixesButtonsState:button status:properties.status];
        if (self.specValueSelected) {
            self.specValueSelected(properties, self.model);
        }
    }
}

- (void)fixesButtonsState:(SAOperationButton *)button status:(TNSpecPropertyStatus)status {
    switch (status) {
        case TNSpecPropertyStatusNormal: //默认可选状态
            [button setSelected:false];
            [button setEnabled:true];
            [button setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
            button.layer.borderColor = HDAppTheme.TinhNowColor.G3.CGColor;
            break;
        case TNSpecPropertyStatusSelected:
            [button setSelected:true];
            [button setEnabled:true];
            button.ghostColor = HDAppTheme.TinhNowColor.C1;
            break;
        case TNSpecPropertyStatusdisEnble:
            [button setSelected:false];
            [button setEnabled:false];
            button.ghostColor = HDAppTheme.TinhNowColor.G3;
            break;
        default:
            break;
    }
    [button applyPropertiesWithBackgroundColor:UIColor.whiteColor];
}

#pragma mark - lazy load
- (HDFloatLayoutView *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = [[HDFloatLayoutView alloc] init];
        _floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, kRealWidth(9), kRealWidth(20));
        _floatLayoutView.minimumItemSize = CGSizeMake(kRealWidth(50), kRealWidth(28));
    }
    return _floatLayoutView;
}
/** @lazy specNameLabel */
- (UILabel *)specNameLabel {
    if (!_specNameLabel) {
        _specNameLabel = [[UILabel alloc] init];
        _specNameLabel.font = HDAppTheme.TinhNowFont.standard17M;
        _specNameLabel.textColor = [UIColor blackColor];
    }
    return _specNameLabel;
}


@end
