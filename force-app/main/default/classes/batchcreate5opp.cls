public with sharing class batchcreate5opp implements Database.Batchable<SObject> {
    
    // Start method - returns an empty query locator since no records need to be fetched
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Return an empty query as we're not fetching any existing records
        return Database.getQueryLocator([SELECT Id FROM Opportunity limit 1]);
    }

    // Execute method - creates and inserts 5 new Opportunities
    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<Opportunity> oppList = new List<Opportunity>();

        // Create 5 new Opportunities
        for (Integer i = 0; i < 5; i++) {
            oppList.add(new Opportunity(
                Name = 'Opportunity created from batch ---->>' + i,
                StageName = 'Prospecting',
                CloseDate = System.today()
            ));
        }

        if (!oppList.isEmpty()) {
            // Insert the new Opportunities using Database.insert with partial success
            List<Database.SaveResult> insRes = Database.insert(oppList, false);
            
            // Check the results of the insert operation
            for (Database.SaveResult ins : insRes) {
                if (ins.isSuccess()) {
                    System.debug('Inserted Opportunity Id: ' + ins.getId());
                } else {
                    // Loop through the errors if insertion failed
                    for (Database.Error err : ins.getErrors()) {
                        System.debug('Error in insert: ' + err.getMessage());
                    }
                }
            }
        } else {
            System.debug('No Opportunity to insert');
        }
    }

    // Finish method - called when the batch job finishes
    public void finish(Database.BatchableContext bc) {
        System.debug('Batch finished---------->');
    }
}
