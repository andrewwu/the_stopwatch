//
//  TimerViewController.h
//  Stopwatch
//
//  Created by Andrew Wu on 10/31/12.
//  Copyright (c) 2012 Andrew Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *startPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)startPauseButtonPressed:(id)sender;
- (IBAction)resetButtonPressed:(id)sender;

@end
