public with sharing class whatsappMessageService {
  private static final String BASE_URL = 'https://graph.facebook.com/v20.0/490966720759591/messages';
  private static final String ACCESS_TOKEN = 'EAAPQBmCsnd8BOZCfQGwQ4lgqSNphKtfosPF9CCZCw9VmEKqEseXAY7cP7HorZBkCFzHCXhdn1pfVZCRDYcUXZBZAHXcR45McUFRXVCsVLuCskpD8hgV7FFaiPpMO1sUuH4qp9KZBkQ7JwKZAWCFXCr3tjFs1YsMtH7u6v3Qd9amZCdGCvrmMZBXNq829ikorpn7ZAJvo8lxBvitietBEmIHz4Ibfo5fZBxux1TBvhFgZD';
  @AuraEnabled
  public static string sendMessage(string message){
    try{
    if(message == '')
    return 'Message cannot be empty';


    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(BASE_URL);
    request.setMethod('POST');
    request.setHeader('Authorization', 'Bearer '+ ACCESS_TOKEN);
    request.setHeader('Content-Type', 'application/json');
    string phoneNumber = '917599001744';
    string templateName = 'hello_world';
    // string message = 'Hello this is a custom message';
    // String requestBody = '{"messaging_product": "whatsapp", "to": "' + recipientNumber + '", "type": "template", "template": {"name": "' + templateName + '", "language": {"code": "en_US"}}}';
    String jsonBody = JSON.serialize(new Map<String, Object>{
      'messaging_product' => 'whatsapp',
      'to' => phoneNumber,
      'type' => 'text',
      'text' => new Map<String, String>{
          'body' => message
      }
  });
  request.setBody(jsonBody);
  whatsapp_Message__c whatsapp = new whatsapp_Message__c();

    HttpResponse response = http.send(request);
    if(response.getStatusCode() == 200){
      system.debug('Message sent successfully : '+response.getBody());
      whatsapp.Message_Content__c = message;
      whatsapp.Customer_Phone__c = phoneNumber;
      whatsapp.MessageSentTime__c = System.now();
      whatsapp.isSent__c = 'true';
      whatsapp.Name = 'Test User';
      try{
      insert whatsapp;
      }catch(Exception e){
        return 'insert fail '+e.getMessage();
      }
      return 'Success';
    }else{
      system.debug('Error sending message : status code = '+response.getStatus()+'===body==> '+response.getBody());
      return 'Fail-status code= '+response.getStatus();
    }
  }catch(Exception e){
    system.debug('Error in sendMessage method : '+e.getMessage());
    return 'Fail-'+e.getMessage();
  }
    
  }

  @AuraEnabled(cacheable=true)
  public static List<whatsapp_Message__c> getMessages(){
    try {
      system.debug('--------------run again------');
      return [select id,MessageID__c,MessageType__c,name,Message_Content__c,MessageSentTime__c,isSent__c,Customer_Phone__c from whatsapp_Message__c order by createdDate];
      
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}