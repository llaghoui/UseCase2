public with sharing class EventController {
    
    @AuraEnabled(cacheable=true)
    public static Object[] getEventsByDate(Date activityDate) {
        return [Select Id,Subject,ActivityDate, StartDateTime, EndDateTime, DurationInMinutes FROM Event WHERE  ActivityDate = :activityDate];
    }
}