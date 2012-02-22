//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Paul Gambill on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (void)emptyStack;
- (NSDictionary *)writeVariableValuesToDictionary:(NSString *)testName;


@property (nonatomic, readonly) id program;



+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;

//+ (NSSet *)variablesUsedInProgram:(id)program;

@end
