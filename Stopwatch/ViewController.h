//
//  ViewController.h
//  Stopwatch
//
//  Created by Andrew Wu on 9/29/12.
//  Copyright (c) 2012 Andrew Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BButton/BButton.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *stopwatchLabel;
- (IBAction)startStopButtonPressed:(id)sender;
- (IBAction)resetButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet BButton *startStopButton;
@property (weak, nonatomic) IBOutlet BButton *resetButton;
@property (nonatomic) BOOL *timerActive;

@end
