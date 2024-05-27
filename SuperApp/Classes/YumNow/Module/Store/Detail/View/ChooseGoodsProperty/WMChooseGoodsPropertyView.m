//
//  WMChooseGoodsSkuView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/14.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMChooseGoodsPropertyView.h"
#import "SAMoneyModel.h"
#import "WMPropertyTagButton.h"
#import "WMStoreGoodsProductPropertyOption.h"
#import "SAMoneyTools.h"

@interface WMChooseGoodsPropertyView ()
/// 选择状态按钮
@property (nonatomic, strong) HDUIButton *selectBTN;
/// 右边的容器
@property (nonatomic, strong) UIView *container;
/// 属性按钮
@property (nonatomic, strong) WMPropertyTagButton *optionBTN;
/// 展示价格
@property (nonatomic, strong) SALabel *priceLB;
/// 底部线
@property (nonatomic, strong) UIView *bottomLine;
@end


@implementation WMChooseGoodsPropertyView
- (void)hd_setupViews {
    [self addSubview:self.selectBTN];
    [self addSubview:self.container];
    [self addSubview:self.priceLB];
    [self addSubview:self.optionBTN];
    [self addSubview:self.bottomLine];
}

#pragma mark - setter
- (void)setModel:(WMStoreGoodsProductPropertyOption *)model {
    _model = model;

    self.selectBTN.selected = model.isSelected;
//    self.priceLB.text = !model.additionalPrice ? nil : [NSString stringWithFormat:@"+%@", model.additionalPrice.thousandSeparatorAmount];
    self.priceLB.text =  !model.additionalPrice ? nil : [NSString stringWithFormat:@"+%@",[SAMoneyTools thousandSeparatorAmountYuan:model.additionalPrice currencyCode:@"USD"]];
    [self.optionBTN setTitle:model.name forState:UIControlStateNormal];
    self.bottomLine.hidden = YES;

    [self setNeedsUpdateConstraints];
}

#pragma mark - public methods
- (void)setSelectBtnSelected:(BOOL)selected {
    self.selectBTN.selected = selected;
    self.model.isSelected = selected;
}

#pragma mark - event response
- (void)clickedSelectBTNHandler:(HDUIButton *)button {
    BOOL canChange = !self.clickedSelectBTNBlock ? NO : self.clickedSelectBTNBlock(button);
    if (canChange) {
        button.selected = !button.isSelected;
        self.model.isSelected = button.isSelected;
    }
}

- (void)clickedContainerViewHandler {
    [self.selectBTN sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.selectBTN sizeToFit];
    [self.selectBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(18), kRealWidth(18)));
    }];
    [self.optionBTN sizeToFit];
    [self.optionBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectBTN.mas_right).offset(8);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(32);
        make.width.mas_greaterThanOrEqualTo(kRealWidth(107));
        make.right.lessThanOrEqualTo(self.priceLB.mas_left).offset(-10);
    }];
    [self.priceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self);
    }];
    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.bottomLine.isHidden) {
            make.height.mas_equalTo(PixelOne);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }
    }];
    [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (HDUIButton *)selectBTN {
    if (!_selectBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        //        button.hd_eventTimeInterval = CGFLOAT_MIN;
        [button setImage:[UIImage imageNamed:@"customize_unselected"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"yn_filter_select"] forState:UIControlStateSelected];
        button.adjustsButtonWhenHighlighted = false;
        //        button.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 5);
        [button addTarget:self action:@selector(clickedSelectBTNHandler:) forControlEvents:UIControlEventTouchUpInside];
        [button setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        _selectBTN = button;
    }
    return _selectBTN;
}

- (UIView *)container {
    if (!_container) {
        _container = UIView.new;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedContainerViewHandler)];
        [_container addGestureRecognizer:recognizer];
    }
    return _container;
}

- (WMPropertyTagButton *)optionBTN {
    if (!_optionBTN) {
        WMPropertyTagButton *optionBTN = [WMPropertyTagButton buttonWithType:UIButtonTypeCustom];
        //        optionBTN.hd_eventTimeInterval = CGFLOAT_MIN;
        optionBTN.titleLabel.font = HDAppTheme.font.standard3;
        optionBTN.userInteractionEnabled = NO;
        optionBTN.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [optionBTN setTitleColor:HDAppTheme.color.G2 forState:UIControlStateNormal];
        [optionBTN setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        _optionBTN = optionBTN;
    }
    return _optionBTN;
}

- (SALabel *)priceLB {
    if (!_priceLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3Bold;
        label.textColor = HDAppTheme.color.money;
        label.numberOfLines = 1;
        _priceLB = label;
    }
    return _priceLB;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _bottomLine;
}
@end
