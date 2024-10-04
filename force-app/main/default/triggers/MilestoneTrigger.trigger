trigger MilestoneTrigger on Milestone__c (after update, after delete, after insert, after undelete) {
    if(Trigger.isAfter && Trigger.isUpdate){
        MilestoneTriggerHandler.handleMilestoneUpdate(Trigger.oldMap, Trigger.newMap);
    }
    if(Trigger.isAfter && Trigger.isDelete){
        system.debug('Delete Trigger Milestone');
        MilestoneTriggerHandler.handleMilestoneDelete(Trigger.old);
    }
    if(Trigger.isAfter && Trigger.isInsert){
        system.debug('Insert Trigger Milestone');
        MilestoneTriggerHandler.handleMilestoneInsert(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isUndelete){
        system.debug('After Milestone Undelete Trigger');
        MilestoneTriggerHandler.handleMilestoneInsert(Trigger.new);
    }
}
