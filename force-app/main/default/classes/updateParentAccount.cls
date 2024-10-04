public with sharing class updateParentAccount implements Queueable {
    public void execute(QueueableContext qc){
        account parentAccount = [select parentid from account where parentid != null limit 1];
        if(parentAccount == null){
            System.debug('Not a single parent id present so considering any 1 account to be a parent');
            parentAccount = [select id from account limit 1];
            parentAccount.ParentId = parentAccount.id;
        }
        list<account>accList = [select parentid from account where parentid=null and parentid != :parentAccount.ParentId];
        for(account acc : accList)
            acc.ParentId = parentAccount.Id;
        if(!accList.isEmpty())
        {
            update accList;
        }
    }
}