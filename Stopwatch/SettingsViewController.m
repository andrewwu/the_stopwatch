//
//  SettingsViewController.m
//  Stopwatch
//
//  Created by Andrew Wu on 10/20/12.
//  Copyright (c) 2012 Andrew Wu. All rights reserved.
//

#import "SettingsViewController.h"
#import "Utilities.h"
#import "AppDelegate.h"
#import <ActionSheetPicker.h>

@interface SettingsViewController () {
    AppDelegate *appDelegate;
}

@property (strong, nonatomic) NSMutableArray *pickerArray;

@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.pickerArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <= 60; i++) {
        NSString *value = @"";
        
        if (i == 0) {
            value = @"Never";
        } else if (i == 1) {
            value = @"1 minute";
        } else {
            value = [NSString stringWithFormat:@"%i minutes", i];
        }
        
        [self.pickerArray addObject:value];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    BOOL autoLockScreenValue = [Utilities initializeScreenAutoLock];
    [self.autoLockSwitch setOn:autoLockScreenValue animated:NO];
    [self setBeepInterval:appDelegate.beepInterval];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)setBeepInterval:(NSInteger)selectedIndex {
    NSString *label = @"Never";
    
    if (selectedIndex > 0) {
        label = [NSString stringWithFormat:@"%i min", selectedIndex];
    }
    
    self.beepIntervalLabel.text = label;
    appDelegate.beepInterval = selectedIndex;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            [self setBeepInterval:selectedIndex];
        };

        id cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
            NSLog(@"Beep Interval Picker Canceled");
        };
        
        [ActionSheetStringPicker showPickerWithTitle:@"Select Beep Interval" rows:self.pickerArray initialSelection:appDelegate.beepInterval doneBlock:done cancelBlock:cancel origin:cell];
    }
}

- (IBAction)autoLockSwitchPressed:(id)sender
{
    if ([self.autoLockSwitch isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autoLockScreen"];
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"autoLockScreen"];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
}
@end
