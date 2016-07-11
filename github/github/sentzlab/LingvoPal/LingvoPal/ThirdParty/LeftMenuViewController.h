//
//  LeftMenuViewController.h
//  LingvoPal
//
//  Created by Artak on 2/15/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class OrderViewController;
@class FindInterpreterViewController;
@class HistoryViewController;

@class MyOrdersViewController;
@class TranslatorHistoryViewController;
//@class TranslatorReviewViewController;
@class PaymentViewConytoller;
@class TranslatorSettingsViewController;

@interface LeftMenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
}

//@property (nonatomic, strong) OrderViewController *orderViewController;
@property (nonatomic, strong) FindInterpreterViewController *findInterpreterViewController;
@property (nonatomic, strong) HistoryViewController *historyViewController;
//@property (nonatomic, strong) ProfileViewController *profileViewController;

@property (nonatomic, strong) MyOrdersViewController *myOrdersViewController;
@property (nonatomic, strong) TranslatorHistoryViewController *translatorHistoryViewController;
//@property (nonatomic, strong) TranslatorReviewViewController *translatorReviewViewController;
@property (nonatomic, strong) PaymentViewConytoller *paymentViewConytoller;
@property (nonatomic, strong) TranslatorSettingsViewController *translatorSettingsViewController;


@property (nonatomic, assign) BOOL isTranlator;

-(void) leftMenuOpened;
-(void) leftMenuClosed;

-(void) openOrders;

@end
