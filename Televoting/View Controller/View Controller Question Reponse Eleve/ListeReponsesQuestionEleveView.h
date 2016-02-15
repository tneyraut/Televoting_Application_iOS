//
//  ListeReponsesQuestionEleveView.h
//  Televoting
//
//  Created by Thomas Mac on 27/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QuestionEleveModel.h"

#import "question_eleve.h"
#import "User.h"

@interface ListeReponsesQuestionEleveView : UITableViewController <UITableViewDataSource, UITableViewDelegate, QuestionEleveModel>

@property(nonatomic, weak) question_eleve *question_eleve_selected;

@property(nonatomic, weak) NSMutableArray *reponsesQuestionEleveArray;

@property(nonatomic, weak) User *user;

@end
