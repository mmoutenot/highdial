//
//  HDColors.m
//  HighDial
//
//  Created by Marshall Moutenot on 5/13/15.
//  Copyright (c) 2015 HighDial. All rights reserved.
//

#import "HDColor.h"

@implementation UIColor (ColorUtilities)

// Color Utilities
- (UIColor*)darken:(CGFloat)amount {
  CGFloat r, g, b, a;
  if ([self getRed:&r green:&g blue:&b alpha:&a]) {
    return [UIColor colorWithRed:MAX(r - amount, 0.0) green:MAX(g - amount, 0.0) blue:MAX(b - amount, 0.0) alpha:a];
  }
  return nil;
}

- (UIColor*)lighten:(CGFloat)amount {
  CGFloat r, g, b, a;
  if ([self getRed:&r green:&g blue:&b alpha:&a]) {
    return [UIColor colorWithRed:MIN(r + amount, 1.0) green:MIN(g + amount, 1.0) blue:MIN(b + amount, 1.0) alpha:a];
  }
  return nil;
}

@end

@implementation HDColor

+ (HDColor*)colorFromHex:(UInt64)rgbValue {
  return (HDColor*)[[UIColor alloc] initWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                                 green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                                  blue:((float)(rgbValue & 0xFF))/255.0
                                 alpha:1.0];
}

+ (HDColor*)colorClear {
  return (HDColor*)[self clearColor];
}

+ (HDColor*)colorBlack {
  return (HDColor*)[self blackColor];
}

+ (HDColor*)colorWhite {
  return (HDColor*)[self whiteColor];
}

+ (HDColor*)colorText {
  return [self colorFromHex:0x424242];
}

+ (HDColor*)colorPrimary {
  return [self colorFromHex:0x278DE0];
}

+ (HDColor*)colorSecondary {
  return [self colorFromHex:0xBDC4CB];
}

+ (HDColor*)colorBackground {
  return [self colorFromHex:0xF1F1F2];
}

+ (HDColor*)colorGreen {
  return [self colorFromHex:0x81CF2D];
}

+ (HDColor*)colorOrange {
  return [self colorFromHex:0xF2AF33];
}

+ (HDColor*)colorRed {
  return [self colorFromHex:0xE5453F];
}

+ (HDColor*)colorYellow {
  return [self colorFromHex:0xF2E53E];
}

@end