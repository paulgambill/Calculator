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
@synthesize graphOrigin = _graphOrigin;
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

- (void)setGraphOrigin:(CGPoint)graphOrigin
{
    _graphOrigin = graphOrigin;
    [self setNeedsDisplay]; //redraw when the user has panned to a different graphOrigin
}

//handle pinching to adjust scale
- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) 
    {
        self.scale *= gesture.scale; //adjusts the scale
        gesture.scale = 1; //resets the scale to 1 so that future scale changes happen from that point, not the original
    }
}

//handle panning to adjust the graphOrigin
- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded))
    {
        CGPoint translation = [gesture translationInView:self];
        self.graphOrigin = translation;
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
    
    //draws axes on the graph view
    [AxesDrawer drawAxesInRect:[[UIScreen mainScreen] bounds] originAtPoint:[self graphOrigin] scale:[self scale]];
   
    CGPoint midpoint; //center of screen
    midpoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midpoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    CGPoint origin;
    origin.x = midpoint.x;
    origin.y = midpoint.y;
    
    // point for drawing. might need another for drawToThisPoint
    CGPoint drawingPoint;
    
    //stubbed out if checking if the delegated method has been implemented and then do stuff inside it
    if ([[self dataSource] respondsToSelector:@selector(yValueForXValue:)])
    {
        for (double point=0; point<self.bounds.size.width; point++) {
            drawingPoint.y = [[self dataSource] yValueForXValue:point];
            drawingPoint.x = point;
            
            
            //convert x coordinate to xValue. get corresponding yValue. convert to y coordinate. that is point 1. repeat for point 2. draw from point 1 to point 2. wash, rinse, repeat.
         }

    }
    
    UIGraphicsPopContext();
}

@end
