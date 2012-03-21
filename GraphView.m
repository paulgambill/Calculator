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
@synthesize scale = _scale;
@synthesize dataSource = _dataSource;

#define DEFAULT_SCALE 1.0

- (CGFloat)scale
{
    if (!_scale) {
        return DEFAULT_SCALE; //not allowing a scale of 0 here
    } else {
        return _scale;
    }
}

- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay]; //redraw whenever the scale changes
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale; //adjusts the scale
        gesture.scale = 1; //resets the scale to 1 so that future scale changes happen from that point, not the original
    }
}

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
    //CGFloat scale = 5.0;
    
    // point for drawing. might need another for drawToThisPoint
    CGPoint drawingPoint;
    
    
    //stubbed out if checking if the delegated method has been implemented and then do stuff inside it
    if ([[self dataSource] respondsToSelector:@selector(yValueForXValue:)])
    {
        drawingPoint.y = [[self dataSource] yValueForXValue:1];
    }
    
    //draws axes on the graph view
    [AxesDrawer drawAxesInRect:bounds originAtPoint:origin scale:self.scale];
    
    UIGraphicsPopContext();
}

@end
