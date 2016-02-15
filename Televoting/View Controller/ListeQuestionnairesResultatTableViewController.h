//
//  ListeQuestionnairesResultatTableViewController.h
//  Televoting
//
//  Created by Thomas Mac on 30/06/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QuestionnaireModel.h"

@interface ListeQuestionnairesResultatTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate,QuestionnaireModelProtocol>

@property(nonatomic) int user_id;

@property(nonatomic) int cours_id;

@end
