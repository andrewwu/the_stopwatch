//
//  ViewController.m
//  Stopwatch
//
//  Created by Andrew Wu on 9/29/12.
//  Copyright (c) 2012 Andrew Wu. All rights reserved.
//

#import "ViewController.h"
#import "Utilities.h"
#import "AppDelegate.h"

#define SECONDS_PER_DAY 86400

@interface ViewController () {
    NSTimer *timer;
    AppDelegate* appDelegate;
}

- (void)updateStopwatchLabel;
- (void)updateStopwatchLabelWithInterval:(NSTimeInterval)elapsedTime;
- (void)showStartButton;
- (void)showStopButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.stopwatchViewController = self;

    self.timerActive = false;
    appDelegate.totalElapsedTime = 0;
    
    [Utilities setImage:@"blueButton.png" AndHighlightImage:@"blueButtonHighlight.png" forButton:self.resetButton];
    [Utilities setImage:@"greenButton.png" AndHighlightImage:@"greenButtonHightlight.png" forButton:self.startStopButton];
    
    self.stopwatchLabel.text = @"00:00:0";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startStopButtonPressed:(id)sender {
    if (!self.timerActive) {
        [self showStopButton];
        appDelegate.startTime = [NSDate date];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0 target:self selector:@selector(updateStopwatchLabel) userInfo:nil repeats:YES];
    } else {
        [self showStartButton];
        [timer invalidate];
        appDelegate.totalElapsedTime += [[NSDate date] timeIntervalSinceDate:appDelegate.startTime];
    }
}

- (void)showStartButton {
    self.timerActive = NO;
    [Utilities setImage:@"greenButton.png" AndHighlightImage:@"greenButtonHightlight.png" forButton:self.startStopButton];
    [self.startStopButton setTitle: @"Start" forState: UIControlStateNormal];
    [self.startStopButton setTitle: @"Start" forState: UIControlStateHighlighted];
}

- (void)showStopButton {
    self.timerActive = YES;
    [Utilities setImage:@"orangeButton.png" AndHighlightImage:@"orangeButtonHighlight.png" forButton:self.startStopButton];
    [self.startStopButton setTitle: @"Stop" forState: UIControlStateNormal];
    [self.startStopButton setTitle: @"Stop" forState: UIControlStateHighlighted];
}

- (IBAction)resetButtonPressed:(id)sender {
    self.timerActive = NO;
    appDelegate.totalElapsedTime = 0;
    [timer invalidate];
    [self updateStopwatchLabelWithInterval:0];
    [self showStartButton];
}

- (void)updateStopwatchLabel {
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:appDelegate.startTime] + appDelegate.totalElapsedTime;
    if (elapsedTime >= SECONDS_PER_DAY) {
        [self resetButtonPressed:nil];
    } else {
        [self updateStopwatchLabelWithInterval:elapsedTime];
    }
}

- (void)updateStopwatchLabelWithInterval:(NSTimeInterval)elapsedTime {
    NSDate *temp = [NSDate dateWithTimeIntervalSince1970:elapsedTime];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (elapsedTime >= 3600) {
        [formatter setDateFormat:@"HH:mm:ss:S"];
    } else {
        [formatter setDateFormat:@"mm:ss:S"];
    }
    
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];

    NSString *str = [formatter stringFromDate:temp];
    self.stopwatchLabel.text = str;
}

@end
