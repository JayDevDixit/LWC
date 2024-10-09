public with sharing class FetchObjectField {
    @AuraEnabled
    public static list<sObject> fetchRecords(list<string>fieldNames,string objectName){
        system.debug(fieldNames);
        string query = 'SELECT '+String.join(fieldNames,', ')+' From '+objectName;
        List<sObject> records = Database.query(query);
        return records;
    }

    @AuraEnabled(cacheable = true)
    public static List<SObject> fetchInChunks(
        List<String> fieldNames,
        String objectName,
        String lastRecordId,
        Integer limitval,
        Datetime lastModifiedDate
    ) {
        String query = 'SELECT lastModifiedDate, ' + String.join(fieldNames, ', ') + ' FROM ' + objectName;
        // if (lastRecordId != null && lastRecordId != '') {
        //     query += ' WHERE Id > :lastRecordId';
        // }
        if (lastModifiedDate != null) {
            query += ' WHERE lastModifiedDate > :lastModifiedDate';
        }
        query += ' ORDER BY lastModifiedDate desc LIMIT ' + limitval;
        
        System.debug('Query: ' + query);

        List<SObject> records = Database.query(query);
        return records;
    }
}
