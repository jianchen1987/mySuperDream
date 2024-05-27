//
//  SATableViewViewMoreView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewViewMoreView.h"


@interface SATableViewViewMoreView ()
@property (nonatomic, strong) HDUIGhostButton *operationButton; ///< 按钮
@end


@implementation SATableViewViewMoreView

- (void)hd_setupViews {
    [self.contentView addSubview:self.operationButton];
}

- (void)updateConstraints {
    [self.operationButton sizeToFit];
    [self.operationButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(self.model.topMargin);
        make.bottom.equalTo(self.contentView).offset(-self.model.bottomMargin);
    }];
    [super updateConstraints];
}

#pragma mark - event response
- (void)operationButtonClickedHandler {
    !self.clickedOperationButonHandler ?: self.clickedOperationButonHandler();
}

#pragma mark - getters and setters
- (void)setModel:(SATableViewViewMoreViewModel *)model {
    _model = model;

    self.operationButton.borderWidth = model.borderWidth;
    self.operationButton.ghostColor = model.borderColor;
    [self.operationButton setTitle:model.title forState:UIControlStateNormal];
    self.operationButton.titleLabel.font = model.textFont ?: HDAppTheme.font.standard2;
    self.operationButton.backgroundColor = model.backgroundColor;
    const UIEdgeInsets edgeInsets = model.contentEdgeInsets;
    if (model.image) {
        self.operationButton.titleEdgeInsets = UIEdgeInsetsMake(model.contentEdgeInsets.top, model.contentEdgeInsets.left, model.contentEdgeInsets.bottom, model.iconTextMargin);
        self.operationButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, model.contentEdgeInsets.right);
    } else {
        self.operationButton.titleEdgeInsets = model.contentEdgeInsets;
    }
    [self.operationButton setTitleColor:model.textColor forState:UIControlStateNormal];
    self.operationButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, edgeInsets.right);
    [self.operationButton setImage:model.image forState:UIControlStateNormal];

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (HDUIGhostButton *)operationButton {
    if (!_operationButton) {
        _operationButton = [HDUIGhostButton buttonWithType:UIButtonTypeCustom];
        _operationButton.imagePosition = HDUIButtonImagePositionRight;
        [_operationButton addTarget:self action:@selector(operationButtonClickedHandler) forControlEvents:UIControlEventTouchUpInside];
    }
    return _operationButton;
}
@end
