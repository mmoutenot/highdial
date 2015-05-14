//
//  HDColors.h
//  HighDial
//
//  Created by Marshall Moutenot on 5/13/15.
//  Copyright (c) 2015 HighDial. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorUtilities)

- (UIColor*)darken:(CGFloat)amount;
- (UIColor*)lighten:(CGFloat)amount;

@end

@interface HDColor : UIColor

+ (HDColor*)colorClear;
+ (HDColor*)colorBlack;
+ (HDColor*)colorWhite;

+ (HDColor*)colorText;
+ (HDColor*)colorPrimary;
+ (HDColor*)colorSecondary;
+ (HDColor*)colorBackground;

+ (HDColor*)colorGreen;
+ (HDColor*)colorOrange;
+ (HDColor*)colorRed;
+ (HDColor*)colorYellow;

@end