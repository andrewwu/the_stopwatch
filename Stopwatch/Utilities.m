//
//  Utilities.m
//  Stopwatch
//
//  Created by Andrew Wu on 10/31/12.
//  Copyright (c) 2012 Andrew Wu. All rights reserved.
//

#import "Utilities.h"
#import "AppDelegate.h"

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

+ (void)setImage:(NSString *)imageName AndHighlightImage:(NSString *)highlightImageName forButton:(UIButton *)button {
    UIImage *buttonImage = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:highlightImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
}

+ (void)formatLabel:(UILabel *)label withTimeInterval:(NSTimeInterval)timeInterval {
    NSDate *temp = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (timeInterval >= 3600) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    NSString *str = [formatter stringFromDate:temp];
    label.text = str;
}

+ (void)backupData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    [defaults setObject:[NSNumber numberWithInteger:appDelegate.beepInterval] forKey:@"kBeepInterval"];

    NSLog(@"app became entered bkg - storing bp: %i", appDelegate.beepInterval);    
}

@end
