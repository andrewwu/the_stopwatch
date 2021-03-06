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
#import <AVFoundation/AVFoundation.h>

#define SECONDS_PER_DAY 86400

@interface ViewController () {
    NSTimer *timer;
    AppDelegate* appDelegate;
    NSInteger lastBeepCount;
}

- (void)updateStopwatchLabel;
- (void)updateStopwatchLabelWithInterval:(NSTimeInterval)elapsedTime;
- (void)showStartButton;
- (void)showStopButton;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.stopwatchViewController = self;

    lastBeepCount = 0;
    self.timerActive = NO;
    appDelegate.totalElapsedTime = 0;
    appDelegate.lastBeepTime = nil;
    /*
    [Utilities setImage:@"blueButton.png" AndHighlightImage:@"blueButtonHighlight.png" forButton:self.resetButton];
    [Utilities setImage:@"greenButton.png" AndHighlightImage:@"greenButtonHightlight.png" forButton:self.startStopButton];
    */
    [self.startStopButton setType:BButtonTypeTwitter];
    [self.resetButton setType:BButtonTypeGray];
    [self.startStopButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:30.0]];
    
    [self.resetButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:30.0]];
    self.stopwatchLabel.text = @"00:00.0";
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
    //[Utilities setImage:@"greenButton.png" AndHighlightImage:@"greenButtonHightlight.png" forButton:self.startStopButton];
    [self.startStopButton setType:BButtonTypeTwitter];
    [self.startStopButton setTitle: @"Start" forState: UIControlStateNormal];
    [self.startStopButton setTitle: @"Start" forState: UIControlStateHighlighted];
}

- (void)showStopButton {
    self.timerActive = YES;
    //[Utilities setImage:@"orangeButton.png" AndHighlightImage:@"orangeButtonHighlight.png" forButton:self.startStopButton];
    [self.startStopButton setType:BButtonTypeDanger];
    [self.startStopButton setTitle: @"Pause" forState: UIControlStateNormal];
    [self.startStopButton setTitle: @"Pause" forState: UIControlStateHighlighted];
}

- (IBAction)resetButtonPressed:(id)sender {
    self.timerActive = NO;
    appDelegate.totalElapsedTime = 0;
    appDelegate.lastBeepTime = nil;
    lastBeepCount = 0;
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
        
        NSInteger beepIntervalInSeconds = [Utilities beepIntervalInSeconds];
        NSInteger count = abs(elapsedTime);
        
        if (beepIntervalInSeconds > 0 && lastBeepCount != count && (count - lastBeepCount) % beepIntervalInSeconds == 0) {
            [self playBeep];
            lastBeepCount = count;
            appDelegate.lastBeepTime = [NSDate date];
        }
    }
}

- (void)updateStopwatchLabelWithInterval:(NSTimeInterval)elapsedTime {
    NSDate *temp = [NSDate dateWithTimeIntervalSince1970:elapsedTime];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (elapsedTime >= 3600) {
        [formatter setDateFormat:@"HH:mm:ss.S"];
    } else {
        [formatter setDateFormat:@"mm:ss.S"];
    }
    
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];

    NSString *str = [formatter stringFromDate:temp];
    self.stopwatchLabel.text = str;
}

- (void)playBeep {
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/dingling.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    [self.audioPlayer play];
}

@end
