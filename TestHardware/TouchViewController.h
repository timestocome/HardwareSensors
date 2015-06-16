//
//  TouchViewController.h
//  TestHardware
//
//  Created by Linda Cobb on 9/23/12.
//  Copyright (c) 2012 Linda Cobb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchViewController : UIViewController <UIGestureRecognizerDelegate>


@property (nonatomic, retain) IBOutlet UILabel *xStart;
@property (nonatomic, retain) IBOutlet UILabel *yStart;
@property (nonatomic, retain) IBOutlet UILabel *xEnd;
@property (nonatomic, retain) IBOutlet UILabel *yEnd;
@property (nonatomic, retain) IBOutlet UILabel *gestureType;




@end
