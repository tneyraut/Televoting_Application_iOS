//
//  ListeReponsesView.h
//  Televoting
//
//  Created by Thomas Mac on 17/06/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ListeQuestionsView.h"

#import "Question.h"
#import "Questionnaire.h"

@interface ListeReponsesView : UITableViewController

@property(nonatomic,strong) NSArray *reponses;

@property(nonatomic,strong) Question *questionChoisie;

@property(nonatomic,strong) Questionnaire *questionnaireChoisi;

@property(nonatomic,weak) ListeQuestionsView *listeQuestionsView;

@end
