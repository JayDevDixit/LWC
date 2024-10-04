trigger AccountTrigger on Account (after insert,before delete,before insert,before update,after update,after delete) {
 //   if(Trigger.isInsert && Trigger.isAfter)
    //	accountTriggerHandler.afterInsert(Trigger.new);
   
    //if(Trigger.isDelete && Trigger.isAfter)
      //  accountTriggerHandler.afterDelete(Trigger.old);
 /*   if(Trigger.isDelete && Trigger.isBefore)
        accountTriggerHandler.beforeDelete(Trigger.old);
    
    if(Trigger.isInsert && Trigger.isBefore)
        accountTriggerHandler.beforeInsert(Trigger.new);
    if(Trigger.isUpdate && Trigger.isBefore)
         accountTriggerHandler.beforeUpdate(Trigger.new,Trigger.oldMap);
    system.debug('Trigger Run'); 
    */
   // if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter)
        //accountTriggerHandler.contactCreator(Trigger.new);

    //if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore)
       // accountTriggerHandler.validateSameName(Trigger.new);

   // if(Trigger.isDelete && Trigger.isBefore)
     //   accountTriggerHandler.checkContact(Trigger.old);
   // if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
   //     accountTriggerHandler.updateSalesReps(Trigger.new);
    /*  if(Trigger.isInsert && Trigger.isBefore)
          for(account acc : Trigger.new){
              acc.ShippingStreet = acc.BillingStreet;
              acc.ShippingCity = acc.BillingCity;
              acc.ShippingState = acc.BillingState;
              acc.ShippingPostalCode = acc.BillingPostalCode;
              acc.ShippingCountry = acc.BillingCountry;
          }*/
   // if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
      //  accountTriggerHandler.updateOpportunity(Trigger.new);
     //if(Trigger.isAfter && Trigger.isInsert)
       // accountTriggerHandler.sendEmailToAdmin(Trigger.new);
      // if(Trigger.isBefore && Trigger.isUpdate)
       //    accountTriggerHandler.sumOppAmount(Trigger.new);
    /*
    if(Trigger.isAfter){
        	if(Trigger.isUpdate)
           		TriggerUserCountHandler.updateCountHandler(Trigger.new);
    	if(Trigger.isDelete)
            TriggerUserCountHandler.deleteCountHandler(Trigger.old);
    }
    	if(Trigger.isBefore)
            TriggerUserCountHandler.beforeCountHandler(Trigger.new, Trigger.oldMap);

    if(Trigger.isUpdate && Trigger.isAfter)
        accountTriggerHandler.maintainCount(Trigger.oldmap);
    if(Trigger.isInsert && Trigger.isAfter){
        list<Account_Updation__c> acup = new list<Account_Updation__c>();
        for(account acc2 : Trigger.new){
        Account_Updation__c acc = new Account_Updation__c(name=acc2.name,Account__c=acc2.id,count__c=0);
            acup.add(acc);
        }
        insert acup;
       
    }*/
    //if(Trigger.isAfter && Trigger.isInsert)
    //accountTriggerHandler.createContacts(Trigger.new);
    // if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
    // accountTriggerHandler.createDefaults(Trigger.new);
    // }
}