public class createOpportunityByCallingApi {
    public static void createOpportunity(){
        try{
            string endPoint = '';
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            Http http = new Http();
            HttpResponse res = http.send(req);
            
            if(res.getStatusCode()==200){
                map<string,object>responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                string oppName = (string)responseMap.get('opportunityName');
                decimal oppAmount = (decimal)responseMap.get('opportunityAmount');
                date closeDate = Date.valueOf(responseMap.get('closeDate'));

                opportunity opp = new opportunity(name=oppName, amount=oppAmount, closeDate=closeDate);
                insert opp;
                system.debug('opportunity created successfully');
            }else
            {
                system.debug('Failed to create opportunity: '+res.getBody());
            }   
        }catch(Exception e){
            System.debug('Error occurred while creating opportunity: '+e.getMessage());
            return;
        }
    }
}