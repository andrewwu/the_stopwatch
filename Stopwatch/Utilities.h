//
//  Utilities.h
//  Stopwatch
//
//  Created by Andrew Wu on 10/31/12.
//  Copyright (c) 2012 Andrew Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+ (BOOL)initializeScreenAutoLock;
+ (void)setImage:(NSString *)imageName AndHighlightImage:(NSString *)highlightImageName forButton:(UIButton *)button;
+ (void)formatLabel:(UILabel *)label withTimeInterval:(NSTimeInterval)timeInterval;

@end
