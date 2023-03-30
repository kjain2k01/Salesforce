public class AccountService {
    public static List<Contact> createContact(List<Account> accounts){
        List<Contact> contacts = new List<Contact>();
        for(Account account : accounts){
            Contact contact = new Contact();
           	contact.LastName = account.Name;
            contact.AccountId = account.Id;
            contacts.add(contact);
        }
        return contacts;
    }

    public static List<Opportunity> createOpportunity(List<Account> accounts){
        List<Opportunity> opportunities = new List<Opportunity>();
        for(Account account : accounts){
        	Opportunity opp = new Opportunity();
        	opp.AccountId = account.Id;
        	opp.Name = account.Name;
        	opp.StageName = 'Qualification';
            opp.CloseDate = System.Today();
            opportunities.add(opp);
        }
        return opportunities;
    }

    public static List<Contact> updateContactsPhone(Map<Id, String> idToPhoneMap){

        List<Contact> contacts = contactSelector.fetchRelatedContacts(idToPhoneMap.keySet());
        
        for(Contact contact : contacts){
            contact.phone = idToPhoneMap.get(contact.AccountId);
            
        }
		
        if(!contacts.isEmpty())
        	return contacts;
        return NULL;
    }

    public static List<Contact> updateContactMailingAdd(Map<Id, Account> idToAccountMap){
        List<Contact> contacts = contactSelector.fetchRelatedContacts(idToAccountMap.keySet());

        for(Contact contact : contacts){
            contact.MailingStreet = idToAccountMap.get(contact.AccountId).BillingStreet;
            contact.MailingCity = idToAccountMap.get(contact.AccountId).BillingCity;
            contact.MailingCountry = idToAccountMap.get(contact.AccountId).BillingCountry;
            contact.MailingPostalCode = idToAccountMap.get(contact.AccountId).BillingPostalCode;
            contact.MailingState = idToAccountMap.get(contact.AccountId).BillingState;
        }

        if(!contacts.isEmpty()){
            return contacts;
        }
        return null;
    }
    
    public static List<Opportunity> UpdateOppStage(Map<Id, Account> idToAccountMap){
        List<Opportunity> opportunities = OpportunitySelector.fetchRelatedOpportunity(idToAccountMap.keySet());
        
        for(Opportunity opportunity : opportunities){
            if(opportunity.StageName != 'Closed Won'){
                opportunity.StageName = 'Closed Lost';
            }
        }
        
        return opportunities;
    }
    
    public static List<Account> getRelatedOpportunities(List<Account> accounts){
        Set<Id> accountIds = new Set<Id>();
        
        for(Account account : accounts){
            accountIds.add(account.Id);
        }
        
        List<Account> accountWithRelatedOpp = OpportunitySelector.fetchAccountRelatedOpportunity(accountIds);
        if(accountWithRelatedOpp.isEmpty()){
            return NULL;
        }
        
        return accountWithRelatedOpp;
     }
}