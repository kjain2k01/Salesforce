public class ContactTriggerHandler {
    public static void afterInsert(List<Contact> newList){
        sendEmailAfterInsert(newList);
    }
    
    private static void sendEmailAfterInsert(List<Contact> contacts){
        List<Messaging.SingleEmailMessage> emailList= new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name='Contact Email'];
       
        for(Contact conObj : contacts){
        	if (conObj.Email != null) {
        		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        		mail.setTargetObjectId(conObj.Id);
        		mail.setSenderDisplayName('System Administrator');
        		mail.setUseSignature(false);
        		mail.setBccSender(false);
        		mail.setSaveAsActivity(false);
        		mail.setTemplateID(emailTemplate.Id);
        		mail.toAddresses = new String[]{conObj.Email};
        		System.debug(conObj.Email);
                emailList.add(mail);
        	}
        }
        
        if(emailList.size()>0){
        	Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
        
        	if (results[0].success)
			{
				System.debug('The email was sent successfully.');
			} else {
				System.debug('The email failed to send: '+ results[0].errors[0].message);
			}
        } 
    } 
}