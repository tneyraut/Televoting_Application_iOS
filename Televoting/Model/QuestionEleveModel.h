//
//  QuestionEleveModel.h
//  Televoting
//
//  Created by Thomas Mac on 26/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QuestionEleveModel <NSObject>

- (void) questionsEleveDownloaded:(NSArray*)items;

@end

@interface QuestionEleveModel : NSObject <NSURLConnectionDataDelegate>

@property(nonatomic, weak) id<QuestionEleveModel> delegate;

- (void) getQuestionsAndReponsesEleveByCours:(int)cours_id;

- (void) creationQuestionEleve:(int)user_id cours_id:(int)cours_id question:(NSString *)question;

- (void) creationReponseQuestionEleve:(int)question_eleve_id user_id:(int)user_id reponse:(NSString *)reponse;

@end
