//
//  AppDelegate.m
//  Stopwatch
//
//  Created by Andrew Wu on 9/29/12.
//  Copyright (c) 2012 Andrew Wu. All rights reserved.
//

#import "AppDelegate.h"
#import "Utilities.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.beepInterval = 0;
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [Utilities backupData];
    
    if (self.stopwatchViewController.timerActive) {
        [self.stopwatchViewController startStopButtonPressed:nil];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        [defaults setObject:[NSDate date] forKey:@"kPauseTime"];
        [defaults setObject:self.startTime forKey:@"kStartTime"];
        [defaults setObject:[NSNumber numberWithDouble:self.totalElapsedTime] forKey:@"kTotalElapsedTime"];
        [defaults synchronize];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSNumber *totalElapsedTime = [defaults objectForKey:@"kTotalElapsedTime"];
    NSDate *pauseTime = [defaults objectForKey:@"kPauseTime"];
    NSDate *startTime = [defaults objectForKey:@"kStartTime"];

    if (pauseTime != nil && totalElapsedTime != nil && startTime != nil) {
        self.startTime = startTime;

        NSTimeInterval backgroundElapsedTime = [[NSDate date] timeIntervalSinceDate:pauseTime];

        self.totalElapsedTime = [totalElapsedTime doubleValue] + backgroundElapsedTime;

        [defaults removeObjectForKey:@"kPauseTime"];
        [defaults removeObjectForKey:@"kTotalElapsedTime"];
        [defaults synchronize];

        [self.stopwatchViewController startStopButtonPressed:nil];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [Utilities initializeScreenAutoLock];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.beepInterval = [[defaults objectForKey:@"kBeepInterval"] integerValue];
    NSLog(@"app became active - restored bp: %i", self.beepInterval);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [Utilities backupData];
}

@end
