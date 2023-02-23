public with sharing class SRV_InterviewService {

    public static void calculateInterviewEndDate(List<Interview__c> interviews) {
        if(interviews==null || interviews.isEmpty())
            return;

        for( Interview__c interview: interviews) {
            interview.InterviewEndDate__c = interview.InterviewStartDate__c.addHours(Integer.valueOf(interview.Duration__c));
        }
    }

    public static  List<Interview__c> getFutureInterviews() {
        List<Interview__c> futureInterviews = new List<Interview__c>([Select 
                            Duration__c, Recommend_to_Hire__c, Name, Candidate__c, Position__c, 
                            InterviewStartDate__c, InterviewEndDate__c, Interviewer__c 
                            FROM Interview__c 
                            WHERE InterviewStartDate__c > TODAY ]);
        
        return futureInterviews;
    }

    public static  List<Interview__c> getInterviewsByDateRange(Datetime startDate, Datetime endDate) {
        List<Interview__c> futureInterviews = new List<Interview__c>([Select 
                            Duration__c, Recommend_to_Hire__c, Name, Candidate__c, Position__c, 
                            InterviewStartDate__c, InterviewEndDate__c, Interviewer__c 
                            FROM Interview__c 
                            WHERE InterviewStartDate__c > :startDate and InterviewStartDate__c < :endDate]);

        return futureInterviews;
    }

    public static  Interview__c getInterviewById(Id interviewId) {
        Interview__c interview = [Select Id,
                            Duration__c, Recommend_to_Hire__c, Name, Candidate__c, Position__c, 
                            InterviewStartDate__c, InterviewEndDate__c, Interviewer__c 
                            FROM Interview__c 
                            WHERE Id = :interviewId ];
        
        return interview;
    }
    
}
