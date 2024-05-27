//
//  FlowView.m
//  SuperApp
//
//  Created by Quin on 2021/11/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNFlowView.h"


@interface PNFlowView ()
@property (nonatomic, assign) NSInteger viewType;
@end


@implementation PNFlowView

- (instancetype)initWithType:(NSInteger)type {
    self = [super init];
    if (self) {
        self.viewType = type;
    }
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.bgView];
    [self addSubview:self.titleLB];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - layout
- (void)updateConstraints {
    if (self.viewType == 0) {
        self.titleLB.text = PNLocalizedString(@"open_flow", @"开通流程");
    } else {
        self.titleLB.text = PNLocalizedString(@"pn_activation_procedure", @"激活流程");
    }

    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(kRealHeight(15));
        make.left.equalTo(self.bgView).offset(kRealWidth(15));
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(15));
    }];
    SALabel *firstLB2 = SALabel.new;
    for (int i = 0; i < self.arr.count; i++) {
        PNTypeModel *model = self.arr[i];
        SALabel *LB1 = SALabel.new;
        LB1.text = [NSString stringWithFormat:@"%d", i + 1];
        LB1.font = [HDAppTheme.font forSize:11];
        ;
        LB1.textColor = [UIColor whiteColor];
        LB1.textAlignment = NSTextAlignmentCenter;
        LB1.backgroundColor = [UIColor hd_colorWithHexString:@"#FD7127"];
        LB1.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:15 / 2];
        };

        SALabel *LB2 = SALabel.new;
        LB2.text = model.name;
        LB2.font = [HDAppTheme.font forSize:13];
        LB2.textColor = [UIColor hd_colorWithHexString:@"#343B4D"];
        LB2.numberOfLines = 0;
        LB2.lineBreakMode = NSLineBreakByWordWrapping;
        [LB2 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.bgView addSubview:LB1];
        [self.bgView addSubview:LB2];
        [LB1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(kRealWidth(15));
            make.top.equalTo(LB2.mas_top);
            make.height.mas_equalTo(kRealWidth(15));
            make.width.mas_equalTo(kRealWidth(15));
        }];

        [LB2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.equalTo(self.titleLB.mas_bottom).offset(kRealHeight(15));
            } else {
                make.top.equalTo(firstLB2.mas_bottom).offset(kRealWidth(10));
            }
            make.left.equalTo(LB1.mas_right).offset(kRealWidth(5));
            make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(5));
        }];
        firstLB2 = LB2;
        if (i == self.arr.count - 1) {
            self.lastView = LB2;
        }
    }
    [super updateConstraints];
}

#pragma mark - lazy load
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10 shadowRadius:10 shadowOpacity:1 shadowColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.04].CGColor
                          fillColor:UIColor.whiteColor.CGColor
                       shadowOffset:CGSizeMake(0, 5)];
        };
    }
    return _bgView;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        _titleLB = SALabel.new;
        _titleLB.font = [HDAppTheme.font boldForSize:20];
        _titleLB.textColor = HDAppTheme.PayNowColor.c343B4D;
        _titleLB.numberOfLines = 0;
    }
    return _titleLB;
}
- (NSMutableArray<PNTypeModel *> *)arr {
    if (!_arr) {
        _arr = [NSMutableArray arrayWithCapacity:4];
        if (self.viewType == 0) {
            PNTypeModel *model = PNTypeModel.new;
            model.name = PNLocalizedString(@"set_username", @"设置用户姓名");
            [_arr addObject:model];

            model = PNTypeModel.new;
            model.name = PNLocalizedString(@"set_pay_password", @"设置支付密码");
            [_arr addObject:model];

            model = PNTypeModel.new;
            model.name = PNLocalizedString(@"Complete_opening", @"确认支付密码，完成开通");
            [_arr addObject:model];
        } else {
            PNTypeModel *model = PNTypeModel.new;
            model.name = PNLocalizedString(@"pn_activation_procedure_1", @"输入用户信息");
            [_arr addObject:model];

            model = PNTypeModel.new;
            model.name = PNLocalizedString(@"pn_activation_procedure_2", @"校验用户信息");
            [_arr addObject:model];

            model = PNTypeModel.new;
            model.name = PNLocalizedString(@"pn_activation_procedure_3", @"设置支付密码");
            [_arr addObject:model];

            model = PNTypeModel.new;
            model.name = PNLocalizedString(@"pn_activation_procedure_4", @"确认支付密码，激活完成");
            [_arr addObject:model];
        }
    }
    return _arr;
}
@end
