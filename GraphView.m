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
        //else return the saved scale
        //return [[[NSUserDefaults standardUserDefaults] objectForKey:@"scale"] floatValue];
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

- (CGPoint)graphOrigin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGPoint origin = CGPointFromString([defaults objectForKey:@"origin"]);
    
    if (CGPointEqualToPoint(_graphOrigin, CGPointZero))
    {
        if(!defaults)
        {
            //if the origin is set at (0,0) top left of screen, change it to center of visible view
            _graphOrigin = CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2, self.bounds.origin.y + self.bounds.size.height / 2);
        }
        else
        {
            _graphOrigin = origin;
        }
    } 
    
    return _graphOrigin;
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
        
        if (gesture.state == UIGestureRecognizerStateEnded)
        {
            //save scale
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:self.scale] forKey:@"scale"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

//handle panning to adjust the graphOrigin
- (void)pan:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation  = [gesture translationInView:self];
    CGPoint relativeTranslation;
    
    //get the translation relative to the graph origin
    relativeTranslation.x = self.graphOrigin.x + translation.x;
    relativeTranslation.y = self.graphOrigin.y + translation.y;
    self.graphOrigin = relativeTranslation;
    
    //reset the translation to 0 so it is not cumulative
    [gesture setTranslation:CGPointZero inView:self];
    
//    NSString *pointForLog = NSStringFromCGPoint(translation);
//    NSString *pointGraphOrigin = NSStringFromCGPoint(self.graphOrigin);
//    NSLog(NSStringFromCGPoint(translation));
//    NSLog(NSStringFromCGPoint(self.graphOrigin));
    
    //save location of origin
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        //place origin into a string and then save as user default
        NSString *originPoint = NSStringFromCGPoint(self.graphOrigin);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:originPoint forKey:@"origin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//triple tap to center the origin at tap
- (void)tripleTap:(UITapGestureRecognizer *)gesture
{
    gesture.numberOfTapsRequired = 3;
    
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        //move origin to location of triple tap
        self.graphOrigin = [gesture locationInView:self];
    
        //save location of origin
        //place origin into a string and then save as user default
        NSString *originPoint = NSStringFromCGPoint(self.graphOrigin);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:originPoint forKey:@"origin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
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
