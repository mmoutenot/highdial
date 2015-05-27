//
//  CallFlowViewController.m
//  HighDial
//
//  Created by Marshall Moutenot on 3/25/15.
//  Copyright (c) 2015 HighDial. All rights reserved.
//
#import <Pop/Pop.h>

#import "HDCallFlowViewController.h"
#import "HDOptionsCardViewController.h"
#import "HDCallFlowNoteCardViewController.h"
#import "HDCallFlowHeaderView.h"
#import "HDDismissingAnimator.h"
#import "HDFlatButton.h"
#import "HDOption.h"
#import "HDPresentingAnimator.h"
#import "HDSuccessBadgeView.h"
#import "SFRestAPI.h"
#import "SFRestRequest.h"

static CGFloat kCallFlowViewHeaderHeight = 80.0;

static NSString* const reachableCardKey = @"reachable";
static NSString* const callRatingCardKey = @"callRatin";
static NSString* const whoReachedCardKey = @"whoReached";
static NSString* const nextStepsCardKey = @"nextSteps";
static NSString* const whenCardKey = @"when";
static NSString* const notesCardKey = @"notes";

@interface HDCallFlowViewController () <SFRestDelegate, UIViewControllerTransitioningDelegate, HDCardHandlerDelegate>

@property (nonatomic) NSMutableDictionary* callData;
@property (nonatomic) UILabel* durationLabel;
@property (nonatomic) HDFlatButton* logButton;
@property (nonatomic) NSMutableDictionary* flowCards;
@property (nonatomic) NSMutableDictionary* selectedOptions;
@property (nonatomic) HDCallFlowHeaderView* headerView;
@property (nonatomic) HDSuccessBadgeView* successView;
@property (nonatomic) HDCardViewController* currentCard;

@end

@implementation HDCallFlowViewController

