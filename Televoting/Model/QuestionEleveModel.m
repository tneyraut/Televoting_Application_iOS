//
//  QuestionEleveModel.m
//  Televoting
//
//  Created by Thomas Mac on 26/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import "QuestionEleveModel.h"

#import "question_eleve.h"
#import "reponse_question_eleve.h"

@interface QuestionEleveModel ()
{
    NSMutableData* _downloadedQuestionsEleve;
}

@end

@implementation QuestionEleveModel

- (void) getQuestionsAndReponsesEleveByCours:(int)cours_id
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/getQuestionsEleveWithReponsesByCours.php?cours_id=%d", cours_id]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) creationQuestionEleve:(int)user_id cours_id:(int)cours_id question:(NSString *)question
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/creationQuestionEleve.php?user_id=%d&cours_id=%d&question=", user_id, cours_id] stringByAppendingString:[question stringByReplacingOccurrencesOfString:@" " withString:@"_"]]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) creationReponseQuestionEleve:(int)question_eleve_id user_id:(int)user_id reponse:(NSString *)reponse
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/creationReponseQuestionEleve.php?question_eleve_id=%d&user_id=%d&reponse=", question_eleve_id, user_id] stringByAppendingString:[reponse stringByReplacingOccurrencesOfString:@" " withString:@"_"]]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _downloadedQuestionsEleve = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_downloadedQuestionsEleve appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSMutableArray* _questionsEleve = [[NSMutableArray alloc] init];
    
    NSError* error;
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedQuestionsEleve options:NSJSONReadingAllowFragments error:&error];
    
    NSArray *questionsArray = jsonArray[0];
    NSMutableArray *questionsEleveArray = [[NSMutableArray alloc] init];
    
    for (int i=0;i<questionsArray.count;i++)
    {
        NSDictionary *jsonElement = questionsArray[i];
        
        question_eleve *questionEleve = [[question_eleve alloc] init];
        
        questionEleve.question_eleve_id = [jsonElement[@"question_eleve_id"] intValue];
        questionEleve.question = (NSString*)jsonElement[@"question"];
        questionEleve.repondue = [jsonElement[@"repondue"] boolValue];
        
        [questionsEleveArray addObject:questionEleve];
    }
    
    NSArray *reponsesArray = jsonArray[1];
    NSMutableArray *allReponsesArray = [[NSMutableArray alloc] init];
    
    for (int i=0;i<reponsesArray.count;i++)
    {
        NSArray *array = reponsesArray[i];
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        
        for (int j=0;j<array.count;j++)
        {
            NSDictionary *jsonElement = array[j];
            
            reponse_question_eleve *reponseQuestionEleve = [[reponse_question_eleve alloc] init];
            
            reponseQuestionEleve.reponse_question_eleve_id = [jsonElement[@"reponse_question_eleve_id"] intValue];
            reponseQuestionEleve.question_eleve_id = [jsonElement[@"question_eleve_id"] intValue];
            reponseQuestionEleve.reponse = (NSString*)jsonElement[@"reponse"];
            
            [mutableArray addObject:reponseQuestionEleve];
        }
        
        [allReponsesArray addObject:mutableArray];
    }
    
    [_questionsEleve addObject:questionsEleveArray];
    [_questionsEleve addObject:allReponsesArray];
    
    if (self.delegate)
    {
        [self.delegate questionsEleveDownloaded:_questionsEleve];
    }
}

@end
