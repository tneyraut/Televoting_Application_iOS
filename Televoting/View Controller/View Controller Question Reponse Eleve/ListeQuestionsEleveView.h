//
//  ListeQuestionsEleveView.h
//  Televoting
//
//  Created by Thomas Mac on 26/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QuestionEleveModel.h"

#import "question_eleve.h"
#import "reponse_question_eleve.h"
#import "Cours.h"
#import "User.h"

@interface ListeQuestionsEleveView : UITableViewController <UITableViewDataSource, UITableViewDelegate, QuestionEleveModel>

@property(nonatomic, weak) Cours *coursSelected;

@property(nonatomic, weak) User *user;

@end
