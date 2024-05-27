//
//  PNCityPickerView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/9/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNCityPickerView.h"
#import "PNCityModel.h"


@interface PNCityPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
/// pickerView
@property (nonatomic, strong) UIPickerView *pickerView;
/// 总的数据源
@property (nonatomic, strong) NSMutableDictionary *dictDataSource;
/// 省数据源
@property (nonatomic, strong) NSMutableArray *provinceDataSource;
/// 城市数据源
@property (nonatomic, strong) NSMutableArray *cityDataSource;
/// 按钮容器
@property (nonatomic, strong) UIView *btnContainer;
/// 取消
@property (nonatomic, strong) HDUIButton *cancelBTN;
/// 确定
@property (nonatomic, strong) HDUIButton *confirmBTN;
@end


@implementation PNCityPickerView
- (void)getDataFromFile {
    NSString *file = [[NSBundle mainBundle] pathForResource:@"ChinaCityList-municipality" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:file];

    NSArray<PNCityModel *> *arr = [NSArray yy_modelArrayWithClass:PNCityModel.class json:[NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil]];
    for (PNCityModel *model in arr) {
        if (WJIsStringNotEmpty(model.province)) {
            [self.dictDataSource setValue:model.cities forKey:model.province];
            [self.provinceDataSource addObject:model.province];
        }
    }

    /// 取第一个省的出来
    [self getCitValue:[self.provinceDataSource objectAtIndex:0]];
}

- (void)getCitValue:(NSString *)key {
    [self.cityDataSource removeAllObjects];
    NSArray *valueList = [self.dictDataSource objectForKey:key];
    for (PNCityItemModel *itemModel in valueList) {
        if (WJIsStringNotEmpty(itemModel.name)) {
            [self.cityDataSource addObject:itemModel.name];
        }
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
    return pickerView.frame.size.width / 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 45.0f;
}

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *output = @"";

    if (component == 0) {
        output = self.provinceDataSource[row];

    } else if (component == 1) {
        output = self.cityDataSource[row];
    }

    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:output
                                                                  attributes:@{NSFontAttributeName: [HDAppTheme.font forSize:22], NSForegroundColorAttributeName: HDAppTheme.color.G1}];
    return attrStr;
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceDataSource.count;
    } else if (component == 1) {
        return self.cityDataSource.count;
    } else {
        return 0;
    }
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        NSString *key = [self.provinceDataSource objectAtIndex:row];
        [self getCitValue:key];
        [pickerView reloadComponent:1];
    } else if (component == 1) {
    }
}


#pragma mark - event response
- (void)clickedCancelBTNHandler {
    !self.clickedCancelBlock ?: self.clickedCancelBlock();
}

- (void)clickedConfirmBTNHandler {
    if (![self anySubViewScrolling:self.pickerView]) {
        NSString *selectProvince = self.provinceDataSource[[self.pickerView selectedRowInComponent:0]];
        NSString *selectCity = self.cityDataSource[[self.pickerView selectedRowInComponent:1]];
        HDLog(@"%@ - %@", selectProvince, selectCity);
        if (self.delegate && [self.delegate respondsToSelector:@selector(cityPickerView:didSelectprovince:city:)]) {
            [self.delegate cityPickerView:self didSelectprovince:selectProvince city:selectCity];
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
        _btnContainer.backgroundColor = HDAppTheme.color.G5;
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
        [button setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
        [button setTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = HDAppTheme.font.standard3;
        button.titleEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 15);
        [button addTarget:self action:@selector(clickedCancelBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _cancelBTN = button;
    }
    return _cancelBTN;
}

- (HDUIButton *)confirmBTN {
    if (!_confirmBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
        [button setTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons") forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = HDAppTheme.font.standard3;
        button.titleEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 15);
        [button addTarget:self action:@selector(clickedConfirmBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _confirmBTN = button;
    }
    return _confirmBTN;
}

- (NSMutableDictionary *)dictDataSource {
    if (!_dictDataSource) {
        _dictDataSource = [NSMutableDictionary dictionary];
    }
    return _dictDataSource;
}
- (NSMutableArray *)provinceDataSource {
    if (!_provinceDataSource) {
        _provinceDataSource = [[NSMutableArray alloc] init];
    }
    return _provinceDataSource;
}

- (NSMutableArray *)cityDataSource {
    if (!_cityDataSource) {
        _cityDataSource = [[NSMutableArray alloc] init];
    }
    return _cityDataSource;
}


@end
