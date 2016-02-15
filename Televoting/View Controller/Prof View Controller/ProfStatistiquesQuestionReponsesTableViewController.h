//
//  ProfStatistiquesQuestionReponsesTableViewController.h
//  Televoting
//
//  Created by Thomas Mac on 10/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Questionnaire.h"
#import "Question.h"

#import "StatistiquesModel.h"

@interface ProfStatistiquesQuestionReponsesTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, StatistiquesModelProtocol>

@property(nonatomic, weak) Questionnaire *questionnaireSelected;

@property(nonatomic, weak) Question *questionSelected;

@end
