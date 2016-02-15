//
//  QuestionModel.m
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "QuestionModel.h"
#import "Question.h"

@interface QuestionModel() {
    NSMutableData* _downloadedData;
}

@end

@implementation QuestionModel

- (void) getQuestionsByQuestionnaire:(int)user_id questionnaireID:(int)questionnaire_id
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/listeQuestionsByQuestionnaire.php?user_id=%d&questionnaire_id=%d",user_id,questionnaire_id]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) updateQuestion:(int)question_id question:(NSString *)question temps_imparti:(int)temps_imparti
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/updateQuestion.php?question_id=%d&question=%@&temps_imparti=%d", question_id, [question stringByReplacingOccurrencesOfString:@" " withString:@"_"], temps_imparti]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) creerQuestion:(int)questionnaire_id question:(NSString *)question temps_imparti:(int)temps_imparti
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/creationQuestion.php?questionnaire_id=%d&question=%@&temps_imparti=%d", questionnaire_id, [question stringByReplacingOccurrencesOfString:@" " withString:@"_"], temps_imparti]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) supprimerQuestion:(int)question_id
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/supprimerQuestion.php?question_id=%d", question_id]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _downloadedData = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_downloadedData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSMutableArray* _questions = [[NSMutableArray alloc] init];
    
    NSError* error;
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    for (int i=0;i<jsonArray.count; i++) {
        NSDictionary* jsonElement = jsonArray[i];
        Question* uneQuestion = [[Question alloc] init];
        uneQuestion.question_id = [jsonElement[@"question_id"] intValue];
        uneQuestion.questionnaire_id = [jsonElement[@"questionnaire_id"] intValue];
        uneQuestion.question = jsonElement[@"question"];
        uneQuestion.temps_imparti = [jsonElement[@"temps_imparti"] intValue];
        uneQuestion.image = jsonElement[@"image"];
        [_questions addObject:uneQuestion];
    }
    if (self.delegate) {
        [self.delegate questionDownloaded:_questions];
    }
}

@end
