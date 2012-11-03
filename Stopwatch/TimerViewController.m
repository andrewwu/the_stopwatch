//
//  TimerViewController.m
//  Stopwatch
//
//  Created by Andrew Wu on 10/31/12.
//  Copyright (c) 2012 Andrew Wu. All rights reserved.
//

#import "TimerViewController.h"
#import "Utilities.h"
#import <AVFoundation/AVFoundation.h>

@interface TimerViewController () <UIAlertViewDelegate> {
    NSTimer *timer;
    NSTimeInterval totalTime;
    NSTimeInterval elapsedTime;
}

- (void)timerDidFinish;
- (void)timerTicked;
- (void)resetTimer;
- (void)showStartButton;
- (void)showPauseButton;

@property (nonatomic) BOOL timerActive;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation TimerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    elapsedTime = 0;
    self.timerActive = NO;
    self.timerLabel.text = @"00:00:00";
    
    [Utilities setImage:@"blueButton.png" AndHighlightImage:@"blueButtonHighlight.png" forButton:self.resetButton];
    [Utilities setImage:@"greenButton.png" AndHighlightImage:@"greenButtonHightlight.png" forButton:self.startPauseButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showStartButton {
    self.timerActive = NO;
    [Utilities setImage:@"greenButton.png" AndHighlightImage:@"greenButtonHightlight.png" forButton:self.startPauseButton];
    [self.startPauseButton setTitle: @"Start" forState: UIControlStateNormal];
    [self.startPauseButton setTitle: @"Start" forState: UIControlStateHighlighted];
}

- (void)showPauseButton {
    self.timerActive = YES;
    [Utilities setImage:@"orangeButton.png" AndHighlightImage:@"orangeButtonHighlight.png" forButton:self.startPauseButton];
    [self.startPauseButton setTitle: @"Pause" forState: UIControlStateNormal];
    [self.startPauseButton setTitle: @"Pause" forState: UIControlStateHighlighted];
}

- (IBAction)startPauseButtonPressed:(id)sender {
    if (!self.timerActive && elapsedTime > 0) {
        self.timerActive = YES;
        [self showPauseButton];
    } else if (self.timerActive && elapsedTime > 0) {
        self.timerActive = NO;
        [self showStartButton];
    } else {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTicked) userInfo:nil repeats:YES];
        
        self.timerActive = YES;
        [self showPauseButton];
        
        totalTime = (NSTimeInterval)self.datePicker.countDownDuration;
        [Utilities formatLabel:self.timerLabel withTimeInterval:totalTime];
        
        self.datePicker.hidden = YES;
    }
}

- (IBAction)resetButtonPressed:(id)sender {
    [self resetTimer];
}

- (void)timerTicked {
    if (self.timerActive) {
        if (totalTime - elapsedTime <= 0) {
            [self timerDidFinish];
        } else {
            [Utilities formatLabel:self.timerLabel withTimeInterval:(totalTime - elapsedTime)];
            elapsedTime++;
        }
    }
}

- (void)timerDidFinish {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Timer Done" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/alert.mp3", [[NSBundle mainBundle] resourcePath]];

    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    self.audioPlayer.numberOfLoops = -1;
    
    [self.audioPlayer play];
    
    [self resetTimer];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (self.audioPlayer) {
            [self.audioPlayer stop];
        }
    }
}

- (void)resetTimer {
    [timer invalidate];
    elapsedTime = 0;
    self.timerActive = NO;
    self.timerLabel.text = @"00:00";
    self.datePicker.hidden = NO;
    [self showStartButton];
}

@end
