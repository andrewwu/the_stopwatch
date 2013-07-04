//
//  SettingsViewController.h
//  Stopwatch
//
//  Created by Andrew Wu on 10/20/12.
//  Copyright (c) 2012 Andrew Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *autoLockSwitch;
@property (strong, nonatomic) IBOutlet UILabel *beepIntervalLabel;
- (IBAction)autoLockSwitchPressed:(id)sender;

@end
