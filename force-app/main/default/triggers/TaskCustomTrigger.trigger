trigger TaskCustomTrigger on Task__c (after update,after delete,after insert,after undelete) {
    if(Trigger.isAfter && Trigger.isUpdate){
        TaskTriggerHandler.handleTaskUpdate(Trigger.oldMap,Trigger.newMap);
    }
    if(Trigger.isAfter && Trigger.isDelete){
        system.debug('Delete Trigger');
        TaskTriggerHandler.handleTaskDelete(Trigger.old);
    }
    if(Trigger.isAfter && Trigger.isInsert){
        system.debug('Insert Trigger task');
        TaskTriggerHandler.handleTaskInsert(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isUndelete){
        system.debug('After task undelete trigger');
        TaskTriggerHandler.handleTaskInsert(Trigger.new);
    }

}