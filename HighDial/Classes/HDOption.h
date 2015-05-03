//
//  HDOption.h
//  HighDial
//
//  Created by Marshall Moutenot on 4/24/15.
//  Copyright (c) 2015 HighDial. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDOption : NSObject

@property (nonatomic, readonly) NSString* text;
@property (nonatomic, readonly) UIImage* icon;
@property (nonatomic, readonly) NSString* nextKey;

- (instancetype)initWithText:(NSString*)text icon:(UIImage*)icon nextKey:(NSString*)nextKey;

@end
