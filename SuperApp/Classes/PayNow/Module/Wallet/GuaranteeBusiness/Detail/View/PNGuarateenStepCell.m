//
//  PNGuarateenStepCell.m
//  SuperApp
//
//  Created by xixi_wen on 2023/1/10.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNGuarateenStepCell.h"
#import "PNGuarateenDetailModel.h"


@interface PNGuarateenStepCell ()
@property (nonatomic, strong) SALabel *stepLabel;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) UIView *leftLineView;

@property (nonatomic, strong) PNGuarateenFlowModel *model;
@end


@implementation PNGuarateenStepCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.stepLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.leftLineView];
}

- (void)updateConstraints {
    [self.stepLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.top.mas_equalTo(self.contentView.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        if (self.leftLineView.hidden) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        }
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.stepLabel.mas_bottom).offset(kRealWidth(8));
        make.left.mas_equalTo(self.stepLabel.mas_left).offset(-kRealWidth(20));
        make.right.mas_equalTo(self.stepLabel.mas_right).offset(kRealWidth(20));
        //        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];

    if (!self.leftLineView.hidden) {
        [self.leftLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(kRealWidth(2)));
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.stepLabel.mas_left).offset(-kRealWidth(12));
            make.centerY.mas_equalTo(self.stepLabel.mas_centerY);
            make.width.mas_equalTo(@(kRealWidth(32)));
        }];
    }

    [super updateConstraints];
}

#pragma mark
//- (void)refreshCell:(PNGuarateenFlowModel *)model index:(NSInteger)index flowstep:(NSInteger)step {
- (void)refreshCell:(NSArray *)arr index:(NSInteger)index flowstep:(NSInteger)step {
    //    _model = model;

    NSArray *modelArray = [NSArray yy_modelArrayWithClass:PNGuarateenFlowModel.class json:[arr yy_modelToJSONData]];

    NSString *str = @"";
    if (modelArray.count > 0) {
        PNGuarateenFlowModel *obj = modelArray.firstObject;
        str = [str stringByAppendingFormat:@"%@", obj.message];
    }

    if (modelArray.count > 1) {
        PNGuarateenFlowModel *obj = [modelArray objectAtIndex:1];
        str = [str stringByAppendingFormat:@"\n%@", obj.message];
    }

    self.titleLabel.text = str;

    self.stepLabel.text = [NSString stringWithFormat:@"%zd", index + 1];

    if (index == (step - 1)) {
        self.stepLabel.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        self.stepLabel.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        self.titleLabel.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        self.leftLineView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        self.stepLabel.alpha = 1;
        self.titleLabel.alpha = 1;
        self.leftLineView.alpha = 1;
    } else {
        self.stepLabel.alpha = 0.7;
        self.titleLabel.alpha = 0.7;
        self.leftLineView.alpha = 0.7;
    }

    if (index == 0) {
        self.leftLineView.hidden = YES;
    } else {
        self.leftLineView.hidden = NO;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (SALabel *)stepLabel {
    if (!_stepLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        label.font = [HDAppTheme.PayNowFont fontDINBold:16];
        label.textAlignment = NSTextAlignmentCenter;
        _stepLabel = label;

        label.layer.cornerRadius = kRealWidth(16);
        label.layer.masksToBounds = YES;
    }
    return _stepLabel;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIView *)leftLineView {
    if (!_leftLineView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _leftLineView = view;
    }
    return _leftLineView;
}

@end
