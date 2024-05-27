//
//  PNTransferStepView.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTransferStepView.h"

///
typedef NS_ENUM(NSUInteger, PNStepStatus) {
    PNStepStatusNormal = 0,  //默认
    PNStepStatusBingo = 1,   //当前step
    PNStepStatusHadPass = 2, //已经过了
};


@interface PNTransferStepItemView : PNView
///左边线条
@property (strong, nonatomic) UIView *leftLineView;
///
@property (strong, nonatomic) CAShapeLayer *leftShapLayer;
///
@property (strong, nonatomic) CAShapeLayer *rightShapLayer;
///右边线条
@property (strong, nonatomic) UIView *rightLineView;
/// 圆圈
@property (strong, nonatomic) UILabel *stepCircleLabel;
/// 名字
@property (strong, nonatomic) UILabel *nameLabel;
/// 步骤
@property (nonatomic, assign) PNStepStatus status;

@end


@implementation PNTransferStepItemView
- (void)hd_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.leftLineView];
    [self addSubview:self.rightLineView];
    [self addSubview:self.stepCircleLabel];
    [self addSubview:self.nameLabel];
}

- (void)setStatus:(PNStepStatus)status {
    _status = status;
    [self layoutIfNeeded];
    if (status == PNStepStatusNormal) {
        self.stepCircleLabel.layer.borderColor = HDAppTheme.PayNowColor.lineColor.CGColor;
        self.stepCircleLabel.textColor = HDAppTheme.PayNowColor.lineColor;
        self.nameLabel.textColor = HDAppTheme.PayNowColor.cCCCCCC;
        [self.leftLineView drawDashLineWithlineLength:kRealWidth(6) lineSpacing:kRealWidth(2) lineColor:HDAppTheme.PayNowColor.lineColor];
        [self.rightLineView drawDashLineWithlineLength:kRealWidth(6) lineSpacing:kRealWidth(2) lineColor:HDAppTheme.PayNowColor.lineColor];
    } else if (status == PNStepStatusBingo) {
        self.stepCircleLabel.layer.borderColor = HDAppTheme.PayNowColor.mainThemeColor.CGColor;
        self.stepCircleLabel.textColor = [UIColor whiteColor];
        self.stepCircleLabel.backgroundColor = HDAppTheme.PayNowColor.mainThemeColor;
        self.nameLabel.textColor = HDAppTheme.PayNowColor.c333333;

        [self.leftLineView drawDashLineWithlineLength:kRealWidth(6) lineSpacing:kRealWidth(2) lineColor:HDAppTheme.PayNowColor.mainThemeColor];
        [self.rightLineView drawDashLineWithlineLength:kRealWidth(6) lineSpacing:kRealWidth(2) lineColor:HDAppTheme.PayNowColor.lineColor];
    } else if (status == PNStepStatusHadPass) {
        self.stepCircleLabel.layer.borderColor = HDAppTheme.PayNowColor.mainThemeColor.CGColor;
        self.stepCircleLabel.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        self.nameLabel.textColor = HDAppTheme.PayNowColor.c333333;
        [self.leftLineView drawDashLineWithlineLength:kRealWidth(6) lineSpacing:kRealWidth(2) lineColor:HDAppTheme.PayNowColor.mainThemeColor];
        [self.rightLineView drawDashLineWithlineLength:kRealWidth(6) lineSpacing:kRealWidth(2) lineColor:HDAppTheme.PayNowColor.mainThemeColor];
    }
}

- (void)updateConstraints {
    [self.stepCircleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(kRealWidth(12));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(32), kRealWidth(32)));
    }];

    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stepCircleLabel.mas_bottom).offset(kRealWidth(12));
        make.left.right.equalTo(self);
    }];

    [self.leftLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stepCircleLabel.mas_centerY);
        make.left.equalTo(self);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(kRealWidth(20));
    }];

    [self.rightLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stepCircleLabel.mas_centerY);
        make.right.equalTo(self);
        make.width.equalTo(self.leftLineView.mas_width);
        make.height.equalTo(self.leftLineView.mas_height);
    }];

    [super updateConstraints];
}

/** @lazy leftLineView */
- (UIView *)leftLineView {
    if (!_leftLineView) {
        _leftLineView = [[UIView alloc] init];
    }
    return _leftLineView;
}

/** @lazy rightLineView */
- (UIView *)rightLineView {
    if (!_rightLineView) {
        _rightLineView = [[UIView alloc] init];
    }
    return _rightLineView;
}

/** @lazy stepCircleLabel */
- (UILabel *)stepCircleLabel {
    if (!_stepCircleLabel) {
        _stepCircleLabel = [[UILabel alloc] init];
        _stepCircleLabel.font = HDAppTheme.PayNowFont.standard16;
        _stepCircleLabel.textColor = HDAppTheme.PayNowColor.lineColor;
        _stepCircleLabel.layer.cornerRadius = kRealWidth(32) / 2;
        _stepCircleLabel.layer.masksToBounds = YES;
        _stepCircleLabel.layer.borderWidth = PixelOne;
        _stepCircleLabel.layer.borderColor = HDAppTheme.PayNowColor.lineColor.CGColor;
        _stepCircleLabel.backgroundColor = [UIColor whiteColor];
        _stepCircleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _stepCircleLabel;
}

/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [HDAppTheme.PayNowFont fontMedium:12];
        _nameLabel.textColor = HDAppTheme.PayNowColor.lineColor;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}
@end


@interface PNTransferStepView ()
/// 数据源
@property (strong, nonatomic) NSArray *dataArr;
/// 视图数组
@property (strong, nonatomic) NSMutableArray *itemArr;
@end


@implementation PNTransferStepView
- (void)hd_setupViews {
    UIView *lastView = nil;
    CGFloat width = kScreenWidth / self.dataArr.count;
    for (int i = 1; i <= self.dataArr.count; i++) {
        NSString *name = self.dataArr[i - 1];
        PNTransferStepItemView *itemView = [[PNTransferStepItemView alloc] init];
        if (i == 1) {
            itemView.leftLineView.hidden = YES;
        } else if (i == self.dataArr.count) {
            itemView.rightLineView.hidden = YES;
        }

        itemView.nameLabel.text = name;
        itemView.stepCircleLabel.text = [NSString stringWithFormat:@"%d", i];
        itemView.status = PNStepStatusNormal;
        [self addSubview:itemView];

        [itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(width);
            if (lastView) {
                make.left.equalTo(lastView.mas_right);
            } else {
                make.left.equalTo(self);
            }
        }];
        lastView = itemView;
        [self.itemArr addObject:itemView];
    }
}

- (void)setCurrentStep:(NSInteger)step {
    if (step >= self.itemArr.count) {
        step = self.itemArr.count - 1;
    }

    for (int i = 0; i < self.itemArr.count; i++) {
        PNTransferStepItemView *itemView = self.itemArr[i];
        if (i == step) {
            itemView.status = PNStepStatusBingo;
            break;
        } else {
            itemView.status = PNStepStatusHadPass;
        }
    }
}

/** @lazy dataArr */
- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[
            //            PNLocalizedString(@"sAj4Joke", @"开通转账"),
            PNLocalizedString(@"transfer_amount", @"转账金额"),
            PNLocalizedString(@"payer_info", @"付款人信息"),
            PNLocalizedString(@"BUTTON_TITLE_SUBMIT", @"提交")
        ];
    }
    return _dataArr;
}

/** @lazy itemArr */
- (NSMutableArray *)itemArr {
    if (!_itemArr) {
        _itemArr = [NSMutableArray array];
    }
    return _itemArr;
}

@end
