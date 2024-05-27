//
//  WMOrderFeedBackStrackView.m
//  SuperApp
//
//  Created by wmz on 2022/11/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMOrderFeedBackStrackView.h"


@implementation WMOrderFeedBackStrackView

- (void)setDataSource:(NSArray<WMOrderFeedBackDetailTraclModel *> *)dataSource {
    _dataSource = dataSource;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (WMOrderFeedBackDetailTraclModel *model in dataSource) {
        WMOrderFeedBackStrackItemView *itemView = WMOrderFeedBackStrackItemView.new;
        itemView.model = model;
        [self addSubview:itemView];
        [self setNeedsUpdateConstraints];
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    SAView *lastView;
    for (WMOrderFeedBackStrackItemView *infoView in self.subviews) {
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(16));
            } else {
                make.top.mas_equalTo(kRealWidth(16));
            }
            make.left.right.mas_equalTo(0);
            make.bottom.mas_lessThanOrEqualTo(0);
        }];
        lastView = infoView;
    }
}

- (void)layoutyImmediately {
    [self layoutIfNeeded];
    self.frame = CGRectMake(0, 0, self.frame.size.width, CGRectGetMaxY(self.subviews.lastObject.frame) + kRealWidth(20));
}

@end


@interface WMOrderFeedBackStrackItemView ()
/// titleLB
@property (nonatomic, strong) HDLabel *titleLB;
/// timeLB
@property (nonatomic, strong) HDLabel *timeLB;

@end


@implementation WMOrderFeedBackStrackItemView

- (void)setModel:(WMOrderFeedBackDetailTraclModel *)model {
    _model = model;
    self.titleLB.text = model.logTypeStr;
    self.timeLB.text = [SAGeneralUtil getDateStrWithTimeInterval:model.createTime.doubleValue / 1000 format:@"dd/MM/yyyy HH:mm"];
}

- (void)hd_setupViews {
    [self addSubview:self.titleLB];
    [self addSubview:self.timeLB];
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B3;
        label.font = [HDAppTheme.WMFont wm_ForSize:14.0];
        label.numberOfLines = 0;
        _titleLB = label;
    }
    return _titleLB;
}

- (HDLabel *)timeLB {
    if (!_timeLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B9;
        label.font = [HDAppTheme.WMFont wm_ForSize:12.0];
        _timeLB = label;
    }
    return _timeLB;
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.top.bottom.mas_equalTo(0);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
    }];

    [self.timeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(12));
        make.centerY.equalTo(self.titleLB);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
    }];
}

@end
