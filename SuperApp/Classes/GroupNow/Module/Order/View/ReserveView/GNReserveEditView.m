//
//  GNReserveEditView.m
//  SuperApp
//
//  Created by wmz on 2022/9/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNReserveEditView.h"
#import "GNReserveViewModel.h"


@interface GNReserveEditView () <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>
///预约时间文本
@property (nonatomic, strong) HDLabel *arrivalLB;
///预约时间
@property (nonatomic, strong) UICollectionView *arrivalView;
/// numberView
@property (nonatomic, strong) UIView *numberView;
/// numberLB
@property (nonatomic, strong) HDLabel *numberLB;
/// numberTF
@property (nonatomic, strong) UITextField *numberTF;
/// numberAdd
@property (nonatomic, strong) HDUIButton *numberAddBTN;
/// numberdel
@property (nonatomic, strong) HDUIButton *numberDelBTN;
/// bookView
@property (nonatomic, strong) UIView *bookView;
/// boolLB
@property (nonatomic, strong) HDLabel *bookLB;
/// inputBg
@property (nonatomic, strong) UIView *bookTfBg;
/// phoneView
@property (nonatomic, strong) UIView *phoneView;
/// phoneLB
@property (nonatomic, strong) HDLabel *phoneLB;
/// phoneFirstLB
@property (nonatomic, strong) HDLabel *phoneFirstLB;
/// inputBg
@property (nonatomic, strong) UIView *phoneTfBg;
///预约时间数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
/// viewModel
@property (nonatomic, strong) GNReserveViewModel *viewModel;

@end


@implementation GNReserveEditView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.arrivalLB];
    [self addSubview:self.arrivalView];

    [self addSubview:self.numberView];
    [self.numberView addSubview:self.numberLB];
    [self.numberView addSubview:self.numberAddBTN];
    [self.numberView addSubview:self.numberDelBTN];
    [self.numberView addSubview:self.numberTF];

    [self addSubview:self.bookView];
    [self.bookView addSubview:self.bookLB];
    [self.bookView addSubview:self.bookTfBg];
    [self.bookTfBg addSubview:self.bookTF];

    [self addSubview:self.phoneView];
    [self.phoneView addSubview:self.phoneLB];
    [self.phoneView addSubview:self.phoneFirstLB];
    [self.phoneView addSubview:self.phoneTfBg];
    [self.phoneTfBg addSubview:self.phoneTF];

    if (self.viewModel.reserveModel) {
        self.count = self.viewModel.reserveModel.reservationNum.integerValue;
        self.bookTF.text = self.viewModel.reserveModel.reservationUser;
        NSString *phone = [self.viewModel.reserveModel.reservationPhone hasPrefix:@"855"] ?
                              [self.viewModel.reserveModel.reservationPhone stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""] :
                              self.viewModel.reserveModel.reservationPhone;
        self.phoneTF.text = phone;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.viewModel.reserveModel.reservationTime.doubleValue / 1000];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        self.selectTime = [dateFormatter stringFromDate:date];
    } else {
        self.count = 1;
    }
    [self checkEnableAction];
}

