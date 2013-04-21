//
//  MainViewController.m
//  MarsWeatherReport
//
//  Created by Leilani Montas on 4/15/13.
//  Copyright (c) 2013 Leilani Montas. All rights reserved.
//

#import "MainViewController.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import <QuartzCore/QuartzCore.h>
#import "Weather.h"
#import "Trivium.h"
#import "DBAccess.h"
#import "Twitter.h"
#import "AppDelegate.h"
#import "NSArray+Random.h"
#define kMarsTwitterHandle @"MarsWxReport"



@interface MainViewController ()
@property(nonatomic,strong)NSArray *tweets;
@end

@implementation MainViewController
NSArray *categories;
Weather *weather;

BOOL shown=NO;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)didFinishParsingWeather:(NSNotification *)notification{
    NSDictionary *userInfo=notification.userInfo;
     weather=[userInfo objectForKey:kWeatherKey];
    
    _lblSunrise.text=weather.sunrise;
    _lblSunset.text=weather.sunset;
    _lblTemperature.text=[NSString stringWithFormat:@"%2.f °C - %2.f °C",weather.minTemp,weather.maxTemp];
    _lblPressure.text=[NSString stringWithFormat:@"%2.f Pa",weather.pressure];
    _lblHumidity.text=(weather.humidity!=0)?[NSString stringWithFormat:@"%2.f %%",weather.humidity]:@"--";
    _lblWindSpeed.text=[NSString stringWithFormat:@"%2.f m/s",weather.windSpeed];
    _lblWindDirection.text=weather.windDirection;
    _lblDate.text=weather.terrestialDate;
    
}
-(void)didFetchTwitterTimeline:(NSNotification *)notification{
    NSDictionary *userInfo=notification.userInfo;
    _tweets=[userInfo objectForKey:@"tweets"];
    NSLog(@"refresh tweets %d",_tweets.count);
    
    [_tweetsTable reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.triviumView.layer.cornerRadius=5.0;
    self.triviumView.layer.masksToBounds=YES;
    categories=[[NSArray alloc] initWithObjects:
                @"Temperature",
                @"Pressure",
                @"Humidity",
                @"Wind Speed",
                @"General",
                nil];
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishParsingWeather:) name:kNotificationWeatherParsed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFetchTwitterTimeline:) name:kNotificationFetchedTwitterTimeline object:nil];


}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationWeatherParsed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationFetchedTwitterTimeline object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidUnload {
    [self setImgOutlook:nil];
    [self setLblSunrise:nil];
    [self setLblSunset:nil];
    [self setLblPressure:nil];
    [self setLblHumidity:nil];
    [self setLblWindSpeed:nil];
    [self setLblWindDirection:nil];
    [self setLblDate:nil];
    [self setTweetsTable:nil];
    [self setLblTemperature:nil];
    [self setTriviumView:nil];
    [self setTriviumTextView:nil];
    [super viewDidUnload];
}




#pragma mark UITableViewDelegate Methods
#pragma maek UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tweets.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    NSDictionary *tweet=[_tweets objectAtIndex:indexPath.row];
    
    UITextView *lblTweet=(UITextView *)[[cell contentView] viewWithTag:1];
    UILabel *lblDate=(UILabel *)[[cell contentView]viewWithTag:2];
    lblTweet.text=[tweet objectForKey:@"text"];
    lblDate.text=[tweet objectForKey:@"created_at"];
    return cell;
    
}

#pragma mark UITableViewDelegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (IBAction)showTrivia:(UIButton *)sender {
    if (!shown) {
        Trivium *triv=[self getTrivia];
         
        [UIView animateWithDuration:2 animations:^{
            self.triviumView.alpha=.5;
            self.triviumTextView.text=triv.trivium;
            self.triviumView.hidden=NO;
            self.triviumView.alpha=1.0;
        }];
        
        shown=YES;
        [self performSelector:@selector(hideTrivium) withObject:nil afterDelay:5.0];
    }
    else{
        [self hideTrivium];
    }
}
-(void)hideTrivium{
   [UIView animateWithDuration:3 animations:^{
       self.triviumView.alpha=0.5;
       self.triviumView.hidden=YES;
       
   }];
    shown=NO;
}
-(Trivium *)getTrivia{
    NSString *category=[self getRandomCategory];
    double value=0;
    if ([category isEqualToString:@"Temperature"]) {
        NSArray *tempValues=[NSArray arrayWithObjects:
                             [NSNumber numberWithDouble:weather.minTemp],
                             [NSNumber numberWithDouble:weather.maxTemp],
                             nil];
        value=[[tempValues randomObject] doubleValue];
    }
    else if([category isEqualToString:@"Pressure"]){
        value=weather.pressure;
    }
    else if([category isEqualToString:@"Humidity"]){
        value=weather.humidity;
    }
    else if([category isEqualToString:@"Wind Speed"]){
        value=weather.windSpeed;
    }
    Trivium *trivium=[Trivium getTriviumForCategory:category value:value];
    if (trivium==nil) {
        trivium=[Trivium getRandomGeneralTrivium];
    }
    
    return trivium;
    
}

- (IBAction)refresh:(UIButton *)sender {
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(fetchData)];
}

-(NSString *)getRandomCategory{
    return [categories randomObject];

}
-(void)fetchTimelineForUser:(NSString *)username{
    ACAccountStore *store=[[ACAccountStore alloc] init];
    ACAccountType *twitterType=[store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [store requestAccessToAccountsWithType:twitterType withCompletionHandler:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *twitterAccounts=[store accountsWithAccountType:twitterType];
            if (twitterAccounts!=nil&&twitterAccounts.count>0) {
                ACAccount *account=[twitterAccounts objectAtIndex:0];
                
                NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
                [params setValue:username forKey:@"screen_name"];
                [params setValue:@"10" forKey:@"count"];
                TWRequest *request=[[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"] parameters:params requestMethod:TWRequestMethodGET];
                [request setAccount:account];
                
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if (responseData!=nil) {
                        
                        _tweets=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
                        
                        [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
                    }
                    
                }];
            }
            else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Twitter" message:@"There is no twitter account registered on your phone. Please go to settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
            }
        }
    }];
    
    
    
    
}



@end
