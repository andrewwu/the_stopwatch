//
//  Utilities.m
//  Stopwatch
//
//  Created by Andrew Wu on 10/31/12.
//  Copyright (c) 2012 Andrew Wu. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (BOOL)initializeScreenAutoLock
{
    BOOL autoLockScreenValue = NO;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs objectForKey:@"autoLockScreen"] != nil) {
        autoLockScreenValue = [prefs boolForKey:@"autoLockScreen"];
    } else {
        [prefs setBool:autoLockScreenValue forKey:@"autoLockScreen"];
    }

    [[UIApplication sharedApplication] setIdleTimerDisabled:!autoLockScreenValue];
    
    return autoLockScreenValue;
}

@end
