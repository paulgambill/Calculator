//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Paul Gambill on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(id)operand;
- (double)performOperation:(NSString *)operation withTestValue:(NSString *)selectedTest;
- (void)emptyStack;

@property (nonatomic, readonly) id program;



+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;

//+ (NSSet *)variablesUsedInProgram:(id)program;

@end
