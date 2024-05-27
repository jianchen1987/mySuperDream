//
//  WMChooseGoodsSpecificationView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/14.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMChooseGoodsSpecificationView.h"
#import "WMStoreGoodsProductSpecification.h"
#import "SAMoneyTools.h"

@interface WMChooseGoodsSpecificationView ()
/// 选择状态按钮
@property (nonatomic, strong) HDUIButton *selectBTN;
/// 右边的容器
@property (nonatomic, strong) UIView *container;
/// 名称
@property (nonatomic, strong) SALabel *nameLB;
/// 展示价格
@property (nonatomic, strong) SALabel *showPriceLB;
/// 底部线
@property (nonatomic, strong) UIView *bottomLine;
@end


@implementation WMChooseGoodsSpecificationView
- (void)hd_setupViews {
    [self addSubview:self.selectBTN];
    [self addSubview:self.container];
    [self addSubview:self.nameLB];
    [self addSubview:self.showPriceLB];
    [self addSubview:self.bottomLine];
}

#pragma mark - setter
- (void)setModel:(WMStoreGoodsProductSpecification *)model {
    _model = model;

    self.selectBTN.selected = model.isSelected;
    self.nameLB.text = model.name;

//    self.showPriceLB.text = model.salePrice.thousandSeparatorAmount;
    self.showPriceLB.text = [SAMoneyTools thousandSeparatorAmountYuan:model.salePrice currencyCode:@"USD"];


    self.bottomLine.hidden = true;

    [self setNeedsUpdateConstraints];
}

#pragma mark - public methods
- (void)setSelectBtnSelected:(BOOL)selected {
    self.selectBTN.selected = selected;
    self.model.isSelected = selected;
}

#pragma mark - event response
- (void)clickedSelectBTNHandler:(HDUIButton *)button {
    // 不可以反选
    if (button.isSelected) {
        return;
    }
    button.selected = !button.isSelected;
    self.model.isSelected = button.isSelected;

    !self.clickedSelectBTNBlock ?: self.clickedSelectBTNBlock(button);
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
    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.selectBTN.mas_right).offset(kRealWidth(8));
        make.right.equalTo(self.showPriceLB.mas_left).offset(-kRealWidth(5));
    }];
    [self.showPriceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
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
        make.right.top.bottom.equalTo(self);
        make.left.equalTo(self.selectBTN.mas_right);
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

- (SALabel *)nameLB {
    if (!_nameLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G2;
        label.numberOfLines = 1;
        [label setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        _nameLB = label;
    }
    return _nameLB;
}

- (SALabel *)showPriceLB {
    if (!_showPriceLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3Bold;
        label.textColor = HDAppTheme.color.money;
        label.numberOfLines = 1;
        [label setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        _showPriceLB = label;
    }
    return _showPriceLB;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _bottomLine;
}
@end
