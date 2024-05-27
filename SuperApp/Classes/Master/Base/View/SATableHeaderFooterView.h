//
//  SATableHeaderFooterView.h
//  SuperApp
//
//  Created by VanJay on 2020/6/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <HDKitCore/HDKitCore.h>
#import <Masonry/Masonry.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SATableHeaderFooterViewProtocol <NSObject>

@optional

+ (instancetype)headerWithTableView:(UITableView *)tableView;

+ (instancetype)headerWithTableView:(UITableView *)tableView identifier:(NSString *_Nullable)identifier;

- (void)hd_setupViews;

@end


@interface SATableHeaderFooterView : UITableViewHeaderFooterView <SATableHeaderFooterViewProtocol>

@end

NS_ASSUME_NONNULL_END
