//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Paul Gambill on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack
{
    if (!_operandStack) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

- (void)pushOperand:(double)operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
}

- (double)popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

- (void)emptyStack
{
    [self.operandStack removeAllObjects];
}

- (double)performOperation:(NSString *)operation
{
    double result = 0;
    
    // add
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    } 
    
    // multiply
    else if ([@"*" isEqualToString:operation]) {
        result = [self popOperand] * [self popOperand];
    } 
    
    // subtract
    else if ([operation isEqualToString:@"-"]) {
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    } 
    
    // divide
    else if ([operation isEqualToString:@"/"]) {
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand] / divisor;
    }
    
    // sin
    else if ([operation isEqualToString:@"sin"]) {
        result = sin([self popOperand]);
    }
    
    // cos
    else if ([operation isEqualToString:@"cos"]) {
        result = cos([self popOperand]);
    }
    
    // sqrt
    else if ([operation isEqualToString:@"sqrt"]) {
        result = sqrt([self popOperand]);
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

@end
