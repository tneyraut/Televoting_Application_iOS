//
//  ProfListeQuestionnairesTableViewController.h
//  Televoting
//
//  Created by Thomas Mac on 02/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Cours.h"

#import "QuestionnaireModel.h"

@interface ProfListeQuestionnairesTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, QuestionnaireModelProtocol>

@property(nonatomic, weak) Cours *coursSelected;

@end
