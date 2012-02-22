//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Paul Gambill on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSString *selectedTest;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize selectedTest = _selectedTest;

- (CalculatorBrain *)brain
{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = [sender currentTitle];
    NSString *dot = @".";
    if (self.userIsInTheMiddleOfEnteringANumber) {
        NSRange dotRange = [self.display.text rangeOfString:dot];
        if (dotRange.location == NSNotFound || ![digit isEqualToString:dot]) {
            self.display.text = [self.display.text stringByAppendingString:digit];
        }
    } else{
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed 
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.history.text = [self.history.text stringByAppendingString:[self.display.text stringByAppendingString:@" "]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation = sender.currentTitle;
    double result = [self.brain performOperation:operation withTestValue:self.selectedTest];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.history.text = [self.history.text stringByAppendingString:[operation stringByAppendingString:@" "]];
}

- (IBAction)clearPressed:(UIButton *)sender 
{    
    [self.brain emptyStack];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.display.text = @"0";
    self.history.text = @"";
}

- (IBAction)testPressed:(UIButton *)sender 
{
    self.selectedTest = sender.currentTitle;
}

@end
