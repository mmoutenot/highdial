//
//  HDRegisterNode.m
//  HighDial
//
//  Created by Marshall Moutenot on 7/22/15.
//  Copyright (c) 2015 HighDial. All rights reserved.
//
#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import "HDRegisterNode.h"
#import "HDColor.h"

@interface HDRegisterNode ()

@property ASDisplayNode* headerBackgroundNode;
@property ASTextNode* headerTextNode;

@property UITextField* fullNameField;
@property UITextField* emailField;
@property UITextField* passwordField;

@end

@implementation HDRegisterNode

- (instancetype)init {
  self = [super init];
  if (self) {
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
  }
  return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
  [self.headerBackgroundNode measure:constrainedSize];
  [self.headerTextNode measure:constrainedSize];
  return constrainedSize;
}

- (void)layout {
  CGSize viewSize = self.view.bounds.size;
  self.headerBackgroundNode.bounds = CGRectMake(0, 0, viewSize.width, 60);
  self.headerBackgroundNode.position = CGPointMake(viewSize.width / 2.0, 30);

  CGSize headerSize = self.headerTextNode.calculatedSize;
  self.headerTextNode.bounds = CGRectMake(0, 0, headerSize.width, headerSize.height);
  self.headerTextNode.position = CGPointMake(viewSize.width / 2.0, 35);
}

@end
