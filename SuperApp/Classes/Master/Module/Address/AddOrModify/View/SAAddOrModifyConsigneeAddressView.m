//
//  SAAddOrModifyConsigneeAddressView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddOrModifyConsigneeAddressView.h"
#import "SAAppSwitchManager.h"


@interface SAAddOrModifyConsigneeAddressView () <HDTextViewDelegate>
/// 详情地址
@property (nonatomic, strong) HDTextView *addressDetailTV;
/// 输入框新高度
@property (nonatomic, assign) CGFloat textViewHeight;
/// textView宽度是否不为0
@property (nonatomic, assign) BOOL flag;

@property (nonatomic, copy) NSString *addressRegex;

@end


@implementation SAAddOrModifyConsigneeAddressView

- (void)hd_setupViews {
    self.titleLB.text = SALocalizedString(@"detail", @"详细");

    [self addSubview:self.addressDetailTV];
    [self.addressDetailTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kRealWidth(30));
    }];

    [super hd_setupViews];

    @HDWeakify(self);
    self.addressDetailTV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        if (CGRectGetWidth(precedingFrame) > 0 && !self.flag) {
            self.flag = YES;
            self.addressDetailTV.text = nil;
            self.addressDetailTV.text = self.consigneeAddress;
        }
    };
    self.addressRegex = [SAAppSwitchManager.shared switchForKey:SAAppSwitchAddressRegex];
}

- (void)updateConstraints {
    [self.addressDetailTV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kRealWidth(8));
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
        make.left.equalTo(self.titleLB.mas_right);
        make.height.mas_equalTo(self.textViewHeight > 0 ? self.textViewHeight : kRealWidth(30));
    }];
    [super updateConstraints];
}

#pragma mark - setter
- (void)setConsigneeAddress:(NSString *)consigneeAddress {
    _consigneeAddress = consigneeAddress;
    self.addressDetailTV.text = consigneeAddress;

    [self setNeedsUpdateConstraints];
}

#pragma mark - HDTextViewDelegate
- (void)textView:(HDTextView *)textView newHeightAfterTextChanged:(CGFloat)height {
    self.textViewHeight = height;

    [self setNeedsUpdateConstraints];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.markedTextRange) {
        // 正在输入拼音，不做处理
        return;
    }
    if (HDIsStringNotEmpty(self.addressRegex)) {
        textView.text = [textView.text hd_stringByReplacingPattern:self.addressRegex withString:@""];
    } else {
        textView.text = [textView.text hd_stringByReplacingPattern:@"[^a-z0-9A-Z\u1780-\u17FF\u19E0-\u19FF\u4e00-\u9fff\\s]" withString:@""];
    }
}

#pragma mark - lazy load
- (HDTextView *)addressDetailTV {
    if (!_addressDetailTV) {
        HDTextView *view = HDTextView.new;
        _addressDetailTV = view;
        _addressDetailTV.maximumTextLength = 50;
        _addressDetailTV.delegate = self;
        _addressDetailTV.placeholder = SALocalizedString(@"address_detail_desc", @"门牌号，楼层，房间号等");
        _addressDetailTV.placeholderColor = HDAppTheme.color.G3;
        _addressDetailTV.font = HDAppTheme.font.standard3;
        _addressDetailTV.bounces = false;
        _addressDetailTV.showsVerticalScrollIndicator = false;
    }
    return _addressDetailTV;
}
@end