- (void)updateConstraints {
    [self.arrivalLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(16));
        make.right.mas_equalTo(-kRealWidth(16));
        make.top.mas_equalTo(kRealWidth(8));
    }];

    [self.arrivalView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.arrivalLB.mas_bottom).offset(kRealWidth(8));
        make.height.mas_equalTo(kRealWidth(36));
        make.left.right.mas_equalTo(0);
    }];

    [self.numberView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.arrivalView.mas_bottom).offset(kRealWidth(16));
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kRealWidth(36));
    }];

    [self.numberLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(16));
        make.centerY.mas_equalTo(0);
    }];
    [self.numberLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.numberLB setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];

    [self.numberAddBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(16));
        make.centerY.mas_equalTo(0);
    }];

    [self.numberTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numberAddBTN.mas_left).offset(-kRealWidth(9));
        make.centerY.mas_equalTo(0);
    }];

    [self.numberDelBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numberTF.mas_left).offset(-kRealWidth(9));
        make.centerY.mas_equalTo(0);
        make.left.equalTo(self.numberLB.mas_right).offset(kRealWidth(4));
    }];

    [self.bookView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberView.mas_bottom).offset(kRealWidth(12));
        make.left.right.mas_equalTo(0);
    }];

    [self.bookLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(16));
        make.right.mas_equalTo(-kRealWidth(16));
        make.top.mas_equalTo(kRealWidth(8));
    }];

    [self.bookTfBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bookLB);
        make.top.equalTo(self.bookLB.mas_bottom).offset(kRealWidth(4));
        make.height.mas_equalTo(kRealWidth(44));
        make.bottom.mas_equalTo(-kRealWidth(8));
    }];

    [self.bookTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-kRealWidth(12));
    }];

    [self.phoneView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bookView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kRealWidth(8));
    }];

    [self.phoneLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(16));
        make.right.mas_equalTo(-kRealWidth(16));
        make.top.mas_equalTo(kRealWidth(8));
    }];

    [self.phoneFirstLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bookLB);
        make.width.height.mas_equalTo(kRealWidth(44));
        make.top.equalTo(self.phoneLB.mas_bottom).offset(kRealWidth(4));
        make.bottom.mas_equalTo(-kRealWidth(8));
    }];

    [self.phoneTfBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.phoneLB);
        make.height.top.equalTo(self.phoneFirstLB);
        make.left.equalTo(self.phoneFirstLB.mas_right).offset(kRealWidth(12));
    }];

    [self.phoneTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-kRealWidth(12));
    }];
    [self.phoneTfBg setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.phoneTfBg setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [super updateConstraints];
}

///转换为秒
- (int)changeSecond:(NSArray *)timeArr {
    if (!HDIsArrayEmpty(timeArr) && timeArr.count == 2) {
        return [timeArr.firstObject intValue] * 3600 + ([timeArr.lastObject intValue] == 59 ? 60 : [timeArr.lastObject intValue]) * 60;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GNReserveArrvalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GNReserveArrvalCell" forIndexPath:indexPath];
    cell.label.text = self.dataSource[indexPath.row];
    cell.label.layer.backgroundColor = HDAppTheme.color.gn_whiteColor.CGColor;
    cell.label.layer.cornerRadius = kRealWidth(14);
    cell.label.layer.borderWidth = HDAppTheme.value.gn_border;
    cell.label.layer.borderColor = HDAppTheme.color.gn_333Color.CGColor;
    cell.label.textColor = HDAppTheme.color.gn_333Color;
    if ([self.dataSource[indexPath.row] isEqualToString:self.selectTime]) {
        cell.label.layer.borderWidth = 0;
        cell.label.textColor = UIColor.whiteColor;
        cell.label.layer.backgroundColor = HDAppTheme.color.gn_333Color.CGColor;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectTime = self.dataSource[indexPath.row];
}

- (void)textFieldDidChange:(UITextField *)textField {
    [self checkEnableAction];
    if (textField == self.numberTF) {
        if (textField.text.length) {
            self.count = [textField.text intValue];
        }
    }
}

- (void)handleTextFieldTextDidChangeAction:(UITextField *)textField {
    NSInteger br_maxLength = 30;
    NSString *toBeginString = textField.text;
    UITextRange *selectRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectRange.start offset:0];
    if ((!position || !selectRange) && (br_maxLength > 0 && toBeginString.length > br_maxLength && [textField isFirstResponder])) {
        NSRange rangeIndex = [toBeginString rangeOfComposedCharacterSequenceAtIndex:br_maxLength];
        if (rangeIndex.length == 1) {
            textField.text = [toBeginString substringToIndex:br_maxLength];
        } else {
            NSRange tempRange = [toBeginString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, br_maxLength)];
            NSInteger tempLength = 0;
            if (tempRange.length > br_maxLength) {
                tempLength = tempRange.length - rangeIndex.length;
            } else {
                tempLength = tempRange.length;
            }
            textField.text = [toBeginString substringWithRange:NSMakeRange(0, tempLength)];
        }
    }
    [self checkEnableAction];
}

