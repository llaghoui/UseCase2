@RestResource(urlMapping='/Interviews/Range/*')
global with sharing class GetInterviewsByDateRangeRestResource {

    @HttpPost
    global static List<Interview__c> doPost(Datetime startDate, Datetime endDate) {
        List<Interview__c> interviews;
        try {
            interviews = SRV_InterviewService.getInterviewsByDateRange(startDate, endDate);

            if(interviews==null || interviews.isEmpty())
                throw new InterviewNotFoundException('No interviews in this range');

        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }
        return interviews;
    }
}