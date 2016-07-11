//
//  PaymentViewConytoller.m
//  LingvoPal
//
//  Created by Artak on 2/8/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import "PaymentViewConytoller.h"
#import "Helper.h"
#import "AppDelegate.h"
#import "MFSideMenuContainerViewController.h"
#import "AddCardViewController.h"
#import "CardsCell.h"

@interface PaymentViewConytoller () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UILabel *noCardsLabel;

@property (nonatomic, strong) UILabel *yourPremiumLabel;
@property (nonatomic, strong) UILabel *nonPremiumLabel;


@property (nonatomic, strong) UIImageView *premiumCardIcon;
@property (nonatomic, strong) UILabel *premiumCardNumber;

@property (nonnull, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *cardsTableView;

@property (nonatomic, strong) NSArray *cardItems;

@property (nonnull, strong) UIView *greyView;

@end

@implementation PaymentViewConytoller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bkgImageView.image = [Helper getImageByImageName:@"gradient"];
    // Do any additional setup after loading the view.
    
    self.cardItems = [NSArray arrayWithObjects:@"********2212",
                      @"********2114",
                      @"********2619",
                      @"********2182",
                      @"********2212",
                      @"********2212",
                      @"********2212",
                      nil];
    UIButton * menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[Helper getImageByImageName:@"burger"] forState:UIControlStateNormal];
    menuButton.frame = [Helper getRectValue:CGRectMake(5, 20, 41, 34)];
    [menuButton addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(50, 26, 260, 22)]];
    titleLabel.text = @"Payments";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [Helper fontWithSize:16];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    titleLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:titleLabel];
    
    UIButton * addCardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addCardButton setBackgroundImage:[Helper getImageByImageName:@"add_card_cell"] forState:UIControlStateNormal];
    [addCardButton setTitle:@"ADD CARD" forState:UIControlStateNormal];
    addCardButton.titleLabel.font = [Helper fontWithSize:18];
    addCardButton.frame = [Helper getRectValue:CGRectMake(40, [Helper isiPhone4] ? 415 : 503 , 240, 30)];
    [addCardButton addTarget:self action:@selector(addCardAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addCardButton];
    
    self.noCardsLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(50, 170, 220, 30)]];
    self.noCardsLabel.font = [Helper fontWithSize:24];
    self.noCardsLabel.textAlignment = NSTextAlignmentCenter;
    self.noCardsLabel.textColor = [UIColor whiteColor];
    self.noCardsLabel.text = @"You have no cards";
    self.noCardsLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    self.noCardsLabel.shadowOffset = CGSizeMake(1, 1);
    //  [self.view addSubview:self.noCardsLabel];
    
    self.yourPremiumLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(50, 85, 220, 30)]];
    self.yourPremiumLabel.font = [Helper fontWithSize:24];
    self.yourPremiumLabel.textAlignment = NSTextAlignmentCenter;
    self.yourPremiumLabel.textColor = [UIColor whiteColor];
    self.yourPremiumLabel.text = @"Your Premium Card";
    self.yourPremiumLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    self.yourPremiumLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:self.yourPremiumLabel];
    
    UIView *premiumView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 120, 320, 52)]];
    premiumView.backgroundColor = [UIColor whiteColor];
    premiumView.layer.cornerRadius = [Helper getValue:3];
    [self.view addSubview:premiumView];
    
    self.premiumCardIcon = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"visa_card"]];
    self.premiumCardIcon.center = [Helper getPointValue:CGPointMake(35, 26)];
    [premiumView addSubview:self.premiumCardIcon];
    
    self.premiumCardNumber = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(70, 15, 100, 22)]];
    self.premiumCardNumber.text = @"********2312";
    self.premiumCardNumber.font = [Helper fontWithSize:16];
    [premiumView addSubview:self.premiumCardNumber];
    
    self.nonPremiumLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(50, 175, 220, 30)]];
    self.nonPremiumLabel.font = [Helper fontWithSize:24];
    self.nonPremiumLabel.textAlignment = NSTextAlignmentCenter;
    self.nonPremiumLabel.textColor = [UIColor whiteColor];
    self.nonPremiumLabel.text = @"Non Premium Cards";
    self.nonPremiumLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    self.nonPremiumLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:self.nonPremiumLabel];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 210, 310, [Helper isiPhone4] ? 160 : 258)]];
    self.scrollView.backgroundColor = [UIColor yellowColor];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake([Helper getValue:320], [Helper getValue:([Helper isiPhone4] ? 160 : 258)]);
    self.scrollView.minimumZoomScale = 0.5f;
    self.scrollView.maximumZoomScale = 3.0f;
 //   [self.view addSubview:self.scrollView];
    
    self.cardsTableView = [[UITableView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 210, 320, [Helper isiPhone4] ? 160 : 258)]];
    self.cardsTableView.backgroundColor = [UIColor clearColor];
    self.cardsTableView.dataSource = self;
    self.cardsTableView.delegate = self;
    self.cardsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.cardsTableView];
}

-(void) menuAction:(UIButton *) button{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.menuViewController toggleLeftSideMenuCompletion:^{
        
    }];
}

-(void) addCardAction:(UIButton *) button{
    AddCardViewController *viewController = [[AddCardViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)premiumAction:(UIButton *) button{
//    UIImage *image = [self captureFullScreen];
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = appDelegate.window;
    
    CGRect wRect = [button convertRect:button.bounds toView:window];
    
    [self.greyView removeFromSuperview];
    self.greyView = [[UIView alloc] initWithFrame:wRect];
    self.greyView.backgroundColor = [UIColor greenColor];
    
    [window addSubview:self.greyView];
    
    CGPoint windowPoint = [button convertPoint:button.bounds.origin toView:window];
    NSLog(@"rect %@ point %@", NSStringFromCGRect(wRect), NSStringFromCGPoint(windowPoint));
}

- (UIImage *)captureFullScreen {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = appDelegate.window;
    CGRect appBounds = appDelegate.window.bounds;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        // for retina-display
        UIGraphicsBeginImageContextWithOptions(appBounds.size, NO, [UIScreen mainScreen].scale);
        [window drawViewHierarchyInRect:appBounds afterScreenUpdates:NO];
    } else {
        // non-retina-display
        UIGraphicsBeginImageContext(appBounds.size);
        [window drawViewHierarchyInRect:appBounds afterScreenUpdates:NO];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.cardsTableView;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cardItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CardsCell *cell = (CardsCell *) [tableView dequeueReusableCellWithIdentifier:@"CardsCell"];
    
    if (cell == nil) {
        cell = [[CardsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CardsCell"];
        [cell.premiumButton addTarget:self action:@selector(premiumAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.cardNumberLabel.text = [self.cardItems objectAtIndex:indexPath.row];
    cell.cardImage.image = [Helper getImageByImageName:(indexPath.row %2 ? @"visa_card" : @"master_card")];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Helper getValue:54];
}

@end
