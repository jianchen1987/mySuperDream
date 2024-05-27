//
//  PNTimePickerView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTimePickerView.h"
#import "HDAppTheme+PayNow.h"


@interface PNTimePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
/// pickerView
@property (nonatomic, strong) UIPickerView *pickerView;
/// 按钮容器
@property (nonatomic, strong) UIView *btnContainer;
/// 取消
@property (nonatomic, strong) HDUIButton *cancelBTN;
/// 确定
@property (nonatomic, strong) HDUIButton *confirmBTN;
/// 小时 数据源
@property (nonatomic, strong) NSMutableArray *hourArray;
/// 分钟 数据源
@property (nonatomic, strong) NSMutableArray *minuteArray;
@end


@implementation PNTimePickerView
- (void)getDataFromFile {
    for (int i = 0; i < 24; i++) {
        [self.hourArray addObject:[NSString stringWithFormat:@"%02d", i]];
    }

    for (int i = 0; i < 60; i++) {
        [self.minuteArray addObject:[NSString stringWithFormat:@"%02d", i]];
    }
}

- (void)setupViews {
    [self getDataFromFile];
    [self addSubview:self.btnContainer];
    [self.btnContainer addSubview:self.cancelBTN];
    [self.btnContainer addSubview:self.confirmBTN];
    [self addSubview:self.pickerView];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)updateConstraints {
    [self.btnContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cancelBTN);
        make.right.equalTo(self.confirmBTN);
        make.top.bottom.equalTo(self.cancelBTN);
    }];
    [self.cancelBTN sizeToFit];
    [self.cancelBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.cancelBTN.bounds.size);
        make.left.top.equalTo(self);
    }];
    [self.confirmBTN sizeToFit];
    [self.confirmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.confirmBTN.bounds.size);
        make.right.top.equalTo(self);
    }];
    [self.pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnContainer.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark - UIPickerViewDataSource
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 1) {
        return kRealWidth(30);
    } else {
        return kRealWidth(50);
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 45.0f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label = (UILabel *)view;
    if (label == nil) {
        label = [[UILabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = [HDAppTheme.PayNowFont fontBold:24];
        label.textAlignment = NSTextAlignmentCenter;
    }

    NSString *output = @"";

    if (component == 0) {
        output = self.hourArray[row];

    } else if (component == 1) {
        output = @":";
    } else {
        output = self.minuteArray[row];
    }

    label.text = output;
    return label;
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.hourArray.count;
    } else if (component == 1) {
        return 1;
    } else {
        return self.minuteArray.count;
    }
}

#pragma mark - event response
- (void)clickedCancelBTNHandler {
    !self.clickedCancelBlock ?: self.clickedCancelBlock();
}

- (void)clickedConfirmBTNHandler {
    if (![self anySubViewScrolling:self.pickerView]) {
        NSString *selectHour = self.hourArray[[self.pickerView selectedRowInComponent:0]];
        NSString *selectMinute = self.minuteArray[[self.pickerView selectedRowInComponent:2]];
        HDLog(@"%@ - %@", selectHour, selectMinute);
        if (self.delegate && [self.delegate respondsToSelector:@selector(cityPickerView:didSelectHour:minute:)]) {
            [self.delegate cityPickerView:self didSelectHour:selectHour minute:selectMinute];
        }

        [self clickedCancelBTNHandler];
    }
}

- (BOOL)anySubViewScrolling:(UIView *)view {
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        if (scrollView.dragging || scrollView.decelerating) {
            return YES;
        }
    }

    for (UIView *theSubView in view.subviews) {
        if ([self anySubViewScrolling:theSubView]) {
            return YES;
        }
    }

    return NO;
}

#pragma mark - lazy load

- (UIView *)btnContainer {
    if (!_btnContainer) {
        _btnContainer = UIView.new;
        _btnContainer.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    }
    return _btnContainer;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = UIPickerView.new;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (HDUIButton *)cancelBTN {
    if (!_cancelBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.PayNowColor.c333333 forState:UIControlStateNormal];
        [button setTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = HDAppTheme.PayNowFont.standard16B;
        button.titleEdgeInsets = UIEdgeInsetsMake(16, 15, 16, 15);
        [button addTarget:self action:@selector(clickedCancelBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _cancelBTN = button;
    }
    return _cancelBTN;
}

- (HDUIButton *)confirmBTN {
    if (!_confirmBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.PayNowColor.c333333 forState:UIControlStateNormal];
        [button setTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons") forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = HDAppTheme.PayNowFont.standard16B;
        button.titleEdgeInsets = UIEdgeInsetsMake(16, 15, 16, 15);
        [button addTarget:self action:@selector(clickedConfirmBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _confirmBTN = button;
    }
    return _confirmBTN;
}

- (NSMutableArray *)hourArray {
    if (!_hourArray) {
        _hourArray = [NSMutableArray array];
    }
    return _hourArray;
}

- (NSMutableArray *)minuteArray {
    if (!_minuteArray) {
        _minuteArray = [NSMutableArray array];
    }
    return _minuteArray;
}

@end
