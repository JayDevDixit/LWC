public with sharing class FetchObjectField {
    @AuraEnabled
    public static list<sObject> fetchRecords(list<string>fieldNames,string objectName){
        string query = 'SELECT '+String.join(fieldNames,', ')+' From '+objectName;
        List<sObject> records = Database.query(query);
        return records;
    }

    @AuraEnabled(cacheable = true)
    public static list<sObject> fetchInChunks(list<string>fieldNames,string objectName,integer offsetval,integer limitval ){
        string query = 'SELECT '+String.join(fieldNames,', ')+' FROM '+objectName+' limit '+limitval+' OFFSET '+offsetval;
        system.debug(query);
        list<sObject> records = Database.query(query);
        return records;
    } 
}
