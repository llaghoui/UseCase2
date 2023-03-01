public class MyTestDataFactory {
    public static List<Candidate__c> createCandidateRecords(String Name, Integer Count, Boolean doInsert) {
        List<Candidate__c> candidateList = new List<Candidate__c>();

        for (Integer i = 0; i < Count; i++) {
            Candidate__c candidate = new Candidate__c();
            candidate.First_Name__c = Name;
            candidate.Last_Name__c = i.format();
            System.debug(candidate.First_Name__c + ' '+ candidate.Last_Name__c);
            candidateList.add(candidate);
        }

        if(doInsert) {
            insert candidateList;
        }

        return candidateList;
    }

    public static List<Interview__c> createInterviewRecords(String Name, DateTime interviewDate, List<Candidate__c> candidateList, Boolean doInsert) {
        List<Interview__c> interviewList = new List<Interview__c>();

        for (Integer i = 0; i < candidateList.size(); i++) {
            Interview__c interview = new Interview__c();
            interview.Candidate__c = candidateList[i].Id;
            interview.Name =  Name + i;
            interview.Duration__c = 2;
            interview.InterviewStartDateTime__c = interviewDate.addDays(i);
            System.debug(interview.Name);
            interviewList.add(interview);
        }

        if(doInsert) {
            insert interviewList;
        }

        return interviewList;
    }

}