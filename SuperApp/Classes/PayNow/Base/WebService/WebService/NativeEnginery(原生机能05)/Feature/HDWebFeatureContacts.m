//
//  HDWebFeatureContacts.m
//  ViPay
//
//  Created by seeu on 2019/11/27.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDWebFeatureContacts.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>
//#import "HDTalkingData.h"
#define HDWeakSelf __weak typeof(self) weakSelf = self;
API_AVAILABLE(ios(9.0))
@interface HDWebFeatureContacts () <
    // ABPeoplePickerNavigationControllerDelegate,
    CNContactPickerDelegate>

@property (nonatomic, strong) CNContactPickerViewController *contactVc;
//@property (nonatomic, strong) ABPeoplePickerNavigationController *peoplePicker;

@end

@implementation HDWebFeatureContacts

- (void)webFeatureResponseAction:(WebFeatureResponse)webFeatureResponse {
    self.webFeatureResponse = webFeatureResponse;
    [self requestContactAuth];
}

#pragma mark 请求通讯录权限
- (void)requestContactAuth {

    [self.viewController showloading];

    HDWeakSelf;
    //    if (@available(iOS 9.0, *)) {
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts
                        completionHandler:^(BOOL granted, NSError *_Nullable error) {
                            if (error) {
                                [weakSelf showAuthFailAlert];

                            } else {
                                HDLog(@"成功授权");
                                [weakSelf phoneList];
                                //                                    [HDTalkingData trackEvent:@"话费充值_同意授权通讯录_点击"];
                            }
                        }];
    } else if (status == CNAuthorizationStatusAuthorized) {  //已经授权

        //有通讯录权限-- 进行下一步操作
        [weakSelf phoneList];
    } else {

        [weakSelf showAuthFailAlert];
    }
    //    } else {
    //        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    //        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    //        if (authStatus == kABAuthorizationStatusNotDetermined) {
    //            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
    //                dispatch_async(dispatch_get_main_queue(), ^{
    //                    if (error) {
    //                    } else if (!granted) {
    //                        [weakSelf showAuthFailAlert];
    //                    } else {
    //                        [weakSelf phoneList];
    //                    }
    //                });
    //            });
    //        } else if (authStatus == kABAuthorizationStatusAuthorized) {
    //            [weakSelf phoneList];
    //        } else {
    //            [weakSelf showAuthFailAlert];
    //        }
    //    }

    [self.viewController dismissLoading];
}

- (void)showAuthFailAlert {

    [NAT showAlertWithMessage:PNLocalizedString(@"ALERT_MSG_CONCAT_PRIVACY", @"请在手机'设置'中允许'ViPay'访问您的通讯录")
                  buttonTitle:PNLocalizedString(@"BUTTON_TITLE_CONFIRM", @"确定")
                      handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                          [alertView dismiss];
                      }];
}

- (void)phoneList {
    // 1.创建选择联系人的控制器
    //    if (@available(iOS 9.0, *)) {
    // 3.弹出控制器
    [self.viewController presentViewController:self.contactVc animated:YES completion:nil];
    //    } else {
    //
    //        [self.viewController presentViewController:self.peoplePicker animated:YES completion:nil];
    //    }
}

- (NSString *)phoneFormat:(NSString *)phoneNumber {

    /// 清除特殊符号
    if ([phoneNumber containsString:@"-"]) {
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    if ([phoneNumber containsString:@" "]) {
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    if ([phoneNumber containsString:@"+"]) {
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@"0"];
    }
    if ([phoneNumber containsString:@"("]) {
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    }
    if ([phoneNumber containsString:@")"]) {
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];

    /// 清除855 国家代码
    phoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
    if ([phoneNumber rangeOfString:@"855"].location == 0) {
        phoneNumber = [phoneNumber stringByReplacingCharactersInRange:[phoneNumber rangeOfString:@"855"] withString:@""];
    }
    return phoneNumber;
}

#pragma mark - CNContactPickerDelegate
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker API_AVAILABLE(ios(9.0)) {
    HDLog(@"取消选择联系人");
    self.webFeatureResponse(self, [self responseSuccessWithData:@{@"phone" : @""}]);
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty API_AVAILABLE(ios(9.0)) {

    CNPhoneNumber *phoneNum = contactProperty.value;
    NSString *phoneNumber = phoneNum.stringValue;
    // 回调
    self.webFeatureResponse(self, [self responseSuccessWithData:@{@"phone" : [self phoneFormat:phoneNumber]}]);
}

// 4.2.当选中某一个联系人时会执行该方法
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact API_AVAILABLE(ios(9.0))API_AVAILABLE(ios(9.0)) {

    // 2.获取联系人的电话号码(此处获取的是该联系人的第一个号码,也可以遍历所有的号码)
    NSArray *phoneNums = contact.phoneNumbers;
    CNLabeledValue *labeledValue;

    // 2.1这里需要单独处理一下通讯录中<我>的电话
    if (phoneNums.count) {
        labeledValue = phoneNums[0];
    } else {
        // 这里应该拿到自己电话号码，这里没法获取<CTSettingCopyMyPhoneNumber()这种私有API无法上架>
        CNPhoneNumber *phoneNumer = [CNPhoneNumber phoneNumberWithStringValue:@"请手动输入本机号码"];
        labeledValue = [[CNLabeledValue alloc] initWithLabel:@"无法获取" value:phoneNumer];
    }

    CNPhoneNumber *phoneNumer = labeledValue.value;
    NSString *phoneNumber = phoneNumer.stringValue;

    self.webFeatureResponse(self, [self responseSuccessWithData:@{@"phone" : [self phoneFormat:phoneNumber]}]);
}

//#pragma mark-- ABPeoplePickerNavigationControllerDelegate   进入系统通讯录页面 --
//- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
//                         didSelectPerson:(ABRecordRef)person
//                                property:(ABPropertyID)property
//                              identifier:(ABMultiValueIdentifier)identifier {
//    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
//    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef, identifier);
//    CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef, index);
//
//    __weak __typeof(self) weakSelf = self;
//    [self.viewController dismissViewControllerAnimated:YES
//                                            completion:^{
//                                                __strong __typeof(weakSelf) strongSelf = weakSelf;
//                                                /// 电话
//                                                NSString *text2 = (__bridge NSString *)value;
//                                                strongSelf.webFeatureResponse(strongSelf, [strongSelf responseSuccessWithData:@{@"phone" : [strongSelf phoneFormat:text2]}]);
//                                            }];
//}

#pragma mark - lazy load
- (CNContactPickerViewController *)contactVc API_AVAILABLE(ios(9.0)) {
    if (!_contactVc) {
        _contactVc = [[CNContactPickerViewController alloc] init];
        // 2.设置代理
        _contactVc.delegate = self;
        _contactVc.displayedPropertyKeys = @[ CNContactPhoneNumbersKey ];
        _contactVc.predicateForSelectionOfContact = [NSPredicate predicateWithValue:NO];
    }
    return _contactVc;
}

//- (ABPeoplePickerNavigationController *)peoplePicker {
//    if (!_peoplePicker) {
//        _peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
//        _peoplePicker.peoplePickerDelegate = self;
//    }
//    return _peoplePicker;
//}

@end
