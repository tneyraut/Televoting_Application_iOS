//
//  QuestionModel.h
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QuestionModelProtocol <NSObject>

- (void) questionDownloaded : (NSArray*) items;

@end

@interface QuestionModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic,weak) id<QuestionModelProtocol> delegate;

- (void) getQuestionsByQuestionnaire: (int) user_id questionnaireID:(int)questionnaire_id;

- (void) updateQuestion:(int)question_id question:(NSString*)question temps_imparti:(int)temps_imparti;

- (void) creerQuestion:(int)questionnaire_id question:(NSString*)question temps_imparti:(int)temps_imparti;

- (void) supprimerQuestion:(int)question_id;

@end
