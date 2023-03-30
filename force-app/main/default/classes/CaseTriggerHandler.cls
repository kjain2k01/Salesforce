public class CaseTriggerHandler { //NOPMD
    public static void afterInsert(List<Case> newList){
	     //populateAccount(cases);
	     populateAccountWithCaseType(newList);
    }
    
    public static void beforeDelete(List<Case> oldList){ //NOPMD
        
    }
    
    public static void afterDelete(List<Case> oldList){ //NOPMD
        
    }
    
    public static void beforeUpdate(List<Case> newList, Map<Id, Case> oldMap){ //NOPMD
        
    }
    
    public static void afterUpdate(List<Case> newList, Map<Id, Case> oldMap){ //NOPMD
        
    }
    
    private static void populateAccount(List<Case> cases){
        
        List<Account> accounts = CaseService.createAccount(cases);
        
        if(!accounts.isEmpty()) 
        	update accounts; //NOPMD
    }
    
    /*Task 22*/
    private static void populateAccountWithCaseType(List<Case> cases){
        Set<Id> accountIds = new Set<Id>();
        
        for(Case currentCase : cases){
            accountIds.add(currentCase.AccountId);
        }
        List<Account> accounts = CaseService.getRelatedAccount(accountIds);
        
        for(Account account : accounts){
            
            for(Case currentCase : account.Cases){
                if(account.Id == currentCase.AccountId && currentCase.Type == 'Partner Case'){
                    if(account.Total_Partner_Case__c == NULL){
                        account.Total_Partner_Case__c = 0;
                    }
                    
                    account.Total_Partner_Case__c += 1;
                }
                if(account.Id == currentCase.AccountId && currentCase.Type == 'Customer Case'){
                     if(account.Total_Customer_Case__c == NULL){
                        account.Total_Customer_Case__c = 0;
                    }
                    account.Total_Customer_Case__c += 1;
                }
            }
        }
        
        if(!accounts.isEmpty()){
            update accounts;
        }
    }
}