- (instancetype) initWithCallData:(NSDictionary*)callData {
  self = [super init];
  if (self) {
    _callData = [callData mutableCopy];
    _selectedOptions = [NSMutableDictionary dictionary];
    NSString* contactName = self.callData[@"contact"][@"Name"];
    
    self.flowCards = [NSMutableDictionary dictionary];
    NSDictionary* reachableCard = @{
      @"header": [NSString stringWithFormat:@"Did you talk with %@?", contactName],
      @"options": @[
        [[HDOption alloc] initWithText:@"Yes" icon:[UIImage imageNamed:@"ContactIcon"] nextKey:callRatingCardKey logString:@"Connected"],
        [[HDOption alloc] initWithText:@"No" icon:[UIImage imageNamed:@"NoIcon"] nextKey:whoReachedCardKey logString:@"Not Reached"]
      ]
    };
    [self.flowCards setObject:reachableCard forKey:reachableCardKey];
    
    NSDictionary* whoReachedCard = @{
      @"header": @"Who did you reach?",
      @"options": @[
        [[HDOption alloc] initWithText:@"Voicemail" icon:[UIImage imageNamed:@"VoicemailIcon"] nextKey:nextStepsCardKey logString:@"Left Voicemail"],
        [[HDOption alloc] initWithText:@"Gatekeeper" icon:[UIImage imageNamed:@"GatekeeperIcon"] nextKey:nextStepsCardKey logString:@"Reached Gatekeeper"],
        [[HDOption alloc] initWithText:@"Nobody" icon:[UIImage imageNamed:@"NegativeIcon"] nextKey:nextStepsCardKey logString:@"No Contact"]
      ]
    };
    [self.flowCards setObject:whoReachedCard forKey:whoReachedCardKey];
    
    NSDictionary* callRatingCard = @{
      @"header": @"How would you rate the call?",
      @"options": @[
        [[HDOption alloc] initWithText:@"Great" icon:[UIImage imageNamed:@"GreatIcon"] nextKey:nextStepsCardKey logString:@"4/4"],
        [[HDOption alloc] initWithText:@"Good" icon:[UIImage imageNamed:@"GoodIcon"] nextKey:nextStepsCardKey logString:@"3/4"],
        [[HDOption alloc] initWithText:@"Okay" icon:[UIImage imageNamed:@"OkayIcon"] nextKey:nextStepsCardKey logString:@"2/4"],
        [[HDOption alloc] initWithText:@"Bad" icon:[UIImage imageNamed:@"NotGoodIcon"] nextKey:nextStepsCardKey logString:@"1/4"]
      ]
    };
    [self.flowCards setObject:callRatingCard forKey:callRatingCardKey];
    
    NSDictionary* nextStepsCard = @{
      @"header": @"Next steps?",
      @"options": @[
        [[HDOption alloc] initWithText:@"Call back" icon:[UIImage imageNamed:@"CallIcon"] nextKey:whenCardKey logString:@"phone"],
        [[HDOption alloc] initWithText:@"Email" icon:[UIImage imageNamed:@"EmailIcon"] nextKey:whenCardKey logString:@"email"],
        [[HDOption alloc] initWithText:@"None" icon:[UIImage imageNamed:@"NegativeIcon"] nextKey:notesCardKey logString:@"none"]
      ]
    };
    [self.flowCards setObject:nextStepsCard forKey:nextStepsCardKey];
    
    NSDictionary* whenCard = @{
      @"header": @"When?",
      @"options": @[
        [[HDOption alloc] initWithText:@"Today" icon:[UIImage imageNamed:@"TodayIcon"] nextKey:notesCardKey logString:@"later today"],
        [[HDOption alloc] initWithText:@"Tomorrow" icon:[UIImage imageNamed:@"TomorrowIcon"] nextKey:notesCardKey logString:@"tomorrow"],
        [[HDOption alloc] initWithText:@"Next week" icon:[UIImage imageNamed:@"WeekIcon"] nextKey:notesCardKey logString:@"next week"],
        [[HDOption alloc] initWithText:@"Next month" icon:[UIImage imageNamed:@"MonthIcon"] nextKey:notesCardKey logString:@"next month"]
      ]
    };
    [self.flowCards setObject:whenCard forKey:whenCardKey];
    
    NSDictionary* notesCard = @{
      @"header": @"Add notes:"
    };
    [self.flowCards setObject:notesCard forKey:notesCardKey];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [HDColor colorBackground];
  
  CGSize viewSize = self.view.frame.size;
  
  CGRect headerFrame = { 0, 0, viewSize.width, kCallFlowViewHeaderHeight };
  self.headerView = [[HDCallFlowHeaderView alloc] initWithFrame:headerFrame callDuration:self.callData[@"durationString"]];
  [self.view addSubview:self.headerView];
  [self.headerView.cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
  [self.headerView.doneButton addTarget:self action:@selector(logCall) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated {
  [self presentCardForKey:@"reachable"];
}

- (void)present:(UIViewController*)viewController {
  [self addChildViewController:viewController];
  [self.view addSubview:viewController.view];
  [viewController didMoveToParentViewController:self];
}

- (void)presentCardForKey:(NSString *)cardKey {
  CGSize viewSize = self.view.frame.size;
  CGRect cardFrame = { 5.0, kCallFlowViewHeaderHeight + 5.0, viewSize.width - 10.0, viewSize.height - 10.0 - kCallFlowViewHeaderHeight };
  NSDictionary* card = self.flowCards[cardKey];
  HDCardViewController* currentCard;
  if ([cardKey isEqualToString:notesCardKey]) {
    currentCard = [[HDCallFlowNoteCardViewController alloc] initWithFrame:cardFrame key:cardKey title:card[@"header"] delegate:self];
    self.headerView.doneButton.hidden = NO;
  } else {
    currentCard = [[HDOptionsCardViewController alloc] initWithFrame:cardFrame key:cardKey title:card[@"header"] options:card[@"options"] delegate:self];
    self.headerView.doneButton.hidden = YES;
  }
  self.currentCard = currentCard;
  [self present:currentCard];
}

- (void)showSuccess {
  POPSpringAnimation* springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
	springAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.8, 0.8)];
	springAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
  springAnimation.springBounciness = 18.0;
  
  self.successView = [[HDSuccessBadgeView alloc] initWithFrame:self.view.frame];
  [self.view addSubview:self.successView];
  
  [self.successView.layer pop_addAnimation:springAnimation forKey:@"successSpring"];
}

- (void)dismiss {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)optionSelected:(HDOption*)option forKey:(NSString*)key {
  NSLog(@"%@ %@", key, option.logString);
  self.callData[key] = option.logString;
  
  [self presentCardForKey:option.nextKey];
}

- (void)notesAdded:(NSString*)notes {
  self.callData[notesCardKey] = notes;
}

- (void)logCall{
  [self.currentCard blur];
  [self showSuccess];
  
  NSDictionary* contactData = self.callData[@"contact"];
  NSString* subject = [NSString stringWithFormat:@"Call - %@", self.callData[reachableCardKey]];
  NSString* rating = [NSString stringWithFormat:@"Rating: %@", self.callData[callRatingCardKey]];
  NSString* followUp = @"No follow up needed.";
  NSString* duration = [NSString stringWithFormat:@"Duration: %@", self.callData[@"durationString"]];
  NSString* notes = [NSString stringWithFormat:@"Notes: %@", self.callData[notesCardKey]];
  if (![self.callData[nextStepsCardKey] isEqualToString:@"none"]) {
    followUp = [NSString stringWithFormat:@"Follow up via %@ %@", self.callData[nextStepsCardKey], self.callData[whenCardKey]];
  }
  
  NSDictionary* taskParams = @{
    @"WhoId": contactData[@"Id"],
    @"Subject": subject,
    @"Status": @"Completed",
    @"CallDurationInSeconds": self.callData[@"duration"],
    @"Description": [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@\n\n--\nLogged with Highdial", rating, followUp, duration, notes]
  };
  
  SFRestRequest* request = [[SFRestAPI sharedInstance] requestForCreateWithObjectType:@"Task" fields:taskParams];
  
  [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest*)request didLoadResponse:(id)jsonResponse {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self dismiss];
  });
}

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
  NSLog(@"request:didFailLoadWithError: %@", error);
  //add your failed error handling here
}

- (void)requestDidCancelLoad:(SFRestRequest*)request {
  NSLog(@"requestDidCancelLoad: %@", request);
  //add your failed error handling here
}

- (void)requestDidTimeout:(SFRestRequest*)request {
  NSLog(@"requestDidTimeout: %@", request);
  //add your failed error handling here
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning> )animationControllerForPresentedController:(UIViewController*)presented
                                                                    presentingController:(UIViewController*)presenting
                                                                        sourceController:(UIViewController*)source {
  return [[HDPresentingAnimator alloc] init];
}

- (id <UIViewControllerAnimatedTransitioning> )animationControllerForDismissedController:(UIViewController*)dismissed {
  return [[HDDismissingAnimator alloc] init];
}


@end
