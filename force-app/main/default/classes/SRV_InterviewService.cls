public with sharing class SRV_InterviewService {



    public static  List<Interview__c> getFutureInterviews() {
        return [Select 
                            Duration__c, Recommend_to_Hire__c, Name__c, Candidate__c, Position__c, 
                            InterviewStartDateTime__c, InterviewEndDateTime__c, Interviewer__c 
                            FROM Interview__c 
                            WHERE InterviewStartDateTime__c > TODAY ];
    }

    public static  List<Interview__c> getInterviewsByDateRange(Datetime startDate, Datetime endDate) {
        return [Select 
                            Duration__c, Recommend_to_Hire__c, Name__c, Candidate__c, Position__c, 
                            InterviewStartDateTime__c, InterviewEndDateTime__c, Interviewer__c 
                            FROM Interview__c 
                            WHERE InterviewStartDateTime__c > :startDate and InterviewStartDateTime__c < :endDate];

    }

    public static  Interview__c getInterviewById(String interviewId) {
        return [Select Id,
                            Duration__c, Recommend_to_Hire__c, Name__c, Candidate__c, Position__c, 
                            InterviewStartDateTime__c, InterviewEndDateTime__c, Interviewer__c 
                            FROM Interview__c 
                            WHERE Id = :interviewId];
    }

    public static Interview__c updateInterview(Interview__c interview) {
        Interview__c interviewToUpdate = getInterviewById(interview.Id);

        if (interviewToUpdate == null) {
            throw new InterviewNotFoundException('Interview not found');
        }

        interviewToUpdate.Position__c = interview.Position__c;
        interviewToUpdate.Candidate__c = interview.Candidate__c;
        interviewToUpdate.InterviewStartDateTime__c = interview.InterviewStartDateTime__c;
        interviewToUpdate.Duration__c = interview.Duration__c;

        update interviewToUpdate;

        return interviewToUpdate;
    }
}

 
