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


// programStack getter
- (NSMutableArray *)programStack
{
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
} 


// variableValues get written here
- (NSDictionary *)writeVariableValuesToDictionary:(NSString *)testName
{
    NSDictionary *variableValues;
    
    if ([testName isEqualToString:@"Test 1"]) {
        variableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:1], @"x",
                               [NSNumber numberWithDouble:2], @"y",
                               [NSNumber numberWithDouble:3], @"z", nil];
    } 
    else if ([testName isEqualToString:@"Test 2"]) {
        variableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:4], @"x",
                               [NSNumber numberWithDouble:5], @"y",
                               [NSNumber numberWithDouble:6], @"z", nil];
    } 
    else if ([testName isEqualToString:@"Test 3"]) {
        variableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:7], @"x",
                               [NSNumber numberWithDouble:8], @"y",
                               [NSNumber numberWithDouble:9], @"z", nil];
    } else {
        variableValues = nil;
    }
    
    return variableValues;
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
- (void)pushOperand:(id)operand 
{   
    id<NSObject> operandObject;
    
    if ([operand isEqualToString:@"x"] || [operand isEqualToString:@"y"] || [operand isEqualToString:@"z"]) {
        operandObject = operand;
    }
    else {
        operandObject = [NSNumber numberWithDouble:[operand doubleValue]];
    }
    [self.programStack addObject:operandObject];
}


- (double)performOperation:(NSString *)operation withTestValue:(NSString *)selectedTest
{
    // get the variable values from the Test button written into dictionary
    NSDictionary *variableValues = [self writeVariableValuesToDictionary:selectedTest];
    
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program usingVariableValues:variableValues];
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

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
       
    // enumerating through stack array and replacing variables with the key values from dictionary
    if (variableValues) {
        NSArray *keys = [variableValues allKeys];
        for (int i = 0; i < stack.count; i++)
        {
            if ([keys containsObject:[stack objectAtIndex:i]])
            {
                [stack replaceObjectAtIndex:i withObject:[variableValues valueForKey:[stack objectAtIndex:i]]];
            }
        }
    }
    
    return [self popOperandOffProgramStack:stack];
}
    
@end
