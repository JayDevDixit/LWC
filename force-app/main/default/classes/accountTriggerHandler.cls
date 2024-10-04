public class accountTriggerHandler {
    public static void afterInsert(list<account> accountList){
        list<contact>contactList = new list<contact>();
        try{
            for(account acc:accountList){
                system.debug('Contact Created');
                contact con = new Contact();
                con.FirstName = 'Dummy First Name';
                con.LastName = 'Dummy Last Name';
                con.AccountId = acc.id;
				contactList.add(con);
            }
            if(!contactList.isEmpty()){
                insert contactList;
                system.debug('Contact inserted');
            }
            
        }catch(Exception e){
            system.debug('Exception '+e.getMessage());
        }

        list<opportunity> oppList = new list<opportunity>();
        integer k =0;
        for(account acc : accountList){
            opportunity opp = new opportunity();
            opp.Name = 'Dummy opportunity name';
            opp.CloseDate = System.today().addDays(k);
            opp.StageName = 'Prospecting';
            opp.AccountId = acc.id;
            oppList.add(opp);
            k+=1;
            if(acc.Active__c == 'No')
                acc.addError('Active status cannot be No');
        }
        insert oppList;
        list<contact> conList = new list<contact>();
        for(account acc : accountList){
            if(acc.Industry == 'Banking'){
                contact con = new contact();
                con.LastName = acc.Name;
                con.Phone = acc.Phone;
                con.AccountId = acc.id;
                conList.add(con);
            }
        }
        insert conList;
    }
    
    public static void afterDelete(list<account> accList){
        try{
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            for(Account acc:accList){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> sendTo = new List<String>();
                sendTo.add('jay.dixit@cloudanalogy.com');
                mail.setToAddresses(sendTo);
                mail.setSubject('Deletion of an account');
                String body = 'Dear '+UserInfo.getName() +',';
                body += '<br/> Your account is deleted ' + acc.Name;
                mail.setHtmlBody(body);
                mailList.add(mail);
}
Messaging.sendEmail(mailList);
}
catch(Exception e){
System.debug(e.getMessage());
}
    }
    
   
    public static void beforeDelete(list<account> accList){
        for(account acc : accList){
            if(acc.Active__c == 'Yes')
                acc.addError('Active Account Cannot be Deleted');
        }
    }
    
    
    public static void beforeInsert(list<account> accList){
        for(account acc : accList){
            if(acc.Industry == null)
                acc.addError('Enter Industry, it cannot be null');
            else if(acc.Industry == 'Media')
                acc.Rating = 'Hot';
            else
                acc.Rating = 'Cold';
        }
    }
    
    public static void beforeUpdate(list<account> accList,map<id,account>accMap){
        for(account acc : accList)
            if(acc.Phone != accMap.get(acc.id).Phone){
                if(acc.Phone==null)
                	acc.Phone.addError('Phone cannot be empty');
                else
                	acc.Description = 'Phone updated successfully';
            
            }
            
        

    }
    public static void contactCreator(list<account> accList){
        list<contact> conList = new list<contact>();
        list<contact> alreadyInserted = [select accountid from contact where accountid in :accList];
        for(account acc : accList)
            if(acc.NumberofLocations__c != null)
                if(acc.NumberofLocations__c-alreadyInserted.size() > 0)
                for(integer i=1;i<=acc.NumberofLocations__c-alreadyInserted.size();i+=1){
                    contact con = new Contact();
                    con.FirstName = 'Dummy First Name '+i;
                    con.LastName = 'Dummy Last Name '+i;
                    con.AccountId = acc.id;
                    conList.add(con);
                    
                }
                
            
        insert conList;
    }

    public static void validateSameName(list<account> accList){
        list<account>saveAccountList = [select name from account];
        for(account newAcc : accList)
           for(account saveAcc : saveAccountList)
            	if(newAcc.Name == saveAcc.Name)
            		newAcc.addError('The name Duplicate Account already exists.');
    }
    public static void checkContact(list<account> accList){
        try{
        	set<id>idAccounts = new set<id>();
            for(account acc : accList)
                idAccounts.add(acc.id);
            map<id,Integer> mp = new map<id,Integer>();
			List<Account>newAccList = [select id,(select id from contacts) from Account where id in :idAccounts];
            for(Account acc: newAccList)
       			mp.put(acc.Id,(acc.Contacts).size());
            for(Account acc: accList)
            if(mp.get(acc.Id)!=0)
                acc.addError('Account cannot be deleted because it has associated Contacts.');

        
        }catch(Exception e){
            system.debug(e.getMessage());
        }
    }
    public static void updateSalesReps(list<account>accList){
        map<id,string>accOwnerName = new map<id,string>();
        for(account acc : accList)
            accOwnerName.put(acc.OwnerId,'');
        list<user>ownerList = [select id,name from user where id in :accOwnerName.keyset()];
        for(user u : ownerList)
            accOwnerName.put(u.id,u.name);
        for(account acc : accList)
            if(accOwnerName.containsKey(acc.OwnerId))
            	acc.Sales_Rep__c = accOwnerName.get(acc.OwnerId);
    }
    
    public static void updateOpportunity(list<Account>accList){
        set<id>accountIds = new set<id>();
        for(account acc : accList)
            accountIds.add(acc.id);
        list<opportunity>oppList = [select id from opportunity
                                    where accountid in :accountIds
                                   and closeDate < :system.Today().addDays(-30)
                                   and stageName != 'Closed Won'];
    	for(opportunity opp : oppList)
            opp.StageName = 'Closed Lost';
        update oppList;
    }
    public static void sendEmailToAdmin(list<Account>accList){
        user adminUser = [select id,email from user
                         where profile.name='System Administrator' and isActive=true limit 1];
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
    for (Account acc : accList) {
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    List<String> sendTo = new List<String>();
    sendTo.add('jay.dixit@cloudanalogy.com');
    mail.setToAddresses(sendTo);
    mail.setSubject('Account Creation');
    String Body = 'A new account has been created with name ' + acc.name;
    mail.setHtmlBody(Body);
    emails.add(mail);
    }
    if (!emails.isEmpty()){
    Messaging.sendEmail(emails);
    System.debug(emails);
    system.debug('sended');
    }
    }
    public static void sumOppAmount(list<account>accList){
        list<aggregateResult> agrList = [select sum(amount) totalAmount,accountId
                                        from opportunity where accountid in :accList
                                        group by accountid];
        map<id,decimal> idVSamount = new map<id,decimal>();
        for(aggregateResult agr : agrList)
            idVSamount.put((id)agr.get('accountid'),(decimal)agr.get('totalAmount'));
        for(account acc : accList)
            acc.Total_Quantity__c = idVSamount.get(acc.id);
    }
    public static void maintainCount(map<id,account>idVSaccount){
        list<Account_Updation__c> accUpd = [select Account__c,count__c,name from Account_Updation__c];
        for(Account_Updation__c au : accUpd)
            for(id accid : idVSaccount.keySet())
        		if(au.Account__c == accid)
            		au.count__c+=1;
        update accUpd;
    }

    public static void createContacts(list<account>accList){
        list<contact>conList = new list<contact>();
        system.debug('class run');
        for(account acc : accList)
            for(integer i=0;i<acc.No_of_Employee__c;i++){
                contact con = new contact();
                con.FirstName = 'Trigger inserted First Name '+i;
                con.LastName = 'Trigger inserted Last Name '+i;
                con.Email = 'Triggerinserted'+i+'rio@example.com';
                con.AccountId = acc.id;
                conList.add(con);
                system.debug('contact created'+con);
            }
        insert conList;
        
    }
    
    public static void createDefaults(List<account>accList){
        list<contact>conList = new list<contact>();
        list<opportunity>oppList = new list<opportunity>();
        list<case>caseList = new list<case>();
        system.debug('line 231');
        for(account acc : accList){
            if(acc.No_of_Employee__c <= 100)
                continue;
            contact con = new contact(lastname='Default Contact',AccountId=acc.id);
            opportunity opp = new opportunity(name='Default Opportunity',accountid=acc.id,CloseDate=Date.today().addDays(30),StageName='Closed Won');
            conList.add(con);
            oppList.add(opp);
        }
        insert conList;
        insert oppList;
        system.debug('line 242');
        list<OpportunityContactRole> ocrList = new list<OpportunityContactRole>();
        for(integer i=0;i<conList.size();i++){
            case c = new case(ContactId=conList[i].id,AccountId=conList[i].AccountId,Status='New',Origin='Phone');
            OpportunityContactRole ocr = new OpportunityContactRole(contactId=conList[i].id,OpportunityId=oppList[i].id,IsPrimary=true,Role='Other');
            caseList.add(c);
            ocrList.add(ocr);
        }
        insert caseList;
        insert ocrList;
    }
}