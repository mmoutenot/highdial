//
//  CallFlowViewController.m
//  HighDial
//
//  Created by Marshall Moutenot on 3/25/15.
//  Copyright (c) 2015 HighDial. All rights reserved.
//

#import "HDCallFlowViewController.h"
#import "HDCallFlowCardViewController.h"
#import "HDCallFlowHeaderView.h"
#import "HDDismissingAnimator.h"
#import "HDFlatButton.h"
#import "HDOption.h"
#import "HDPresentingAnimator.h"
#import "SFRestAPI.h"
#import "SFRestRequest.h"

static CGFloat kCallFlowViewHeaderHeight = 80.0;

@interface HDCallFlowViewController () <SFRestDelegate, UIViewControllerTransitioningDelegate, HDCardHandlerDelegate>

@property (nonatomic) NSDictionary* callData;
@property (nonatomic) UILabel* durationLabel;
@property (nonatomic) HDFlatButton* logButton;
@property (nonatomic) NSMutableDictionary* flowCards;
@property (nonatomic) NSMutableDictionary* selectedOptions;

@end

@implementation HDCallFlowViewController

- (instancetype) initWithCallData:(NSDictionary*)callData {
  self = [super init];
  if (self) {
    _callData = callData;
    _selectedOptions = [NSMutableDictionary dictionary];
    NSString* contactName = self.callData[@"contact"][@"Name"];
    
    self.flowCards = [NSMutableDictionary dictionary];
    NSDictionary* reachableCard = @{
      @"header": [NSString stringWithFormat:@"Did you talk with %@?", contactName],
      @"options": @[
        [[HDOption alloc] initWithText:@"Yes" icon:[UIImage imageNamed:@"ContactIcon"] nextKey:@"callRating"],
        [[HDOption alloc] initWithText:@"No" icon:[UIImage imageNamed:@"NoIcon"] nextKey:@"whoReached"]
      ]
    };
    [self.flowCards setObject:reachableCard forKey:@"reachable"];
    
    NSDictionary* whoReachedCard = @{
      @"header": @"Who did you reach?",
      @"options": @[
        [[HDOption alloc] initWithText:@"Voicemail" icon:[UIImage imageNamed:@"VoicemailIcon"] nextKey:@"nextSteps"],
        [[HDOption alloc] initWithText:@"Gatekeeper" icon:[UIImage imageNamed:@"GatekeeperIcon"] nextKey:@"nextSteps"],
        [[HDOption alloc] initWithText:@"Nobody" icon:[UIImage imageNamed:@"NegativeIcon"] nextKey:@"nextSteps"]
      ]
    };
    [self.flowCards setObject:whoReachedCard forKey:@"whoReached"];
    
    NSDictionary* callRatingCard = @{
      @"header": @"How would you rate the call?",
      @"options": @[
        [[HDOption alloc] initWithText:@"Great" icon:[UIImage imageNamed:@"GreatIcon"] nextKey:@"nextSteps"],
        [[HDOption alloc] initWithText:@"Good" icon:[UIImage imageNamed:@"GoodIcon"] nextKey:@"nextSteps"],
        [[HDOption alloc] initWithText:@"Okay" icon:[UIImage imageNamed:@"OkayIcon"] nextKey:@"nextSteps"],
        [[HDOption alloc] initWithText:@"Bad" icon:[UIImage imageNamed:@"BadIcon"] nextKey:@"nextSteps"]
      ]
    };
    [self.flowCards setObject:callRatingCard forKey:@"callRating"];
    
    NSDictionary* nextStepsCard = @{
      @"header": @"Next steps?",
      @"options": @[
        [[HDOption alloc] initWithText:@"Call back" icon:[UIImage imageNamed:@"CallIcon"] nextKey:@"when"],
        [[HDOption alloc] initWithText:@"Email" icon:[UIImage imageNamed:@"EmailIcon"] nextKey:@"when"],
        [[HDOption alloc] initWithText:@"None" icon:[UIImage imageNamed:@"NegativeIcon"] nextKey:@"notes"]
      ]
    };
    [self.flowCards setObject:nextStepsCard forKey:@"nextSteps"];
    
    NSDictionary* whenCard = @{
      @"header": @"When?",
      @"options": @[
        [[HDOption alloc] initWithText:@"Today" icon:[UIImage imageNamed:@"TodayIcon"] nextKey:@"notes"],
        [[HDOption alloc] initWithText:@"Tomorrow" icon:[UIImage imageNamed:@"TomorrowIcon"] nextKey:@"notes"],
        [[HDOption alloc] initWithText:@"Next week" icon:[UIImage imageNamed:@"WeekIcon"] nextKey:@"notes"],
        [[HDOption alloc] initWithText:@"Next month" icon:[UIImage imageNamed:@"MonthIcon"] nextKey:@"notes"],
        [[HDOption alloc] initWithText:@"Pick a date" icon:[UIImage imageNamed:@"NegativeIcon"] nextKey:@"notes"]
      ]
    };
    [self.flowCards setObject:whenCard forKey:@"when"];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor lightGrayColor];
  
  CGSize viewSize = self.view.frame.size;
  
  CGRect headerFrame = { 0, 0, viewSize.width, kCallFlowViewHeaderHeight };
  HDCallFlowHeaderView* headerView = [[HDCallFlowHeaderView alloc] initWithFrame:headerFrame callDuration:self.callData[@"duration"]];
  [self.view addSubview:headerView];
}

- (void)viewDidAppear:(BOOL)animated {
  [self presentCardForKey:@"reachable"];
}

- (void)present:(UIViewController*)viewController {
  viewController.transitioningDelegate = self;
  viewController.modalPresentationStyle = UIModalPresentationCustom;

  [self presentViewController:viewController animated:YES completion:nil];
}

- (void)presentCardForKey:(NSString *)cardKey {
  CGSize viewSize = self.view.frame.size;
  CGRect cardFrame = { viewSize.width * 0.025, viewSize.height * 0.25, viewSize.width * .95, viewSize.height * 0.5 };
  NSDictionary* card = self.flowCards[cardKey];
  HDCallFlowCardViewController* currentCard = [[HDCallFlowCardViewController alloc] initWithFrame:cardFrame key:cardKey title:card[@"header"] options:card[@"options"] delegate:self];
  [self present:currentCard];
}

- (void)dismiss {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)optionSelected:(HDOption*)option forKey:(NSString*)key {
  if ([key isEqualToString:@"reachable"]) {
  } else if ([key isEqualToString:@"whoReached"]) {
  } else if ([key isEqualToString:@"callRating"]) {
  } else if ([key isEqualToString:@"nextSteps"]) {
  } else if ([key isEqualToString:@"when"]) {
  }
  
  [self dismiss];
  
  if ([option.nextKey isEqualToString:@"notes"]) {
    [self dismiss];
  } else {
    [self presentCardForKey:option.nextKey];
  }
}

- (void)logCall{
  NSDictionary* contactData = self.callData[@"contact"];
  NSDictionary* taskParams = @{
    @"WhoId": contactData[@"Id"],
    @"Subject": @"Call with HighDial",
    @"CallDurationInSeconds": self.callData[@"duration"],
    @"CallDisposition": @"Did not reach him"
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
  NSArray* records = [jsonResponse objectForKey:@"records"];
  NSLog(@"request:didLoadResponse: #records: %lu", (unsigned long)records.count);
  NSLog(@"%@",records);
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
