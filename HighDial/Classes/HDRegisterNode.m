//
//  HDRegisterNode.m
//  HighDial
//
//  Created by Marshall Moutenot on 7/22/15.
//  Copyright (c) 2015 HighDial. All rights reserved.
//
#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import <Pop/Pop.h>

#import "HDButton.h"
#import "HDRegisterNode.h"
#import "HDColor.h"

static const CGFloat kHeaderHeight = 60.0;

@interface HDRegisterNode ()

@property ASDisplayNode* headerBackgroundNode;
@property ASTextNode* headerTextNode;

@property ASTextNode* continueTextNode;

@end

@implementation HDRegisterNode

- (instancetype)init {
  self = [super init];
  if (self) {
    UIColor* lightBlue = [UIColor colorWithRed:39/255.0 green:141/255.0 blue:224/255.0 alpha:1.0];
    self.backgroundColor = [HDColor colorBackground];

    self.headerBackgroundNode = [[ASDisplayNode alloc] init];
    self.headerBackgroundNode.backgroundColor = [HDColor colorPrimary];
    [self addSubnode:self.headerBackgroundNode];

    NSDictionary* headerProps = @{
      NSFontAttributeName:[UIFont openSansFontOfSize:16],
      NSForegroundColorAttributeName:[UIColor whiteColor]
    };
    self.headerTextNode = [[ASTextNode alloc] init];
    self.headerTextNode.attributedString = [[NSAttributedString alloc] initWithString:@"Get Started" attributes:headerProps];
    [self addSubnode:self.headerTextNode];

    self.continueButton = [[HDButton alloc] init];
    self.continueButton.backgroundColor = lightBlue;
    [self addSubnode:self.continueButton];

    NSDictionary* continueButtonProps = @{
      NSFontAttributeName:[UIFont openSansFontOfSize:16],
      NSForegroundColorAttributeName:[UIColor whiteColor]
    };
    self.continueTextNode = [[ASTextNode alloc] init];
    self.continueTextNode.attributedString = [[NSAttributedString alloc] initWithString:@"Continue to Salesforce" attributes:continueButtonProps];
    [self addSubnode:self.continueTextNode];
  }
  return self;
}

- (void)didLoad {
  [super didLoad];

  CGSize viewSize = self.view.bounds.size;

  CGFloat yPos = kHeaderHeight + 25.0;
  self.fullNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, yPos, viewSize.width, 45.0)];
  yPos += 50.0;
  self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(0, yPos, viewSize.width, 45.0)];
  yPos += 50.0;
  self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(0, yPos, viewSize.width, 45.0)];

  NSArray* textViews = @[self.fullNameField, self.emailField, self.passwordField];

  for (int i = 0; i < textViews.count; i++) {
    UITextField* tf = textViews[i];
    tf.backgroundColor = [UIColor whiteColor];
    tf.layer.borderColor = [[HDColor colorBlack] colorWithAlphaComponent:0.2].CGColor;

    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    tf.leftView = paddingView;
    tf.leftViewMode = UITextFieldViewModeAlways;

    [self.view addSubview:tf];
  }

  self.fullNameField.placeholder = @"Full Name";

  self.emailField.placeholder = @"Work Email";
  self.emailField.keyboardType = UIKeyboardTypeEmailAddress;

  self.passwordField.placeholder = @"Create Password";
  self.passwordField.secureTextEntry = YES;

  [self loadTextFieldSignals];
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
  [self.headerBackgroundNode measure:constrainedSize];
  [self.headerTextNode measure:constrainedSize];
  
  [self.continueButton measure:constrainedSize];
  [self.continueTextNode measure:constrainedSize];

  return constrainedSize;
}

- (void)layout {
  CGSize viewSize = self.view.bounds.size;
  self.headerBackgroundNode.bounds = CGRectMake(0, 0, viewSize.width, kHeaderHeight);
  self.headerBackgroundNode.position = CGPointMake(viewSize.width / 2.0, 30);

  CGSize headerSize = self.headerTextNode.calculatedSize;
  self.headerTextNode.bounds = CGRectMake(0, 0, headerSize.width, headerSize.height);
  self.headerTextNode.position = CGPointMake(viewSize.width / 2.0, 35);

  CGPoint continueCenter = CGPointMake(viewSize.width / 2.0, self.passwordField.frame.origin.y + 100);
  self.continueButton.bounds = CGRectMake(0, 0, 250, 55);
  self.continueButton.position = continueCenter;

  CGSize continueTextSize = self.continueTextNode.calculatedSize;
  self.continueTextNode.bounds = CGRectMake(0, 0, continueTextSize.width, continueTextSize.height);
  self.continueTextNode.position = continueCenter;
}

- (void)loadTextFieldSignals {
  // validity signals
  RACSignal* validNameSignal = [self.fullNameField.rac_textSignal map:^NSNumber*(NSString* text) {
    return @(isValidName(text));
  }];

  RACSignal* validEmailSignal = [self.emailField.rac_textSignal map:^NSNumber*(NSString* text) {
    return @(isValidPassword(text));
  }];

  RACSignal* validPasswordSignal = [self.passwordField.rac_textSignal map:^NSNumber*(NSString* text) {
    return @(isValidPassword(text));
  }];

  RACSignal* allValidSignal = [[RACSignal combineLatest:@[validNameSignal, validEmailSignal, validPasswordSignal]
    reduce:^id(NSNumber* nameValid, NSNumber* usernameValid, NSNumber* passwordValid) {
      return @(nameValid.boolValue && usernameValid.boolValue && passwordValid.boolValue);
    }]
    distinctUntilChanged];

  RAC(self.fullNameField, backgroundColor) = [validNameSignal map:^UIColor*(NSNumber* valid) {
    CGFloat alpha = valid.boolValue ? 1.0 : 0.5;
    return [self.fullNameField.backgroundColor colorWithAlphaComponent:alpha];
  }];
  RAC(self.emailField, backgroundColor) = [validNameSignal map:^UIColor*(NSNumber* valid) {
    CGFloat alpha = valid.boolValue ? 1.0 : 0.5;
    return [self.fullNameField.backgroundColor colorWithAlphaComponent:alpha];
  }];
  RAC(self.passwordField, backgroundColor) = [validNameSignal map:^UIColor*(NSNumber* valid) {
    CGFloat alpha = valid.boolValue ? 1.0 : 0.5;
    return [self.fullNameField.backgroundColor colorWithAlphaComponent:alpha];
  }];

  RAC(self.continueButton, alpha) = [allValidSignal map:^NSNumber* (NSNumber* valid) {
    return valid.boolValue ? @(1.0) : @(0.5);
  }];

  RAC(self.continueButton, userInteractionEnabled) = [allValidSignal map:^NSNumber* (NSNumber* valid) {
    return valid;
  }];

  [[allValidSignal filter:^BOOL(NSNumber* valid) {
      return valid.boolValue;
    }]
    subscribeNext:^(id _) {
      POPSpringAnimation* scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
      scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.0, 3.0)];
      scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
      scaleAnimation.springBounciness = 18.0f;
      [self.continueButton.layer pop_addAnimation:scaleAnimation forKey:@"doneButtonScaleAnimation"];
    }];
}

BOOL isValidName(NSString* fullName) {
  return !!fullName.length;
}

BOOL isValidEmail(NSString* text) {
  NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
  NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

  return [emailTest evaluateWithObject:text];
}

BOOL isValidPassword(NSString* text) {
  return text.length >= 6;
}

@end
