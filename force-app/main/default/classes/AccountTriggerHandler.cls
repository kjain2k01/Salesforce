public class AccountTriggerHandler { //NOPMD
    public static void beforeInsert(List<Account> accounts){
        updateRatingRelatedToIndustry(accounts, NULL);
        copyBillingToShipping(accounts);
    }
    
    public static void afterInsert(List<Account> accounts){
        //createRelatedContact(accounts);
        //createRelatedOpportunity(accounts);
        createRelatedContactOrOpportunity(accounts);
    }
    
    public static void beforeDelete(List<Account> oldList){ //NOPMD
        preventAccountDeletionWithActive(oldList);
        handleRecordDeletion(oldList);
       preventDeletionWithOpportunity(oldList);
    }
    
    public static void afterDelete(List<Account> oldList){ //NOPMD
        
    }
    
    public static void beforeUpdate(List<Account> newList, Map<Id, Account> oldMap){ //NOPMD
    	updateRatingRelatedToIndustry(newList, oldMap);
        copyBillingToShipping(newList, oldMap);
        updateDescription(newList, oldMap); 
        preventEditByCreateDate(newList, oldMap);
           
    }
    
    public static void afterUpdate(List<Account> newList, Map<Id, Account> oldMap){ //NOPMD
        updateRelatedContactPhone(newList, oldMap);
        updateRelatedContactMailingAdd(newList, oldMap);
        UpdateOppStageRelateToActive(newList, oldMap);
    }
    
    private static void updateRatingRelatedToIndustry(List<Account> accounts, Map<Id, Account> idToAccountMap){
        for(Account account : accounts){
            if(idToAccountMap != NULL &&  account.Industry != idToAccountMap.get(account.Id).Industry && account.Industry == 'Media'
            || account.Industry != NULL && account.Industry == 'Media'){
                account.Rating = 'Hot';
           	} 
        }
	}
    
    private static void copyBillingToShipping(List<Account> accounts, Map<Id, Account> idToAccountMap){ //NOPMD
           for(Account account : accounts){
            if(account.CopyBillingToShipping__c ){
                if(account.BillingStreet != NULL && account.BillingStreet != idToAccountMap.get(account.Id).BillingStreet){
                	account.ShippingStreet = account.BillingStreet;
                }
                if(account.BillingCity != NULL && account.BillingCity != idToAccountMap.get(account.Id).BillingCity){
                	account.ShippingCity = account.BillingCity;
                }
                if(account.BillingPostalCode != NULL && account.BillingPostalCode != idToAccountMap.get(account.Id).BillingPostalCode){	
                	account.ShippingPostalCode = account.BillingPostalCode;
                }
                if(account.BillingState != NULL && account.BillingState != idToAccountMap.get(account.Id).BillingState){
                	account.ShippingState = account.BillingState;
                }
				if(account.BillingState != NULL && account.BillingState != idToAccountMap.get(account.Id).BillingState){
                	account.ShippingCountry = account.BillingCountry; 
                }
            }
        }
    }

    private static void copyBillingToShipping(List<Account> accounts){ //NOPMD
        for(Account account : accounts){
            if(account.CopyBillingToShipping__c ){
                if(account.BillingStreet != NULL){
                	account.ShippingStreet = account.BillingStreet;
                }
                if(account.BillingCity != NULL){
                	account.ShippingCity = account.BillingCity;
                }
                if(account.BillingPostalCode != NULL){	
                	account.ShippingPostalCode = account.BillingPostalCode;
                }
                if(account.BillingState != NULL){
                	account.ShippingState = account.BillingState;
                }
				if(account.BillingState != NULL){
                	account.ShippingCountry = account.BillingCountry;
                }
            }
        }
    }
   
    private static void createRelatedContact(List<Account> accounts){
        List<Contact> contacts = AccountService.createContact(accounts);
        
        if(!contacts.isEmpty()) 
            insert contacts; //NOPMD
    }
    
    private static void updateDescription(List<Account> accounts, Map<Id, Account> idToAccountMap){ //NOPMD
        for(Account account : accounts){
            if(account.Phone != idToAccountMap.get(account.Id).Phone){
                account.Description = 'Phone number got updated old value : ' + idToAccountMap.get(account.Id).Phone + ' new value : ' + account.Phone;
            }
        }
    }

    private static void createRelatedOpportunity(List<Account> accounts){ //NOPMD
        List<Opportunity> opportunities = AccountService.createOpportunity(accounts);
        
        if(!opportunities.isEmpty()){
            insert opportunities; //NOPMD
        }
    }
    
    private static void createRelatedContactOrOpportunity(List<Account> accounts){ //NOPMD
        for(Account account : accounts){
            if(account.Contact__c){
                createRelatedContact(accounts);
            }
            
            if(account.Opportunity__c && account.Active__c == 'Yes'){
                createRelatedOpportunity(accounts);
            }
        }
    }

    /* TASK - 3 */
    private static void updateRelatedContactPhone(List<Account> accounts, Map<Id, Account> idToAccountMap){
        Map<Id, String> idToPhoneMap = new Map<Id, String>();

        for(Account account : accounts){
            if(account.Phone != idToAccountMap.get(account.Id).Phone){
                idToPhoneMap.put(account.Id, account.Phone); //all the accounts whose phone is updated
            }
        }
		
        if(idToPhoneMap.size() != 0){
        	List<Contact> contacts = AccountService.updateContactsPhone(idToPhoneMap);
            if(!contacts.isEmpty()){ //NOPMD
                update contacts;
            }
        }	       
    }

    /* Task - 5 */
    private static void updateRelatedContactMailingAdd(List<Account> accounts, Map<Id, Account> idToAccountMap){
        Map<Id, Account> idToUpdateAccountMap = new Map<Id, Account>();
        
        for(Account account : accounts){
            if(account.BillingCity != idToAccountMap.get(account.Id).BillingCity || account.BillingCountry != idToAccountMap.get(account.Id).BillingCountry ){/*
                || account.BillingPostalCode != idToAccountMap.get(account.Id).BillingPostalCode || account.BillingState != 
                idToAccountMap.get(account.Id).BillingState || account.BillingStreet != idToAccountMap.get(account.Id).BillingStreet){*/
                    idToUpdateAccountMap.put(account.Id, account); // map with updated a billing address                  
            }
        }
        if(idToUpdateAccountMap.size() != 0){
            List<Contact> contacts = AccountService.updateContactMailingAdd(idToUpdateAccountMap);
            if(!contacts.isEmpty()){
                update contacts;
            }
        }
    }
    /*Task - 8 */
    private static void UpdateOppStageRelateToActive(List<Account> accounts, Map<Id, Account> oldMap){
        Map<Id, Account> idToAccountMap = new Map<Id, Account>(); //list of all the updated account
        for(Account account : accounts){
            if(account.Active__c == 'Yes' && oldMap.get(account.Id).Active__c == 'No'){
                idToAccountMap.put(account.Id, account);
            }
        }

        if(idToAccountMap.size() != 0){
            List<Opportunity> opportunities = AccountService.UpdateOppStage(idToAccountMap);
            if(!opportunities.isEmpty()){
                update opportunities;
            }
        }
    }
    
    /*Task - 9*/
    private static void preventAccountDeletionWithActive(List<Account> accounts){
        for(Account account : accounts){
            if(account.Active__c == 'Yes'){
                account.addError('Active Accounts Cannot Be Deleted');
            }
        }
    }
    
    /*Task - 10 11*/
    private static void preventEditByCreateDate(List<Account> accounts, Map<Id, Account> idToAccountMap){
        for(Account account : accounts){
            if(account.CreatedDate < System.today().addDays(-4)){
                 account.addError('Accounts Cannot Be Editied');
            }
        }
    }
    
    /*Task - 13 */
    private static void handleRecordDeletion(List<Account> accounts){
        String currentUserId = UserInfo.getProfileId();
        String systemAdministratorId = [Select Id, Name from Profile where Name = 'System Administrator' Limit 1].Id;
        
        for(Account account : accounts){
            if(currentUserId != systemAdministratorId){
               account.addError('You Cannot Delete this record');
            }
        }
    }
    
    /* Task - 15 */
    private static void preventDeletionWithOpportunity(List<Account> accounts){
        List<Account> fetchedAccounts = AccountService.getRelatedOpportunities(accounts);
        System.debug(fetchedAccounts);
        for(Account account : fetchedAccounts){
            //System.debug(account.Opportunities.size());
            if(account.Opportunities.size() != 0){
                account.addError('You cannot Delete because of Related Opportunities');
            }
        }
    }
}