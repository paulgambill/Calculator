//
//  GraphViewController.h
//  Calculator
//
//  Created by Paul Gambill on 3/16/12.
//  Copyright (c) 2012 Deloitte | Übermind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface GraphViewController : UIViewController <GraphViewDelegate, SplitViewBarButtonItemPresenter>

@property (nonatomic, readonly) id program;
@property (nonatomic, weak) IBOutlet GraphView *graphView;

- (void)setProgram:(id)program;

@end
