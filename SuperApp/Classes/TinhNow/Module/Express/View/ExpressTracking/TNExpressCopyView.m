//
//  TNExpressCopyView.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNExpressCopyView.h"


@interface TNExpressCopyView ()
/// 文本
@property (strong, nonatomic) HDLabel *leftLB;
/// 复制按钮
@property (strong, nonatomic) SAOperationButton *pasteBtn;
/// 需要拷贝的值
@property (nonatomic, copy) NSString *value;
@end


@implementation TNExpressCopyView
- (void)hd_setupViews {
    [self addSubview:self.leftLB];
    [self addSubview:self.pasteBtn];
}
- (void)updateConstraints {
    [self.leftLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.lessThanOrEqualTo(self.pasteBtn.mas_left).offset(-kRealWidth(15));
        make.top.equalTo(self.mas_top).offset(kRealWidth(12));
        make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(12));
    }];
    [self.pasteBtn sizeToFit];
    [self.pasteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftLB.mas_centerY);
        make.right.equalTo(self);
    }];
    [super updateConstraints];
}
- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    NSString *key = dic[@"key"];
    self.value = dic[@"value"];
    self.leftLB.text = [NSString stringWithFormat:@"%@: %@", key, self.value];
    if (HDIsStringNotEmpty(self.value)) {
        self.pasteBtn.hidden = NO;
    } else {
        self.pasteBtn.hidden = YES;
    }
}
/** @lazy leftLB */
- (HDLabel *)leftLB {
    if (!_leftLB) {
        _leftLB = [[HDLabel alloc] init];
        _leftLB.textColor = HDAppTheme.TinhNowColor.G2;
        _leftLB.font = HDAppTheme.TinhNowFont.standard12;
        _leftLB.numberOfLines = 2;
    }
    return _leftLB;
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
            if (HDIsStringNotEmpty(self.value)) {
                [UIPasteboard generalPasteboard].string = self.value;
                [HDTips showSuccess:TNLocalizedString(@"tn_copy_success", @"复制成功")];
            }
        }];
        _pasteBtn = button;
    }
    return _pasteBtn;
}
@end
