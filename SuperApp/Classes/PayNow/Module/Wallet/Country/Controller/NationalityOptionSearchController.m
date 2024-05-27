//
//  NationalityOptionSearchController.m
//  customer
//
//  Created by 谢 on 2019/1/3.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "NationalityOptionSearchController.h"
#import "CountryTableViewCell.h"
#import "HDCountrySectionModel.h"
#import "HDCountrySliderChooseView.h"


@interface NationalityOptionSearchController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HDCountrySliderChooseView *countrySliderChooseView;
@property (nonatomic, strong) NSMutableArray<CountryModel *> *dataSource;
@property (nonatomic, strong) NSMutableArray<CountryModel *> *dataSourceBackup;
@property (nonatomic, strong) NSMutableArray *allChar;
@property (nonatomic, strong) UITextField *searchBar;
@end


@implementation NationalityOptionSearchController

- (void)viewDidLoad {
    [super viewDidLoad];

    _countrySliderChooseView = [[HDCountrySliderChooseView alloc] init];
    __weak __typeof(self) weakSelf = self;
    _countrySliderChooseView.selectCountryUnitViewHandler = ^(CountryModel *model) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;

        !strongSelf.choosedCountryHandler ?: strongSelf.choosedCountryHandler(model);

        [strongSelf.navigationController popViewControllerAnimated:true];
    };
    [self.view addSubview:_countrySliderChooseView];

    NSArray<NSString *> *popularCountries = @[@"KH", @"VN", @"CN", @"TH", @"KR", @"JP"];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:CountryTableViewCell.class forCellReuseIdentifier:NSStringFromClass(CountryTableViewCell.class)];
    [self.view addSubview:self.tableView];

    NSString *file = [[NSBundle mainBundle] pathForResource:PNLocalizedString(@"COUNTRY_TYPE", @"语言文件") ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:file];

    NSArray<HDCountrySectionModel *> *countryModels = [NSArray yy_modelArrayWithClass:HDCountrySectionModel.class json:[NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding
                                                                                                                                                         error:nil]];

    self.dataSource = [NSMutableArray array];
    self.allChar = [NSMutableArray array];
    for (HDCountrySectionModel *sectionModel in countryModels) {
        for (CountryModel *model in sectionModel.data) {
            [self.dataSource addObject:model];
        }
    }

    self.dataSourceBackup = [self.dataSource mutableCopy];

    NSArray<CountryModel *> *popularCountriesArray =
        [self.dataSource filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(CountryModel *model, NSDictionary<NSString *, id> *_Nullable bindings) {
                             return [popularCountries containsObject:model.countryCode];
                         }]];
    // 排序
    popularCountriesArray = [popularCountriesArray sortedArrayUsingComparator:^NSComparisonResult(CountryModel *_Nonnull obj1, CountryModel *_Nonnull obj2) {
        return [popularCountries indexOfObject:obj1.countryCode] > [popularCountries indexOfObject:obj2.countryCode];
    }];

    self.countrySliderChooseView.dataSource = popularCountriesArray;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 100, 35)];
    UIColor *color = self.navigationController.navigationBar.barTintColor;
    [View setBackgroundColor:color];

    UITextField *searchBar = [[UITextField alloc] init];
    searchBar.delegate = self;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar = searchBar;
    [searchBar addTarget:self action:@selector(searchUpdate) forControlEvents:UIControlEventEditingChanged];
    searchBar.frame = CGRectMake(0, 0, kScreenWidth - 100, 35);
    searchBar.backgroundColor = color;

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 34, kScreenWidth - 100, 1)];
    line.backgroundColor = [UIColor hd_colorWithHexString:@"#F1F2F3"];
    [searchBar addSubview:line];
    [searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];
    searchBar.placeholder = PNLocalizedString(@"SEARCH", @"搜索");
    [View addSubview:searchBar];

    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = View;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    [self.countrySliderChooseView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.width.centerX.equalTo(self.view);
        make.top.mas_equalTo(self.countrySliderChooseView.mas_bottom);
    }];
}

#pragma mark - event response
- (void)searchUpdate {
    [self updateView:self.searchBar.text];
}

- (void)searchUpdate:(UITextField *)tf {
    if ([tf.text isEqualToString:@""]) {
        self.dataSource = [self.dataSourceBackup copy];
    } else {
        [self.dataSource removeAllObjects];
        for (int i = 0; i < self.dataSourceBackup.count; i++) {
            CountryModel *model = self.dataSourceBackup[i];
            if ([model.countryName rangeOfString:tf.text].length || [model.countryPinyin rangeOfString:tf.text].length) {
                [self.dataSource addObject:model];
            }
        }
    }
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CountryTableViewCell *cell = [CountryTableViewCell cellWithTableView:tableView];

    CountryModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.countryName;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CountryModel *unitDic = self.dataSource[indexPath.row];

    if (self.choosedCountryHandler) {
        self.choosedCountryHandler(unitDic);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSString *)toReadableJSONString:(NSArray *)array {
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];

    if (data == nil) {
        return nil;
    }

    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

- (void)updateView:(NSString *)detail {
    if ([detail isEqualToString:@""]) {
        self.dataSource = [self.dataSourceBackup mutableCopy];
    } else {
        [self.dataSource removeAllObjects];
        for (int i = 0; i < self.dataSourceBackup.count; i++) {
            CountryModel *model = self.dataSourceBackup[i];
            if ([model.countryName rangeOfString:detail].length || [model.countryPinyin rangeOfString:detail].length) {
                [self.dataSource addObject:model];
            }
        }
    }
    [self.tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        self.dataSource = [self.dataSourceBackup mutableCopy];
    } else {
        [self.dataSource removeAllObjects];
        for (int i = 0; i < self.dataSourceBackup.count; i++) {
            CountryModel *model = self.dataSourceBackup[i];
            if ([model.countryName rangeOfString:textField.text].length || [model.countryPinyin rangeOfString:textField.text].length) {
                [self.dataSource addObject:model];
            }
        }
    }
    [self.tableView reloadData];
    return YES;
}

//- (HDNavigationStyle)navigationBarStyleForViewController:(HDBaseViewController *)viewController {
//    return HDNavigationStyleWhite;
//}
@end