/// deleagte
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!textField.text.length && textField == self.numberTF) {
        self.count = 1;
    }

    if (textField == self.bookTF) {
        self.bookTfBg.layer.borderColor = HDAppTheme.color.gn_lineColor.CGColor;
    } else if (textField == self.phoneTF) {
        self.phoneTfBg.layer.borderColor = HDAppTheme.color.gn_lineColor.CGColor;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.bookTF) {
        self.bookTfBg.layer.borderColor = HDAppTheme.color.gn_mainColor.CGColor;
    } else if (textField == self.phoneTF) {
        self.phoneTfBg.layer.borderColor = HDAppTheme.color.gn_mainColor.CGColor;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.numberTF) {
        if ([string isEqualToString:@""])
            return YES;
        NSString *regex = @"^[0-9]+([.]{0,1}[0-9]+){0,1}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        return [pred evaluateWithObject:string];
    }
    return YES;
}

- (void)checkEnableAction {
    self.checkEnable = (self.selectModel && self.selectTime && HDIsStringNotEmpty(self.phoneTF.text) && HDIsStringNotEmpty(self.bookTF.text) && self.count);
}

- (void)setBusinessHours:(NSArray<NSString *> *)businessHours {
    _businessHours = businessHours;
    self.dataSource = [NSMutableArray arrayWithArray:[businessHours sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
                                          int firstSecond = 0;
                                          int lastSecond = 0;
                                          if ([obj1 containsString:@":"]) {
                                              NSArray *firstArr = [obj1 componentsSeparatedByString:@":"];
                                              firstSecond = [self changeSecond:firstArr];
                                          }
                                          if ([obj2 containsString:@":"]) {
                                              NSArray *lastArr = [obj2 componentsSeparatedByString:@":"];
                                              lastSecond = [self changeSecond:lastArr];
                                          }
                                          return firstSecond > lastSecond;
                                      }]];
    ///日期筛选
    if (self.selectModel && self.selectModel.wToday) {
        NSDate *date = NSDate.date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *nowStr = [dateFormatter stringFromDate:date];
        NSArray *nowArr = [nowStr componentsSeparatedByString:@":"];
        NSInteger nowSecond = [self changeSecond:nowArr];
        self.dataSource = [NSMutableArray arrayWithArray:[self.dataSource hd_filterWithBlock:^BOOL(NSString *item) {
                                              NSArray *firstArr = [item componentsSeparatedByString:@":"];
                                              NSInteger firstSecond = [self changeSecond:firstArr];
                                              return firstSecond >= nowSecond;
                                          }]];
    }
    [self.arrivalView reloadData];
    ///滑动至所选处
    if (self.viewModel.reserveModel) {
        NSInteger index = [self.dataSource indexOfObject:self.selectTime];
        if (index != NSNotFound && [self.arrivalView numberOfItemsInSection:0] > index) {
            [self.arrivalView layoutIfNeeded];
            [self.arrivalView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        }
    }
}

- (void)setCount:(NSInteger)count {
    _count = count;
    self.numberTF.text = @(MAX(1, count)).stringValue;
}

- (void)setSelectTime:(NSString *)selectTime {
    _selectTime = selectTime;
    [self.arrivalView reloadData];
    if (!selectTime) {
        [self.arrivalView setContentOffset:CGPointMake(-self.arrivalView.contentInset.left, 0) animated:NO];
    }
    [self checkEnableAction];
}

- (void)setSelectModel:(GNReserveCalanderModel *)selectModel {
    _selectModel = selectModel;
    [self checkEnableAction];
}

