//
//  MainViewController.h
//  MarsWeatherReport
//
//  Created by Leilani Montas on 4/15/13.
//  Copyright (c) 2013 Leilani Montas. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MainViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imgOutlook;
@property (strong, nonatomic) IBOutlet UILabel *lblSunrise;
@property (strong, nonatomic) IBOutlet UILabel *lblSunset;
@property (strong, nonatomic) IBOutlet UILabel *lblTemperature;
@property (strong, nonatomic) IBOutlet UILabel *lblPressure;
@property (strong, nonatomic) IBOutlet UILabel *lblHumidity;
@property (strong, nonatomic) IBOutlet UILabel *lblWindSpeed;
@property (strong, nonatomic) IBOutlet UILabel *lblWindDirection;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UITableView *tweetsTable;
- (IBAction)showTrivia:(UIButton *)sender;
- (IBAction)refresh:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIView *triviumView;
@property (strong, nonatomic) IBOutlet UITextView *triviumTextView;

@end
