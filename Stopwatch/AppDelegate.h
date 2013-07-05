//
//  AppDelegate.h
//  Stopwatch
//
//  Created by Andrew Wu on 9/29/12.
//  Copyright (c) 2012 Andrew Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NSTimeInterval totalElapsedTime;
@property (strong, nonatomic) ViewController *stopwatchViewController;
@property (strong, nonatomic) NSDate *startTime;
@property (nonatomic) NSInteger beepInterval;
@property (strong, nonatomic) NSDate *lastBeepTime;

@end