- (HDLabel *)arrivalLB {
    if (!_arrivalLB) {
        HDLabel *label = HDLabel.new;
        label.font = [HDAppTheme.font gn_boldForSize:14];
        label.textColor = HDAppTheme.color.gn_333Color;
        label.text = GNLocalizedString(@"gn_arrival_time", @"Arrival time");
        _arrivalLB = label;
    }
    return _arrivalLB;
}

- (UICollectionView *)arrivalView {
    if (!_arrivalView) {
        UICollectionViewFlowLayout *flowLayout = UICollectionViewFlowLayout.new;
        flowLayout.itemSize = CGSizeMake(kRealWidth(60), kRealWidth(28));
        flowLayout.minimumLineSpacing = kRealWidth(8);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = kRealWidth(8);
        _arrivalView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _arrivalView.delegate = self;
        _arrivalView.dataSource = self;
        _arrivalView.backgroundColor = UIColor.whiteColor;
        _arrivalView.showsVerticalScrollIndicator = NO;
        _arrivalView.showsHorizontalScrollIndicator = NO;
        _arrivalView.contentInset = UIEdgeInsetsMake(0, kRealWidth(16), 0, kRealWidth(16));
        [_arrivalView registerClass:GNReserveArrvalCell.class forCellWithReuseIdentifier:@"GNReserveArrvalCell"];
    }
    return _arrivalView;
}

- (UIView *)numberView {
    if (!_numberView) {
        _numberView = UIView.new;
    }
    return _numberView;
}

- (HDLabel *)numberLB {
    if (!_numberLB) {
        HDLabel *label = HDLabel.new;
        label.font = [HDAppTheme.font gn_boldForSize:14];
        label.textColor = HDAppTheme.color.gn_333Color;
        label.text = GNLocalizedString(@"gn_numbe_booking", @"Number of reservatio");
        _numberLB = label;
    }
    return _numberLB;
}

- (UITextField *)numberTF {
    if (!_numberTF) {
        UITextField *label = UITextField.new;
        label.font = [HDAppTheme.WMFont wm_ForSize:14 fontName:@"DIN-Bold"];
        label.textColor = HDAppTheme.color.gn_333Color;
        label.tintColor = HDAppTheme.color.gn_mainColor;
        label.delegate = self;
        [label addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _numberTF = label;
    }
    return _numberTF;
}

- (HDUIButton *)numberAddBTN {
    if (!_numberAddBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gn_reserve_add"] forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake(5, kRealWidth(5), 5, kRealWidth(5));
        @HDWeakify(self)[btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) self.count += 1;
        }];
        _numberAddBTN = btn;
    }
    return _numberAddBTN;
}

- (HDUIButton *)numberDelBTN {
    if (!_numberDelBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gn_reserve_del"] forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake(5, kRealWidth(5), 5, kRealWidth(5));
        @HDWeakify(self)[btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) if (self.count == 1) return;
            self.count -= 1;
        }];
        _numberDelBTN = btn;
    }
    return _numberDelBTN;
}

- (UIView *)phoneView {
    if (!_phoneView) {
        _phoneView = UIView.new;
    }
    return _phoneView;
}

- (HDLabel *)phoneLB {
    if (!_phoneLB) {
        HDLabel *label = HDLabel.new;
        label.font = [HDAppTheme.font gn_boldForSize:14];
        label.textColor = HDAppTheme.color.gn_333Color;
        label.text = TNLocalizedString(@"EflnCwt2", @"手机号");
        _phoneLB = label;
    }
    return _phoneLB;
}

- (HDLabel *)phoneFirstLB {
    if (!_phoneFirstLB) {
        HDLabel *label = HDLabel.new;
        label.font = [HDAppTheme.font gn_ForSize:14];
        label.textColor = HDAppTheme.color.gn_333Color;
        label.text = @"855";
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderWidth = HDAppTheme.value.gn_border;
        label.layer.borderColor = HDAppTheme.color.gn_lineColor.CGColor;
        label.layer.cornerRadius = kRealWidth(2);
        label.layer.backgroundColor = UIColor.whiteColor.CGColor;
        _phoneFirstLB = label;
    }
    return _phoneFirstLB;
}

