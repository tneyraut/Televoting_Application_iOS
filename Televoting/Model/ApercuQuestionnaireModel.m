//
//  ApercuQuestionnaireModel.m
//  Televoting
//
//  Created by Thomas Mac on 05/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import "ApercuQuestionnaireModel.h"

#import "Question.h"
#import "Reponse.h"

@interface ApercuQuestionnaireModel()
{
    NSMutableData* _downloadedData;
}

@end

@implementation ApercuQuestionnaireModel

- (void)getListeQuestionsReponses:(int)questionnaire_id
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/listeQuestionsReponses.php?questionnaire_id=%d", questionnaire_id]];
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
    NSMutableArray* _apercuArray = [[NSMutableArray alloc] init];
    
    NSError* error;
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    for (int i=0;i<jsonArray.count;i=i+2)
    {
        NSDictionary *jsonElement = jsonArray[i];
        
        Question *question = [[Question alloc] init];
        question.question_id = [jsonElement[@"question_id"] intValue];
        question.question = jsonElement[@"question"];
        question.image = jsonElement[@"image"];
        question.temps_imparti = [jsonElement[@"temps_imparti"] intValue];
        
        [_apercuArray addObject:question];
        
        NSMutableArray *arrayReponse = [[NSMutableArray alloc] init];
        NSArray *array = jsonArray[i+1];
        
        for (int j=0;j<array.count;j++)
        {
            jsonElement = array[j];
            
            Reponse *reponse = [[Reponse alloc] init];
            reponse.reponse_id = [jsonElement[@"reponse_id"] intValue];
            reponse.reponse = jsonElement[@"reponse"];
            reponse.reponse_correcte = [jsonElement[@"reponse_correcte"] boolValue];
            reponse.image = jsonElement[@"image"];
            
            [arrayReponse addObject:reponse];
        }
        
        [_apercuArray addObject:arrayReponse];
    }
    
    if (self.delegate)
    {
        [self.delegate getApercuQuestionnaireDownloaded:_apercuArray];
    }
}

@end
