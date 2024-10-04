public with sharing class TaskTriggerHandler {
    public static void checkTasksUpdateMilestones(set<id> milestoneIds){
        // if milestoneIds set is empty that means no task is changed from incomplete -> complete or vice-versa which is also associated with any milestone
        // that means no need to do anything simply return
        if(milestoneIds.isEmpty()){
        system.debug('milestone list empty returning');
        return;
    }
    // if not empty then Save all milestone objects which need to update in the below list
    List<Milestone__c> milestonesToUpdate = new List<Milestone__c>();
    // Note: 'milestonesToUpdate' list may contain less number of records then 'milestones' list
    // because there are some records exist that already updated (that not need to update)
    List<Milestone__c> milestones = [SELECT Id, Status__c, 
    (SELECT Id, Status__c FROM Tasks__r)
    FROM Milestone__c WHERE Id IN :milestoneIds];

    for(Milestone__c milestone : milestones) {
        Boolean allTasksComplete = true;
        
        // Check if all tasks related to this milestone are complete
        for(Task__c task : milestone.Tasks__r) {
            // if there exist a task with incomplete status 
            if(task.Status__c != 'Complete') {
                allTasksComplete = false;
                system.debug('Incomplete Task found');
                break;
            }
        }
        // only if these conditions satisfy then only milestone required to update
        if(allTasksComplete && milestone.Status__c != 'Complete') {
            milestone.Status__c = 'Complete';
            milestonesToUpdate.add(milestone);
        }
        else if(!allTasksComplete && milestone.Status__c != 'Incomplete'){
            milestone.Status__c = 'Incomplete';
            milestonesToUpdate.add(milestone);
        }
    }
    if(!milestonesToUpdate.isEmpty()) {
        update milestonesToUpdate;
    }
    

}

public static void handleIncompleteTaskInsert(set<id> milestoneIds){
    if(milestoneIds.isEmpty())
        return;
    // Here incomplete task is inserted in a milestone that means change all the milestone status to incomplete
    // no need to check anything
    List<Milestone__c> milestonesToUpdate = new List<Milestone__c>();
    
    // Query the related milestones
    List<Milestone__c> milestones = [SELECT Id, Status__c FROM Milestone__c WHERE Id IN :milestoneIds];
    
    // Update each milestone's status to 'Incomplete' if needed
    for(Milestone__c milestone : milestones) {
        if(milestone.Status__c != 'Incomplete') {
            milestone.Status__c = 'Incomplete';
            milestonesToUpdate.add(milestone);
        }
    }
    
    if(!milestonesToUpdate.isEmpty()) {
        update milestonesToUpdate;
    }
}
public static void handleCompleteTaskInsert(set<id> milestoneIds){
    if(milestoneIds.isEmpty())
        return;
    // if a milestone contain no task then a complete task is inserted in it then update milstone status to complete.
    // if a milestone contain more than 1 task then no need to do anything
    system.debug('Complete milestone inserted');
    List<Milestone__c> milestones = [SELECT Id, Status__c, 
    (SELECT Id, Status__c FROM Tasks__r)
    FROM Milestone__c WHERE Id IN :milestoneIds];
    for(Milestone__c milestone : milestones)
        if(milestone.Tasks__r.size()==1){
            system.debug('size 1');
            milestone.Status__c = 'Complete';
        }
    update milestones;

}


    public static void handleTaskUpdate(map<id,Task__c> taskOldMap,map<id,Task__c> taskNewMap){
        // from this ids set we will fetch all milestones whose task status is updated.
        set<id>milestoneIds = new set<id>();
        for(Task__c task:taskNewMap.values())
            if(taskOldMap.get(task.id).Status__c!= taskNewMap.get(task.id).Status__c && task.MilestoneId__c != null)
                milestoneIds.add(task.MilestoneId__c);
            checkTasksUpdateMilestones(milestoneIds);
    }


    public static void handleTaskDelete(list<Task__c> taskList){
        // from this ids set we will fetch all milestones whose task status is updated to complete
        set<id>milestoneIds = new set<id>();
        // if incomplete task is deleted check remaining tasks for complete
        for(Task__c task:taskList)
            if(task.status__c != 'Complete' && task.MilestoneId__c != null)
                milestoneIds.add(task.MilestoneId__c);
            checkTasksUpdateMilestones(milestoneIds);

    }

    public static void handleTaskInsert(list<Task__c> taskList){
        Set<Id> IncompleteMilestoneIds = new Set<Id>();
        Set<Id> completeMilestoneIds = new Set<Id>();
    
    // Collect milestone ids for incomplete tasks being inserted
    for(Task__c task : taskList){
        if (task.Status__c != 'Complete' && task.MilestoneId__c != null) {
            IncompleteMilestoneIds.add(task.MilestoneId__c);
        }
        else if (task.Status__c == 'Complete' && task.MilestoneId__c != null){
            completeMilestoneIds.add(task.MilestoneId__c);
        }
    }
    
    handleIncompleteTaskInsert(IncompleteMilestoneIds);
    handleCompleteTaskInsert(completeMilestoneIds);

}

   
}