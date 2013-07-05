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
    self.lastBeepTime = nil;
    
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
        [defaults setObject:self.lastBeepTime forKey:@"kLastBeepTime"];
        [defaults synchronize];

        NSDate *initialFireDate = self.lastBeepTime;
        
        if (self.beepInterval > 0) {
            if (self.lastBeepTime == nil) {
                initialFireDate = [[NSDate date] dateByAddingTimeInterval:((self.beepInterval * 60) - self.totalElapsedTime)];
            } else {
                while ([initialFireDate compare:[NSDate date]] == NSOrderedAscending) {
                    initialFireDate = [initialFireDate dateByAddingTimeInterval:(self.beepInterval * 60)];
                }
            }
            
            [self scheduleBeepIntervalLocalNotificationWithStartDate:initialFireDate];
        }
    }
}

- (void)scheduleBeepIntervalLocalNotificationWithStartDate:(NSDate*)startDate {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UILocalNotification *localNotif = nil;
    
    // TODO: move this to constants file

    NSInteger numberOfNotifications = 64;
    
    for (int i = 0; i <= numberOfNotifications; i++) {
        localNotif = [[UILocalNotification alloc] init];
        
        if (localNotif) {
            NSTimeInterval beepInterval = self.beepInterval * 60;
            
            NSDate *fireDate = [startDate dateByAddingTimeInterval:beepInterval * i];
            
            localNotif.fireDate = fireDate;
            localNotif.timeZone = [NSTimeZone defaultTimeZone];
            localNotif.soundName = @"dingling.mp3";
            
            if (i == numberOfNotifications) {
                localNotif.alertAction = @"I'm here";
                localNotif.alertBody = @"Action is required to continue beep intervals.";
            }
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        }
    }
    
    [defaults synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
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
    self.lastBeepTime = [defaults objectForKey:@"kLastBeepTime"];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [Utilities backupData];
}

@end
