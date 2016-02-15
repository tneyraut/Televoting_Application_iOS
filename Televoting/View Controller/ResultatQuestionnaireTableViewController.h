//
//  ResultatQuestionnaireTableViewController.h
//  Televoting
//
//  Created by Thomas Mac on 30/06/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ResultatModel.h"

@interface ResultatQuestionnaireTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, ResultatModelProtocol>

@property(nonatomic) int user_id;

@property(nonatomic) int questionnaire_id;

@end
