//
//  WMTopView.m
//  SuperApp
//
//  Created by wmz on 2023/6/14.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMTopView.h"
@interface WMTopView ()
@property (nonatomic, strong) UIImageView *iconIV;
@property (nonatomic, strong) HDLabel *titleLB;
@end

@implementation WMTopView

- (void)hd_setupViews{
    [self addSubview:self.iconIV];
    [self addSubview:self.titleLB];
}

- (void)setStyle:(WMTopViewStyle)style{
    _style = style;
    switch (style) {
        case WMTopViewStyleEvaluation:{
            self.backgroundColor = [UIColor hd_colorWithHexString:@"#FFEEE1"];
            self.titleLB.text = WMLocalizedString(@"wm_evaluation_do_better", @"提交评价或建议，鼓励骑手和商家做的更好～");
            self.titleLB.textColor = [UIColor hd_colorWithHexString:@"#FF8126"];
            self.iconIV.image = [UIImage imageNamed:@"yn_evaluation_tip_icon"];
        }
            break;
        case WMTopViewStyleEvaluationOnlyStore:{
            self.backgroundColor = [UIColor hd_colorWithHexString:@"#FFEEE1"];
            self.titleLB.text = WMLocalizedString(@"wm_evaluation_do_better", @"提交评价或建议，鼓励骑手和商家做的更好～");
            self.titleLB.textColor = [UIColor hd_colorWithHexString:@"#FF8126"];
            self.iconIV.image = [UIImage imageNamed:@"yn_evaluation_tip_icon"];
        }
            break;
            
        default:
            break;
    }
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints{
    [super updateConstraints];
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.top.mas_equalTo(kRealWidth(8));
        make.size.mas_equalTo(self.iconIV.image.size);
    }];
    
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(4));
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.mas_equalTo(kRealWidth(8));
        make.bottom.mas_equalTo(-kRealWidth(8));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(16));
    }];
}

- (UIImageView *)iconIV{
    if(!_iconIV){
        _iconIV = UIImageView.new;
    }
    return _iconIV;
}

- (HDLabel *)titleLB{
    if(!_titleLB){
        _titleLB = HDLabel.new;
        _titleLB.numberOfLines = 0;
        _titleLB.font = [HDAppTheme.WMFont wm_ForSize:11];
    }
    return _titleLB;
}

@end
