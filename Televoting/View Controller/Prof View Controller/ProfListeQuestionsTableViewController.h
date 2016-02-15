//
//  ProfListeQuestionsTableViewController.h
//  Televoting
//
//  Created by Thomas Mac on 05/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Questionnaire.h"

#import "ApercuQuestionnaireModel.h"
#import "QuestionModel.h"

@interface ProfListeQuestionsTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, ApercuQuestionnaireModelProtocol, QuestionModelProtocol>

@property(nonatomic, weak) Questionnaire *questionnaireSelected;

@end
