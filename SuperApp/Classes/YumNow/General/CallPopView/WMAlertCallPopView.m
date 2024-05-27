//
//  WMAlertCallPopView.m
//  SuperApp
//
//  Created by wmz on 2022/4/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMAlertCallPopView.h"


@interface WMAlertCallPopView ()
/// 容器
@property (nonatomic, strong) UIStackView *containerView;

@end


@implementation WMAlertCallPopView

- (void)hd_setupViews {
    [self addSubview:self.containerView];
}

- (void)setDatasource:(NSArray<WMAlertCallPopModel *> *)datasource {
    _datasource = datasource;
    int i = 0;
    for (WMAlertCallPopModel *model in datasource) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        if (model.atName) {
            [btn setAttributedTitle:model.atName forState:UIControlStateNormal];
        } else {
            if (model.name) {
                [btn setTitle:model.name forState:UIControlStateNormal];
                [btn setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
                btn.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:13];
            }
        }
        if (model.image) {
            if ([model.image isKindOfClass:UIImage.class]) {
                [btn setImage:model.image forState:UIControlStateNormal];
            } else if ([model.image isKindOfClass:NSString.class]) {
                if ([model.image hasPrefix:@"http"]) {
                    [btn sd_setImageWithURL:[NSURL URLWithString:model.image] forState:UIControlStateNormal];
                } else {
                    [btn setImage:[UIImage imageNamed:model.image] forState:UIControlStateNormal];
                }
            }
            btn.imagePosition = HDUIButtonImagePositionTop;
            btn.spacingBetweenImageAndTitle = kRealWidth(8);
        }
        [btn addTarget:self action:@selector(clickedContactBTNHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addArrangedSubview:btn];
        i++;
    }
}

- (void)clickedContactBTNHandler:(HDUIButton *)sender {
    NSInteger tag = sender.tag;
    if (self.datasource.count <= tag)
        return;
    WMAlertCallPopModel *model = self.datasource[tag];
    if (self.clickedEventBlock) {
        self.clickedEventBlock(model);
    }
}

- (void)updateConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [super updateConstraints];
}

#pragma mark - HDCustomViewActionViewProtocol
- (void)layoutyImmediately {
    self.frame = (CGRect){0, 0, CGRectGetWidth(self.frame), self.popLevel == 0 ? kRealWidth(138) : kRealWidth(120)};
}

#pragma mark - lazy load
- (UIStackView *)containerView {
    if (!_containerView) {
        _containerView = UIStackView.new;
        _containerView.axis = UILayoutConstraintAxisHorizontal;
        _containerView.distribution = UIStackViewDistributionFillEqually;
        _containerView.spacing = 10;
        _containerView.alignment = UIStackViewAlignmentFill;
    }
    return _containerView;
}

@end
