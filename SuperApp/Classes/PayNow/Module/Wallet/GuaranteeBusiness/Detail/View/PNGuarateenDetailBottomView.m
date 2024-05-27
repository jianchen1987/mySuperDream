//
//  PNGuarateenDetailBottomView.m
//  SuperApp
//
//  Created by xixi on 2023/1/9.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNGuarateenDetailBottomView.h"
#import <HDKitCore/HDKitCore.h>

static NSString *kAction = @"kAction";


@interface PNGuarateenDetailBottomView ()
@property (nonatomic, strong) PNOperationButton *mainThemeBtn;
@property (nonatomic, strong) HDUIButton *norBtn;
@end


@implementation PNGuarateenDetailBottomView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    self.layer.shadowColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.0600].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, -4);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 8;

    [self addSubview:self.norBtn];
    [self addSubview:self.mainThemeBtn];
}

- (void)updateConstraints {
    NSMutableArray *subTempArray = [NSMutableArray arrayWithArray:self.subviews];
    NSMutableArray *subVisableInfoViews = [NSMutableArray arrayWithCapacity:subTempArray.count];
    for (UIView *itemView in subTempArray) {
        itemView.isHidden ?: [subVisableInfoViews addObject:itemView];
    }

    UIView *lastInfoView;
    for (UIView *infoView in subVisableInfoViews) {
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastInfoView) {
                make.left.mas_equalTo(lastInfoView.mas_right).offset(kRealWidth(12));
                make.width.mas_equalTo(lastInfoView);
            } else {
                make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
            }
            make.bottom.mas_equalTo(self.mas_bottom).offset(-((kRealWidth(16) + kiPhoneXSeriesSafeBottomHeight)));
            make.top.mas_equalTo(self.mas_top).offset(kRealWidth(16));

            make.height.mas_equalTo(@(kRealWidth(48)));
            if (infoView == subVisableInfoViews.lastObject) {
                make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
            }
        }];
        lastInfoView = infoView;
    }

    [super updateConstraints];
}

- (void)setDataSource:(NSMutableArray<PNGuarateenNextActionModel *> *)dataSource {
    _dataSource = dataSource;

    if (self.dataSource.count == 1) {
        /// 只有一个的时候就是主题色
        PNGuarateenNextActionModel *model = self.dataSource.firstObject;
        [self.mainThemeBtn setTitle:model.action.message forState:UIControlStateNormal];
        [self.mainThemeBtn hd_bindObjectWeakly:model forKey:kAction];
        self.norBtn.hidden = YES;
        self.mainThemeBtn.hidden = NO;
    } else {
        PNGuarateenNextActionModel *leftModel = self.dataSource.firstObject;
        PNGuarateenNextActionModel *rightModel = [self.dataSource objectAtIndex:1];

        [self.norBtn setTitle:leftModel.action.message forState:UIControlStateNormal];
        [self.mainThemeBtn setTitle:rightModel.action.message forState:UIControlStateNormal];

        [self.norBtn hd_bindObjectWeakly:leftModel forKey:kAction];
        [self.mainThemeBtn hd_bindObjectWeakly:rightModel forKey:kAction];

        self.norBtn.hidden = NO;
        self.mainThemeBtn.hidden = NO;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (void)btnClick:(UIButton *)btn {
    PNGuarateenNextActionModel *model = [btn hd_getBoundObjectForKey:kAction];
    !self.btnClickBlock ?: self.btnClickBlock(model);
}

#pragma mark
- (PNOperationButton *)mainThemeBtn {
    if (!_mainThemeBtn) {
        _mainThemeBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_mainThemeBtn setTitle:PNLocalizedString(@"PAGE_TEXT_TRADE", @"交易") forState:UIControlStateNormal];
        [_mainThemeBtn setTitleColor:HDAppTheme.PayNowColor.cFFFFFF forState:0];
        _mainThemeBtn.titleLabel.font = HDAppTheme.PayNowFont.standard16B;
        _mainThemeBtn.hidden = YES;
        [_mainThemeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mainThemeBtn;
}

- (HDUIButton *)norBtn {
    if (!_norBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"bank_bill_email_hint_explain", @"") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.c333333 forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard16B;
        button.hidden = YES;
        button.layer.cornerRadius = kRealWidth(4);
        button.layer.borderColor = HDAppTheme.PayNowColor.cCCCCCC.CGColor;
        button.layer.borderWidth = 1;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

        _norBtn = button;
    }
    return _norBtn;
}
@end
