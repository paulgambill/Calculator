//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Paul Gambill on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    return @"Implement this in Homework #2";
}

- (void)pushOperand:(double)operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

- (double)popOperandOffProgramStackOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
    
        // add
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack] + [self popOperandOffProgramStack];
        } 
        
        // multiply
        else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack] * [self popOperandOffProgramStack];
        } 
        
        // subtract
        else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack];
            result = [self popOperandOffProgramStack] - subtrahend;
        } 
        
        // divide
        else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack];
            if (divisor) result = [self popOperandOffProgramStack] / divisor;
        }
        
        // sin
        else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack]);
        }
        
        // cos
        else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack]);
        }
        
        // sqrt
        else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffProgramStack]);
        }
        
        // π
        else if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        }
        
        // e
        else if ([operation isEqualToString:@"e"]) {
            result = M_E;
        }
    
    //push the result back onto the stack so the next operation can use it
    [self pushOperand:result];
    
    return result;
}

- (void)emptyStack
{
    [self.programStack removeAllObjects];
}

;
    if ([program isKindOfClass:[NSArray class]]) {
   [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];[self.programStack addObject:operation];
    return [[self class] runProgram:self.program];[self.programStack addObject:operation];
    return [[self class] runProgram:self.program];     stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}
@end