- (UIView *)phoneTfBg {
    if (!_phoneTfBg) {
        _phoneTfBg = UIView.new;
        _phoneTfBg.layer.backgroundColor = UIColor.whiteColor.CGColor;
        _phoneTfBg.layer.borderWidth = HDAppTheme.value.gn_border;
        _phoneTfBg.layer.borderColor = HDAppTheme.color.gn_lineColor.CGColor;
        _phoneTfBg.layer.cornerRadius = kRealWidth(2);
    }
    return _phoneTfBg;
}

- (UITextField *)phoneTF {
    if (!_phoneTF) {
        UITextField *tf = UITextField.new;
        tf.font = [HDAppTheme.font gn_ForSize:14];
        tf.tintColor = HDAppTheme.color.gn_mainColor;
        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        tf.keyboardType = UIKeyboardTypeNumberPad;
        tf.textColor = HDAppTheme.color.gn_333Color;
        tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:GNLocalizedString(@"gn_please_enter_phone_number", @"Enter the phone number")
                                                                   attributes:@{NSFontAttributeName: [HDAppTheme.font gn_ForSize:14], NSForegroundColorAttributeName: HDAppTheme.color.gn_cccccc}];
        [tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        tf.delegate = self;
        _phoneTF = tf;
    }
    return _phoneTF;
}

- (UIView *)bookView {
    if (!_bookView) {
        _bookView = UIView.new;
    }
    return _bookView;
}

- (UIView *)bookTfBg {
    if (!_bookTfBg) {
        _bookTfBg = UIView.new;
        _bookTfBg.layer.backgroundColor = UIColor.whiteColor.CGColor;
        _bookTfBg.layer.borderWidth = HDAppTheme.value.gn_border;
        _bookTfBg.layer.borderColor = HDAppTheme.color.gn_lineColor.CGColor;
        _bookTfBg.layer.cornerRadius = kRealWidth(2);
    }
    return _bookTfBg;
}

- (HDLabel *)bookLB {
    if (!_bookLB) {
        HDLabel *label = HDLabel.new;
        label.font = [HDAppTheme.font gn_boldForSize:14];
        label.textColor = HDAppTheme.color.gn_333Color;
        label.text = GNLocalizedString(@"gn_booker", @"Booking people");
        _bookLB = label;
    }
    return _bookLB;
}

- (UITextField *)bookTF {
    if (!_bookTF) {
        UITextField *tf = UITextField.new;
        tf.font = [HDAppTheme.font gn_ForSize:14];
        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        tf.tintColor = HDAppTheme.color.gn_mainColor;
        tf.textColor = HDAppTheme.color.gn_333Color;
        tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:GNLocalizedString(@"gn_please_enter_booker_name", @"Enter the booker's name")
                                                                   attributes:@{NSFontAttributeName: [HDAppTheme.font gn_ForSize:14], NSForegroundColorAttributeName: HDAppTheme.color.gn_cccccc}];
        [tf addTarget:self action:@selector(handleTextFieldTextDidChangeAction:) forControlEvents:UIControlEventEditingChanged];
        tf.delegate = self;
        _bookTF = tf;
    }
    return _bookTF;
}

@end


@implementation GNReserveArrvalCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.label];
}

- (void)updateConstraints {
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [super updateConstraints];
}

- (HDLabel *)label {
    if (!_label) {
        HDLabel *label = HDLabel.new;
        label.font = [HDAppTheme.WMFont wm_ForMoneyDinSize:14];
        label.textColor = HDAppTheme.color.gn_333Color;
        label.textAlignment = NSTextAlignmentCenter;
        _label = label;
    }
    return _label;
}

@end
