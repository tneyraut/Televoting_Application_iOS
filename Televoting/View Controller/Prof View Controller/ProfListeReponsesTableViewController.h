//
//  ProfListeReponsesTableViewController.h
//  Televoting
//
//  Created by Thomas Mac on 05/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QuestionModel.h"
#import "ReponseModel.h"
#import "ApercuQuestionnaireModel.h"

#import "Question.h"
#import "Questionnaire.h"

@interface ProfListeReponsesTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, QuestionModelProtocol, ReponseModelProtocol, ApercuQuestionnaireModelProtocol>

@property(nonatomic, strong) Question *questionSelected;

@property(nonatomic, strong) NSMutableArray *reponsesArray;

@property(nonatomic, weak) Questionnaire *questionnaireSelected;

@end
