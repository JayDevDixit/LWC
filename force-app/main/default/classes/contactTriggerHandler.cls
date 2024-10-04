public class contactTriggerHandler {
    
  /*  public static void onCreation(List<contact>conList){
        List<contact>accIdFromContact=[select AccountId from contact];
        List<Account>accList=new List<Account>();
        for(contact con:conList){
            Account acc=[Select id,Name,contact_count__c from Account where id=:con.AccountId limit 1];
            if(acc.contact_count__c==NULL){
                acc.contact_count__c=1;
            }
            else{
                acc.contact_count__c=acc.contact_count__c+1;
            }
            accList.add(acc);
            
        }
        update accList;   
    }
    
    
   public static void setPhoneAsAccountPhone(list<contact> conList){
        
        set<id>idsAccount = new set<id>();
        for(contact con : conList)
            if(con.AccountId!=null)
            	idsAccount.add(con.AccountId);
        list<account>accList = [select id,Phone from account where id in :idsAccount];
        map<Id,Account> mp = new map<id,Account>();
		for(Account acc:accList)
			mp.put(acc.Id,acc);
       for(contact con:conList){
           if(con.AccountId!=null){
               con.OtherPhone = mp.get(con.AccountId).Phone;
           }
       }

       
    }
    public static void checkUnique(list<contact> conList){
        for(contact con : conList){
            list<contact> saveCon = [select id from contact where
                                    Email=:con.Email or mobilePhone=:con.MobilePhone or phone=:con.Phone];
            if(saveCon.size()>0)
                con.addError('Cannot insert duplicate record');
        	
        }
        
        
    }
    public static void addContactRelationship(list<contact> conList){
        list<Contact_Relationship__c> conRelationList = new list<Contact_Relationship__c>();
        for(contact con : conList)
            if(con.Contact_Relationship__c){
                Contact_Relationship__c cr = new Contact_Relationship__c();
                cr.Name = con.Name;
                cr.Contact__c = con.id;
                conRelationList.add(cr);
            }
        if(conRelationList.size()>0)
            insert conRelationList;
    }
  //  public static void handleChangeOwnerID(map<id,contact_relationship__c>oldmap,list<contact_relationship__c>newList){
        
  //  }
    public static void updateAccountName(list<contact>conList){
        set<id>accountids = new set<id>();
        for(contact con:conList)
            accountids.add(con.accountid);
        list<account>accList = [select name,id from account where id in :accountids];
        for(contact con:conList)
            for(account acc:accList)
            	if(con.accountid == acc.id)
            		acc.name = acc.name+con.lastname;
        update acclist;
    }
    
    
    public static void resetAccountName(list<contact>conList){
        set<id>accountids = new set<id>();
        for(contact con:conList)
            accountids.add(con.accountid);
        list<account>accList = [select name,id from account where id in :accountids];
        for(contact con:conList)
            for(account acc:accList)
            	if(con.accountid == acc.id)
            		acc.name = acc.name.substring(0,acc.name.length()-con.name.length());
        update acclist;
    }
    public static void fillMailingAddresswithAccountShippingAddress(list<contact>conList){
        set<id>accountids = new set<id>();
        for(contact con:conList)
            accountids.add(con.accountid);
        list<account>accList = [select shippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode,id from account where id in :accountids];
        for(contact con:conList)
            for(account acc:accList)
                if(con.accountid == acc.id){
                    con.MailingStreet = acc.ShippingStreet; 
                    con.mailingCity = acc.ShippingCity;
                    con.MailingCountry = acc.ShippingCountry;
                    con.MailingState = acc.ShippingState;
                    con.MailingPostalCode = acc.ShippingPostalCode;
                }
        
    }*/
    public static void checkAssociatedAccountMax10Contact(list<contact>conList){
        set<id>accountIds = new set<id>();
        map<id,integer> accountidVScontactcount = new map<id,integer>();
        // Not allow to insert contact associated with particular account more than contactLimit
        integer contactLimit = 10;

        for(contact con:conList)
            if(con.AccountId!=null){
                accountIds.add(con.AccountId);
                accountidVScontactcount.put(con.AccountId,0);
            }

        List<Contact>savedContacts = [select accountid from contact where accountid in :accountIds];
            system.debug(savedContacts);
        for(Contact con:savedContacts)
            accountidVScontactcount.put(con.AccountId,accountidVScontactcount.get(con.AccountId)+1);

        list<contact>deleteContactList = new list<contact>();
        list<id>accountIdToDelete = new list<id>();
        
        for(contact con:conList){
            if(con.accountid!=null && accountidVScontactcount.get(con.AccountId)>=contactLimit){
                // integer extraContacts = accountidVScontactcount.get(con.AccountId) - contactLimit;
                // list<contact> contactToDelete = [select id from contact where accountid =:con.AccountId limit :extraContacts];
                // if(!contactToDelete.isEmpty())
                //     deleteContactList.addAll(contactToDelete);
                accountIdToDelete.add(con.AccountId);
                system.debug('line 131');
            }
        }
        List<Account> accList = [Select id , (Select id , AccountId from contacts order by createdDate desc) from Account where id IN:accountIdToDelete];
        for(Account acc : accList){
            // deleteContactList.addAll(acc.contacts.subList(contactLimit, acc.contacts.size()));
            if (acc.contacts != null && acc.contacts.size() > contactLimit) {
                system.debug('line 138');
                // Slice the list from contactLimit to the end
                List<Contact> contactsToDelete = acc.contacts;
                
                // Add contacts to delete list
                system.debug(acc.contacts.size());
                for(integer i=contactLimit;i<contactsToDelete.size();i++){
                    deleteContactList.add(contactsToDelete[i]);
                    system.debug('Deleting'+i+' contacts----'+contactsToDelete.size());
                }
            }
        }
        try{   
        if(!deleteContactList.isEmpty()) 
                delete deleteContactList;
        }catch(Exception e){
            system.debug('Fail to delete contact list'+e.getMessage());
        }


        //----------------------
        // set<id> idOfContact = new set<id> ();

        // for(Contact con : conList){
        //     idOfContact.add(con.id);
        // }

        // System.debug('idOfContacts--->' + idOfContact);

        // set<id> accountsId = new set<id>();
        // for(Contact con : conList){
        //     accountsId.add(con.accountId);
        // }
        
        // List<Account> accList = [Select id , (Select id , AccountId from contacts) from Account where id IN:accountsId];
        
        // List<Contact> contactList = new List<Contact>();
        
        // for(Account acc : accList){
        //     contactList = acc.contacts;
        // }
        
        // System.debug('ContactList ---->' + contactList);
        // List<Contact> deleteContactList = new List<Contact>();
        
        // for(Integer i = 2 ; i < contactList.size() ; i++){
        //     deleteContactList.add(contactList[i]);
        // }
        
        // if(!deleteContactList.isEmpty()){
        //     delete deleteContactList; 
        // }
        
        // List<Contact> UpdatedconList = [Select id from contact where accountId IN:accountsId];
        // System.debug('UpdatedContactList--->'+  UpdatedconList);
        
    }           
    public static void checkMultipleContactInsertion(list<contact>conList){
        list<id>accountids = new list<id>();
        for(contact con:conList)
            if(con.AccountId!=null)
                accountids.add(con.AccountId);
        list<account>accList = [select id,Allow_Multiple__c,(select id from contacts) from account where id in :accountids];
        for(contact con:conList){
            for(account acc:accList){
                if(con.AccountId == acc.id && acc.Allow_Multiple__c == false && acc.contacts.size()>0){
                    con.addError('Cannot insert contact for this account. Multiple Contacts are not allowed');
                }
            }
        }
    }                                            
    }

