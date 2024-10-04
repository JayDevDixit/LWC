public class opportunityController {
    @AuraEnabled
    public static opportunity updateCloseDate(id opportunityId,Date closeDate){
        Opportunity opp = [SELECT Id, StageName, CloseDate, Amount, OwnerId FROM Opportunity WHERE Id = :opportunityId];
        opp.closeDate = closeDate;
        update opp;
        return opp;

    }
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities(){
        return [select id,name from opportunity order by name limit 100];
    }
}