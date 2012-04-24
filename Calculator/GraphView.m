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
    if (_scale != DEFAULT_SCALE) {
        
        // if there is a saved scale, use it. otherwise set the default_scale
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"scale"])
        {
            _scale = [[[NSUserDefaults standardUserDefaults] objectForKey:@"scale"] floatValue];
        }
        else {
            _scale = DEFAULT_SCALE;
        }
        
    }
    
    return _scale;
}

- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay]; //redraw whenever the scale changes
        
        //save scale
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:_scale] forKey:@"scale"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (CGPoint)graphOrigin
{    
    if (CGPointEqualToPoint(_graphOrigin, CGPointZero))
    {
        //if origin has not been saved before into user defaults
        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"origin"])
        {
            //if the origin is set at (0,0) top left of screen and there is no saved origin, change it to center of visible view
            _graphOrigin = CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2, self.bounds.origin.y + self.bounds.size.height / 2);
        }
        else
        {   
            //else return the saved origin point
            _graphOrigin = CGPointFromString([[NSUserDefaults standardUserDefaults] objectForKey:@"origin"]);
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
    
    // point for drawing
    CGPoint drawingPoint;
    
    //stubbed out if checking if the delegated method has been implemented and then do stuff inside it
    if ([self.dataSource respondsToSelector:@selector(yValueForXValue:)])
    {
        [[UIColor blackColor] setStroke];
        CGContextMoveToPoint(context, CGPointZero.x, CGPointZero.y);
        double xValue;
        double yValue;
        double increment = 1/self.contentScaleFactor;
        
        for (double point=self.bounds.origin.x; point<self.bounds.size.width; point+=increment) {
            
            //convert the horizontal point to an x Value based on the graph scale and origin
            xValue = (point - self.graphOrigin.x) / self.scale;
            
            //using the x Value, get the y Value and convert to a graph point
            yValue = [self.dataSource yValueForXValue:xValue];
            
            drawingPoint.y = (-yValue * self.scale) + self.graphOrigin.y;
            drawingPoint.x = point;
            
            
            // logging drawing values. Set shouldLog to YES to print out data
            BOOL shouldLog = NO;
            if (drawingPoint.y < 0 || drawingPoint.x < 0 || drawingPoint.y > 480 || drawingPoint.x > 320) {
                shouldLog = NO;
            }
            if ((int)point % 10 == 0 && shouldLog) {
                NSLog(@"scale: %f", self.scale);
                NSLog(@"xValue: %f", xValue);
                NSLog(@"yValue: %f", yValue);
                NSLog(@"graphOrigin: %@", NSStringFromCGPoint(self.graphOrigin));
                NSLog(@"drawingPoint: %@", NSStringFromCGPoint(drawingPoint));
            }
            
            
            CGContextAddLineToPoint(context, drawingPoint.x, drawingPoint.y);
        }
        
        CGContextStrokePath(context);
    }
    
    UIGraphicsPopContext();
}

@end
