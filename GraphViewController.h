//
//  GraphViewController.h
//  Calculator
//
//  Created by Paul Gambill on 3/16/12.
//  Copyright (c) 2012 Deloitte | Übermind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphViewController : UIViewController
@property (nonatomic, readonly) id program;
@property (nonatomic, weak) IBOutlet GraphView *graphView;

@end
