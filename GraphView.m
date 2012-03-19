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
//@synthesize contentMode = _contentMode;

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
    CGPoint origin;
    origin.x = 0;
    origin.y = 0;
    CGFloat scale = 1.0;
    
    
    //draws axes on the graph view
    [AxesDrawer drawAxesInRect:bounds originAtPoint:origin scale:scale];
    
    UIGraphicsPopContext();
}

@end
