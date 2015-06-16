//
//  SimpleGraphView.h
//  TestHardware
//
//  Created by Linda Cobb on 3/19/13.
//  Copyright (c) 2013 Linda Cobb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleGraphView : UIView
{
    CGRect          area;
    int             maxPoints;
    float           scale;
}


@property (nonatomic, strong) UIColor *xColor;
@property (nonatomic, strong) UIColor *yColor;
@property (nonatomic, strong) UIColor *zColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *gridColor;

@property (nonatomic, strong) NSMutableArray *dataArrayX;
@property (nonatomic, strong) NSMutableArray *dataArrayY;
@property (nonatomic, strong) NSMutableArray *dataArrayZ;


-(void)addX:(NSNumber *)x y:(NSNumber *)y z:(NSNumber *)z;
-(void)setScale:(float)s;



@end
