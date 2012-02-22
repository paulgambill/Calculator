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
@property (nonatomic, strong) NSDictionary *variableValues;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;
@synthesize variableValues = _variableValues;

// variableValues getter
- (NSDictionary *)variableValues
{
    if (!_variableValues) {
        _variableValues = [[NSDictionary alloc] init];
    }
    return _variableValues;
}

// programStack getter
- (NSMutableArray *)programStack
{
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
} 


// variableValues get written here
- (void)writeVariableValuesToDictionary:(NSString *)testName
{
    if ([testName isEqualToString:@"Test 1"]) {
        self.variableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:1], @"x",
                               [NSNumber numberWithInt:2], @"y",
                               [NSNumber numberWithInt:3], @"z", nil];
    } 
    else if ([testName isEqualToString:@"Test 2"]) {
        self.variableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:4], @"x",
                               [NSNumber numberWithInt:5], @"y",
                               [NSNumber numberWithInt:6], @"z", nil];
    } 
    else if ([testName isEqualToString:@"Test 3"]) {
        self.variableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:7], @"x",
                               [NSNumber numberWithInt:8], @"y",
                               [NSNumber numberWithInt:9], @"z", nil];
    }    
}

// program getter
- (id)program
{
    return [self.programStack copy];
}


+ (NSString *)descriptionOfProgram:(id)program
{
    return @"Implement this in Homework #2";
}


// adds operand to top of stack
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


+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
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
            result = [self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
        } 
        
        // multiply
        else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack] * [self popOperandOffProgramStack:stack];
        } 
        
        // subtract
        else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } 
        
        // divide
        else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        }
        
        // sin
        else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack]);
        }
        
        // cos
        else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack]);
        }
        
        // sqrt
        else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffProgramStack:stack]);
        }
        
        // π
        else if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        }
    }
    
    //push the result back onto the stack so the next operation can use it
    //[self pushOperand:result];
    
    return result;
}

- (void)emptyStack
{
    [self.programStack removeAllObjects];
}

+ (double)runProgram:(id)program //usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}
    
@end
