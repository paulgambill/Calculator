//
//  GraphViewController.m
//  Calculator
//
//  Created by Paul Gambill on 3/16/12.
//  Copyright (c) 2012 Deloitte | Übermind. All rights reserved.
//

#import "GraphViewController.h"
#import "CalculatorBrain.h"

@interface GraphViewController () <GraphViewDelegate>

@end

@implementation GraphViewController
@synthesize program = _program;
@synthesize graphView = _graphView;


- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    
    //enable pinch
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    
    //enable pan
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    
    self.graphView.dataSource = self;
}

- (void)setProgram:(id)program
{
    _program = program;
    
    //redraw here, because we have a new program and therefore a new graph
    [self.graphView setNeedsDisplay];
}

- (id)program
{
    if (!_program)
    {
        _program = [[GraphViewController alloc] init];
    }
    return _program;
}

- (double)yValueForXValue:(double)xValue
{
    double yValue;
    
    NSDictionary *xValueDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithDouble:xValue], @"x", nil];
    
    if(_program)
    {
       yValue = [CalculatorBrain runProgram:self.program usingVariableValues:xValueDictionary];
    }
    
    return yValue;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
