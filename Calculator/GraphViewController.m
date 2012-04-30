//
//  GraphViewController.m
//  Calculator
//
//  Created by Paul Gambill on 3/16/12.
//  Copyright (c) 2012 Deloitte | Übermind. All rights reserved.
//

#import "GraphViewController.h"
#import "CalculatorBrain.h"
#import "CalculatorProgramsTableViewController.h"

@interface GraphViewController () <GraphViewDelegate, CalculatorProgramsTableViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) UIPopoverController *popoverController;
@end

@implementation GraphViewController
@synthesize program = _program;
@synthesize graphView = _graphView;
@synthesize splitviewBarButtonItem = _splitviewBarButtonItem;
@synthesize toolbar = _toolbar;
@synthesize popoverController;

#define FAVORITES_KEY @"GraphViewController.Favorites"

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    
    //enable pinch
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    
    //enable pan
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    
    //enable tripletap to center the graph origin
    [self.graphView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tripleTap:)]];
    
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
                                                            [NSNumber numberWithDouble:xValue], 
                                                            @"x", nil];
    
    if(_program)
    {
       yValue = [CalculatorBrain runProgram:self.program usingVariableValues:xValueDictionary];
    }
    
    return yValue;
}

- (void)setSplitviewBarButtonItem:(UIBarButtonItem *)splitviewBarButtonItem
{
    if (_splitviewBarButtonItem != splitviewBarButtonItem) 
    {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitviewBarButtonItem) [toolbarItems removeObject:_splitviewBarButtonItem];
        if (splitviewBarButtonItem) [toolbarItems insertObject:splitviewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitviewBarButtonItem = splitviewBarButtonItem;
    }
}

- (IBAction)addToFavorites:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favorites = [[defaults objectForKey:FAVORITES_KEY] mutableCopy];
    if (!favorites) favorites = [NSMutableArray array];
    [favorites addObject:self.program];
    [defaults setObject:favorites forKey:FAVORITES_KEY];
    [defaults synchronize];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Favorite Graphs"]) {
        
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardSegue *)segue;
            [self.popoverController dismissPopoverAnimated:YES];
            self.popoverController = popoverSegue.popoverController;
        }
        NSArray *programs = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY];
        [segue.destinationViewController setPrograms:programs];
        [segue.destinationViewController setDelegate:self];
    }
}

- (void)calculatorProgramsTableViewController:(CalculatorProgramsTableViewController *)sender choseProgram:(id)program
{
    self.program = program;
    // if you wanted to close the popover when a graph was selected
    // you could uncomment the following line
    // you'd probably want to set self.popoverController = nil after doing so
    // [self.popoverController dismissPopoverAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES]; // added after lecture to support iPhone
}

- (void)calculatorProgramsTableViewController:(CalculatorProgramsTableViewController *)sender
                               deletedProgram:(id)program
{
    NSString *deletedProgramDescription = [CalculatorBrain descriptionOfProgram:program];
    NSMutableArray *favorites = [NSMutableArray array];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    for (id program in [defaults objectForKey:FAVORITES_KEY]) {
        if (![[CalculatorBrain descriptionOfProgram:program] isEqualToString:deletedProgramDescription]) {
            [favorites addObject:program];
        }
    }
    [defaults setObject:favorites forKey:FAVORITES_KEY];
    [defaults synchronize];
    sender.programs = favorites;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.graphView setNeedsDisplay];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
    //return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
