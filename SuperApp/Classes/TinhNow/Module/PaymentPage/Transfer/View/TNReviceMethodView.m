//
//  TNReviceMethodView.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNReviceMethodView.h"


@interface TNReviceMethodView ()
/// 标题
@property (strong, nonatomic) HDLabel *titleLabel;
/// 内容
@property (strong, nonatomic) HDLabel *contentLabel;
/// 分割线
@property (strong, nonatomic) UIView *lineView;
/// 复制按钮
@property (strong, nonatomic) SAOperationButton *pasteBtn;
/// 进入按钮
@property (strong, nonatomic) SAOperationButton *enterBtn;
@end


@implementation TNReviceMethodView
- (void)hd_setupViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.pasteBtn];
    [self addSubview:self.enterBtn];
}
- (void)setItem:(TNTransferItemModel *)item {
    _item = item;
    if (!item.isCustomerService) {
        self.titleLabel.text = item.name;
        self.contentLabel.text = item.value;
    } else {
        self.contentLabel.text = item.name;
    }
    self.enterBtn.hidden = !item.isCustomerService;
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top).offset(kRealWidth(10));
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(15));
        if (!self.enterBtn.isHidden) {
            make.right.lessThanOrEqualTo(self.enterBtn.mas_left).offset(-kRealWidth(20));
        } else {
            make.right.lessThanOrEqualTo(self.pasteBtn.mas_left).offset(-kRealWidth(20));
        }
    }];
    [self.pasteBtn sizeToFit];
    [self.pasteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_top);
        make.right.equalTo(self.mas_right);
        make.size.mas_equalTo(self.pasteBtn.bounds.size);
    }];
    if (!self.enterBtn.isHidden) {
        [self.enterBtn sizeToFit];
        [self.enterBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.pasteBtn.mas_centerY);
            make.right.equalTo(self.pasteBtn.mas_left).offset(-kRealWidth(10));
            make.size.mas_equalTo(self.enterBtn.bounds.size);
        }];
    }
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(kRealWidth(8)).priorityHigh();
        make.top.equalTo(self.pasteBtn.mas_bottom).offset(kRealWidth(8)).priorityMedium();
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(PixelOne);
    }];
    [super updateConstraints];
}
- (HDLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[HDLabel alloc] init];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G3;
        _titleLabel.font = HDAppTheme.TinhNowFont.standard12M;
    }
    return _titleLabel;
}
- (HDLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[HDLabel alloc] init];
        _contentLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _contentLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.TinhNowColor.G4;
    }
    return _lineView;
}
- (SAOperationButton *)pasteBtn {
    if (!_pasteBtn) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        button.titleEdgeInsets = UIEdgeInsetsMake(4, 10, 4, 10);
        button.titleLabel.font = HDAppTheme.font.standard3;
        [button setTitle:TNLocalizedString(@"tn_copy", @"复制") forState:UIControlStateNormal];
        button.borderWidth = 0.5;
        button.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        [button setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        button.borderColor = [UIColor hd_colorWithHexString:@"#707070"];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [UIPasteboard generalPasteboard].string = self.contentLabel.text;
            [HDTips showSuccess:TNLocalizedString(@"tn_copy_success", @"复制成功")];
        }];
        _pasteBtn = button;
    }
    return _pasteBtn;
}
- (SAOperationButton *)enterBtn {
    if (!_enterBtn) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        button.titleEdgeInsets = UIEdgeInsetsMake(4, 10, 4, 10);
        button.titleLabel.font = HDAppTheme.font.standard3;
        [button setTitle:TNLocalizedString(@"tn_enter", @"进入") forState:UIControlStateNormal];
        button.borderWidth = 0.5;
        button.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        [button setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        button.borderColor = [UIColor hd_colorWithHexString:@"#707070"];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.enterClickCallBack ?: self.enterClickCallBack();
        }];
        _enterBtn = button;
    }
    return _enterBtn;
}
@end
