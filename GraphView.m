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
    //if there is not a scale saved in user defaults
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"scale"]) {
    if(!_scale){
        //set the scale to a defined scale that is not 0
        _scale = DEFAULT_SCALE;
//    } else if(_scale != DEFAULT_SCALE) {
//        //else return the saved scale
//        _scale = [[[NSUserDefaults standardUserDefaults] objectForKey:@"scale"] floatValue];
    }
    
    return _scale;
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
    if ([self.dataSource respondsToSelector:@selector(yValueForXValue:)])
    {
        [[UIColor blackColor] setStroke];
        CGContextMoveToPoint(context, CGPointZero.x, CGPointZero.y);
        double xValue;
        double yValue;
        
        for (double point=0; point<self.bounds.size.width; point++) {
            
            //convert the horizontal point to an x Value based on the graph scale and origin
            xValue = point/[self scale] - self.graphOrigin.x;
            
            //using the x Value, get the y Value and convert to a graph point
            yValue = [self.dataSource yValueForXValue:xValue];            
            
            drawingPoint.y = yValue/[self scale] + self.graphOrigin.y;
            drawingPoint.x = point;
            
           
            NSLog(@"xValue: %f", xValue);
            NSLog(@"yValue: %f", yValue);
            NSLog(@"drawingPoint: %@", NSStringFromCGPoint(drawingPoint));
            
            
            CGContextAddLineToPoint(context, drawingPoint.x, drawingPoint.y);
         }
        
        CGContextStrokePath(context);
    }
    
    UIGraphicsPopContext();
}

@end
