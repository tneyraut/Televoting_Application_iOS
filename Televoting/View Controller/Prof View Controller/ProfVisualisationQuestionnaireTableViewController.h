//
//  ProfVisualisationQuestionnaireTableViewController.h
//  Televoting
//
//  Created by Thomas Mac on 04/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ApercuQuestionnaireModel.h"

#import "Questionnaire.h"

@interface ProfVisualisationQuestionnaireTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, ApercuQuestionnaireModelProtocol>

@property(nonatomic, weak) Questionnaire *questionnaireSelected;

@property(nonatomic) BOOL apercuPartiel;

@end
