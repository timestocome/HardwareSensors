//
//  SimpleGraphView.m
//  TestHardware
//
//  Created by Linda Cobb on 3/19/13.
//  Copyright (c) 2013 Linda Cobb. All rights reserved.
//

#import "SimpleGraphView.h"

@implementation SimpleGraphView




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {}
    
    return self;
}



- (void)setupGraph
{
    
    area = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    
    self.xColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    self.yColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
    self.zColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
    
    self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    self.gridColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    
    
    maxPoints = (int)area.size.width;
    
    self.dataArrayX = [[NSMutableArray alloc] initWithCapacity:maxPoints];
    for( int i=0; i<maxPoints; i++){ [self.dataArrayX insertObject:[NSNumber numberWithDouble:0.0] atIndex:i]; }
    
    self.dataArrayY = [[NSMutableArray alloc] initWithCapacity:maxPoints];
    for( int i=0; i<maxPoints; i++){ [self.dataArrayY insertObject:[NSNumber numberWithDouble:0.0] atIndex:i]; }

    self.dataArrayZ = [[NSMutableArray alloc] initWithCapacity:maxPoints];
    for( int i=0; i<maxPoints; i++){ [self.dataArrayZ insertObject:[NSNumber numberWithDouble:0.0] atIndex:i]; }

    if ( scale < 1.0 ){ scale =  1.0; }
    
    [self setNeedsDisplay];

}


-(void)setScale:(float)s
{
    scale = s;
}



- (void)addX:(NSNumber *)x y:(NSNumber *)y z:(NSNumber *)z
{
    [self.dataArrayX insertObject:x atIndex:0];
    [self.dataArrayX removeObjectAtIndex:maxPoints - 1];
    
    [self.dataArrayY insertObject:y atIndex:0];
    [self.dataArrayY removeObjectAtIndex:maxPoints - 1];
    
    [self.dataArrayZ insertObject:z atIndex:0];
    [self.dataArrayZ removeObjectAtIndex:maxPoints - 1];
    
    
    [self setNeedsDisplay];
    
}






- (void)drawRect:(CGRect)rect
{
    if ( area.size.width <= 0 ){ [self setupGraph]; }
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, self.bounds);
       

    
    // grid lines
    float middleY = area.size.height/2.0;
    float width = area.size.width;

    CGContextMoveToPoint(context, 0.0, middleY);
    CGContextAddLineToPoint(context, width, middleY);
    CGContextSetStrokeColorWithColor(context, self.gridColor.CGColor);
    CGContextStrokePath(context);

    

    // data
    long dataPoints = [self.dataArrayX count];
    float x = 0.0;
    float y = 0.0;
    float z = 0.0;
    float previousX = 0.0;
    float previousY = 0.0;
    float previousZ = 0.0;
    CGPoint px, py, pz;
    
    
    for (int i=0; i<dataPoints; i++){
        
        // plot x
        CGContextSetStrokeColorWithColor(context, self.xColor.CGColor);
        x = middleY - ([(NSNumber *)self.dataArrayX[i] doubleValue]) * scale;
        px = CGPointMake(i, x);
        
        CGContextMoveToPoint(context, i-1, previousX);
        CGContextAddLineToPoint(context, i, x);
        CGContextStrokePath(context);
        
        previousX = x;
        
        
        // plot y
        CGContextSetStrokeColorWithColor(context, self.yColor.CGColor);
        y = middleY - ([(NSNumber *)self.dataArrayY[i] doubleValue]) * scale;
        py = CGPointMake(i, y);
        
        CGContextMoveToPoint(context, i-1, previousY);
        CGContextAddLineToPoint(context, i, y);
        CGContextStrokePath(context);
        
        previousY = y;

        
        
        // plot z
        CGContextSetStrokeColorWithColor(context, self.zColor.CGColor);
        z = middleY - ([(NSNumber *)self.dataArrayZ[i] doubleValue]) * scale;
        pz = CGPointMake(i, z);
        
        CGContextMoveToPoint(context, i-1, previousZ);
        CGContextAddLineToPoint(context, i, z);
        CGContextStrokePath(context);
        
        previousZ = z;
        

    }
    
}






@end