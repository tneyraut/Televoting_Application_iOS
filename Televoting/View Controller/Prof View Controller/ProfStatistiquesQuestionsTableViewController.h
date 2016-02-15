//
//  ProfStatistiquesQuestionsTableViewController.h
//  Televoting
//
//  Created by Thomas Mac on 10/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Questionnaire.h"

#import "StatistiquesModel.h"

@interface ProfStatistiquesQuestionsTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, StatistiquesModelProtocol>

@property(nonatomic, weak) Questionnaire *questionnaireSelected;

@end
