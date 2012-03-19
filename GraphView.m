//
//  GraphView.m
//  Calculator
//
//  Created by Paul Gambill on 3/16/12.
//  Copyright (c) 2012 Deloitte | Übermind. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView
@synthesize contentMode = _contentMode;

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
   
    CGPoint midpoint; //center of screen
    midpoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midpoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    CGPoint origin;
    origin.x = midpoint.x;
    origin.y = midpoint.y;
    CGFloat scale = 5.0;
    
    
    //draws axes on the graph view
    [AxesDrawer drawAxesInRect:bounds originAtPoint:origin scale:scale];
    
    UIGraphicsPopContext();
}

@end
