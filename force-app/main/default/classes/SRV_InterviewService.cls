public with sharing class SRV_InterviewService {

    public static void calculateInterviewEndDate(List<Interview__c> interviews) {
        if(interviews==null || interviews.size()==0)
            return;

        for( Interview__c interview: interviews) {
            interview.InterviewEndDate__c = interview.InterviewStartDate__c.addHours(Integer.valueOf(interview.Duration__c));
        }
    }
}
