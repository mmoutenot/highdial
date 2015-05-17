//
//  HDOption.m
//  HighDial
//
//  Created by Marshall Moutenot on 4/24/15.
//  Copyright (c) 2015 HighDial. All rights reserved.
//

#import "HDOption.h"

@implementation HDOption

- (instancetype)initWithText:(NSString*)text icon:(UIImage*)icon nextKey:(NSString*)nextKey logString:(NSString*)logString {
  self = [super init];
  if (self) {
    _text = text;
    _icon = icon;
    _nextKey = nextKey;
    _logString = logString;
  }
  return self;
}

@end
