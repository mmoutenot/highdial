//
//  HDSplashNode.m
//  HighDial
//
//  Created by Marshall Moutenot on 7/21/15.
//  Copyright (c) 2015 HighDial. All rights reserved.
//
#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import <Pop/Pop.h>

#import "HDSplashNode.h"

@interface HDSplashNode ()

@property ASImageNode* backgroundImageNode;
@property ASDisplayNode* backgroundOverlayNode;

@property ASImageNode* splashLogo;
@property ASTextNode* subtitleNode;

@property ASTextNode* continueTextNode;

@end

@implementation HDSplashNode

- (instancetype)init {
  self = [super init];
  if (self) {
    UIColor* lightBlue = [UIColor colorWithRed:39/255.0 green:141/255.0 blue:224/255.0 alpha:1.0];
    self.backgroundColor = lightBlue;

    self.backgroundImageNode = [[ASImageNode alloc] init];
    self.backgroundImageNode.image = [UIImage imageNamed:@"SplashBackground"];
    [self addSubnode:self.backgroundImageNode];

    self.backgroundOverlayNode = [[ASDisplayNode alloc] init];
    self.backgroundOverlayNode.backgroundColor = [lightBlue colorWithAlphaComponent:0.6];
    self.backgroundOverlayNode.opaque = NO;
    [self addSubnode:self.backgroundOverlayNode];

    self.splashLogo = [[ASImageNode alloc] init];
    self.splashLogo.image = [UIImage imageNamed:@"SplashLogo"];
    self.splashLogo.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubnode:self.splashLogo];

    NSMutableParagraphStyle* paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary* subtitleProps = @{
      NSFontAttributeName:[UIFont openSansFontOfSize:16],
      NSForegroundColorAttributeName:[UIColor whiteColor],
      NSParagraphStyleAttributeName: paragraphStyle
    };
    self.subtitleNode = [[ASTextNode alloc] init];
    self.subtitleNode.attributedString = [[NSAttributedString alloc] initWithString:@"Highdial connects with Salesforce to let you make and log calls effortlessly." attributes:subtitleProps];
    [self addSubnode:self.subtitleNode];

    self.continueButton = [[HDButton alloc] init];
    self.continueButton.backgroundColor = [UIColor whiteColor];
    [self addSubnode:self.continueButton];

    NSDictionary* continueButtonProps = @{
      NSFontAttributeName:[UIFont openSansFontOfSize:16],
      NSForegroundColorAttributeName:lightBlue
    };
    self.continueTextNode = [[ASTextNode alloc] init];
    self.continueTextNode.attributedString = [[NSAttributedString alloc] initWithString:@"Sign up with Salesforce" attributes:continueButtonProps];
    [self addSubnode:self.continueTextNode];
  }
  return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
  [self.backgroundImageNode measure:constrainedSize];
  [self.backgroundOverlayNode measure:constrainedSize];

  [self.splashLogo measure:constrainedSize];
  [self.subtitleNode measure:CGSizeMake(constrainedSize.width * 0.9, constrainedSize.height)];

  [self.continueButton measure:constrainedSize];
  [self.continueTextNode measure:constrainedSize];

  return constrainedSize;
}

- (void)layout {
  CGSize viewSize = self.view.bounds.size;

  self.backgroundImageNode.bounds = self.view.bounds;
  self.backgroundImageNode.position = CGPointMake(viewSize.width / 2.0, viewSize.height / 2.0);

  self.backgroundOverlayNode.bounds = self.backgroundImageNode.bounds;
  self.backgroundOverlayNode.position = self.backgroundImageNode.position;

  self.splashLogo.bounds = CGRectMake(0, 0, 250, 185);;
  self.splashLogo.position = CGPointMake(viewSize.width / 2.0, 150);

  CGSize subtitleSize = self.subtitleNode.calculatedSize;
  self.subtitleNode.bounds = CGRectMake(0, 0, subtitleSize.width, subtitleSize.height);
  self.subtitleNode.position = CGPointMake(viewSize.width / 2.0, 300 - subtitleSize.height / 2.0);

  CGPoint continueCenter = CGPointMake(viewSize.width / 2.0, viewSize.height - 140);
  self.continueButton.bounds = CGRectMake(0, 0, 250, 55);
  self.continueButton.position = continueCenter;

  CGSize continueTextSize = self.continueTextNode.calculatedSize;
  self.continueTextNode.bounds = CGRectMake(0, 0, continueTextSize.width, continueTextSize.height);
  self.continueTextNode.position = continueCenter;
}


@end
