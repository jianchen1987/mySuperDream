//
//  bankListHeaderView.h
//  ViPay
//
//  Created by Quin on 2021/8/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "HDSearchBar.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface PNBankListHeaderView : UITableViewHeaderFooterView <UITextFieldDelegate>

+ (instancetype)headerWithTableView:(UITableView *)tableView;
@property (nonatomic, copy) void (^inputHandler)(NSString *textFieldText);
@property (nonatomic, strong) UIView *backview;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) HDSearchBar *searchBar;
@end

NS_ASSUME_NONNULL_END
