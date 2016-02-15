//
//  ProfDonneesGeneralesQuestionnaireTableViewController.h
//  Televoting
//
//  Created by Thomas Mac on 03/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataQuestionnaireModel.h"
#import "QuestionnaireModel.h"

#import "Questionnaire.h"
#import "Cours.h"

@interface ProfDonneesGeneralesQuestionnaireTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, DataQuestionnaireModelProtocol, QuestionnaireModelProtocol>

@property(nonatomic, weak) Questionnaire *questionnaireSelected;

@property(nonatomic, weak) Cours *coursSelected;

@end
