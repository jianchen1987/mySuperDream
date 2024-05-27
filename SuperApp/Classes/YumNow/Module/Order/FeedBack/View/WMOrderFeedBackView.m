//
//  WMOrderFeedBackView.m
//  SuperApp
//
//  Created by wmz on 2021/11/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMOrderFeedBackView.h"


@interface WMOrderFeedBackView ()
@property (nonatomic, strong) HDLabel *nameLB;
@property (nonatomic, strong) HDLabel *detailLB;
@property (nonatomic, strong) UIImageView *rightIV;
@property (nonatomic, strong) NSString *showStatuStr;
@property (nonatomic, strong) NSString *showTitle;
@end


@implementation WMOrderFeedBackView

- (void)updateContent {
    self.showStatuStr = nil;
    NSString *showTitle = nil;
    if ([self.postSaleShowType isEqualToString:WMOrderFeedBackStepProgress]) {
        showTitle = WMLocalizedString(@"wm_order_feedback_required_Progress", @"反馈进度");
        if ([self.handleStatus isEqualToString:WMOrderFeedBackHandleWait]) {
            self.showStatuStr = WMLocalizedString(@"wm_order_feedback_status_submitted", @"已提交");
        } else if ([self.handleStatus isEqualToString:WMOrderFeedBackHandleReject]) {
            self.showStatuStr = WMLocalizedString(@"wm_order_feedback_status_rejected", @"已拒绝");
        } else if ([self.handleStatus isEqualToString:WMOrderFeedBackHandlePending]) {
            self.showStatuStr = WMLocalizedString(@"wm_order_feedback_status_processing", @"处理中");
        } else if ([self.handleStatus isEqualToString:WMOrderFeedBackHandleFinish]) {
            self.showStatuStr = WMLocalizedString(@"wm_order_feedback_status_completed", @"处理完成");
        }
        self.nameLB.text = showTitle;
        self.detailLB.text = self.showStatuStr;
    } else {
        self.nameLB.text = WMLocalizedString(@"wm_feed_problem", @"食品问题反馈");
        self.detailLB.text = WMLocalizedString(@"wm_feed_problem_if", @"如遇到食品问题、餐损问题可在此进行反馈");
    }
    [self setNeedsUpdateConstraints];
}

- (void)hd_setupViews {
    self.layer.backgroundColor = HDAppTheme.WMColor.bg3.CGColor;
    self.layer.cornerRadius = kRealWidth(8);
    [self addSubview:self.rightIV];
    [self addSubview:self.nameLB];
    [self addSubview:self.detailLB];
    UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:ta];
}

- (void)tapAction {
    if (self.clickedBlock)
        self.clickedBlock();
}

- (void)updateConstraints {
    [self.rightIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(self.rightIV.image.size);
        make.right.mas_equalTo(-kRealWidth(12));
    }];

    if (self.showStatuStr) {
        [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kRealWidth(12));
            make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
            make.right.equalTo(self.detailLB.mas_left).offset(-kRealWidth(12));
            make.top.mas_greaterThanOrEqualTo(kRealWidth(14));
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(14));
        }];

        [self.detailLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLB);
            make.right.equalTo(self.rightIV.mas_left).offset(-kRealWidth(12));
        }];

        [self.nameLB setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        [self.nameLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    } else {
        [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(kRealWidth(12));
            make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
            make.right.equalTo(self.rightIV.mas_left).offset(-kRealWidth(12));
        }];

        [self.detailLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(8));
            make.left.right.equalTo(self.nameLB);
            make.bottom.mas_equalTo(-kRealWidth(12));
        }];
    }

    [super updateConstraints];
}

- (UIImageView *)rightIV {
    if (!_rightIV) {
        _rightIV = UIImageView.new;
        _rightIV.image = [UIImage imageNamed:@"yn_submit_gengd"];
    }
    return _rightIV;
}

- (HDLabel *)nameLB {
    if (!_nameLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B3;
        label.font = [HDAppTheme.WMFont wm_boldForSize:13.0];
        label.text = WMLocalizedString(@"wm_feed_problem", @"食品问题反馈");
        label.numberOfLines = 0;
        label.userInteractionEnabled = NO;
        _nameLB = label;
    }
    return _nameLB;
}

- (HDLabel *)detailLB {
    if (!_detailLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B9;
        label.font = [HDAppTheme.WMFont wm_ForSize:12.0];
        label.text = WMLocalizedString(@"wm_feed_problem_if", @"如遇到食品问题、餐损问题可在此进行反馈");
        label.numberOfLines = 0;
        label.userInteractionEnabled = NO;
        _detailLB = label;
    }
    return _detailLB;
}

@end
