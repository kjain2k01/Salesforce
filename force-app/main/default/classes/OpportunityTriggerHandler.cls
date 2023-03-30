public class OpportunityTriggerHandler { //NOPMD
    public static void beforeInsert(List<Opportunity> opportunityList){
        updateDescription(opportunityList, NULL);
    }
    
    public static void afterInsert(List<Opportunity> opportunities){
        populateLatestOppAmount(opportunities);
    }
    
     public static void beforeDelete(List<Opportunity> oldList){ //NOPMD
		preventDeletionToClosed(oldList);        
    }
    
    public static void afterDelete(List<Opportunity> oldList){ //NOPMD
        
    }
    
    public static void beforeUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap){ //NOPMD
        updateDescription(newList, oldMap);
        populateErrorOnStageName(newList, oldMap);
    }
    
    public static void afterUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap){ //NOPMD
        
    }
    
    private static void updateDescription(List<Opportunity> opportunityList, Map<Id, Opportunity> idToOppMap){
        //fetch all the records where amount is not null and greater than 100000      
		for(Opportunity opportunity : opportunityList){
            if(opportunity.Amount != null && opportunity.Amount > 10000){
                opportunity.Description = 'Hot Opportunity';
            }
        }
        
		for(Opportunity opportunity : opportunityList){
            if((idToOppMap != NULL && opportunity.StageName != NULL && opportunity.StageName == 'Closed Won' && idToOppMap.get(opportunity.Id).StageName != opportunity.StageName)
               ||  (idToOppMap == NULL && opportunity.StageName != NULL && opportunity.StageName == 'Closed Won')){
                   opportunity.Description = 'Opportunity is Won';
               }
            else if((idToOppMap != NULL && opportunity.StageName != NULL && opportunity.StageName == 'Closed Lost' && idToOppMap.get(opportunity.Id).StageName != opportunity.StageName)
               ||  (idToOppMap == NULL && opportunity.StageName != NULL && opportunity.StageName == 'Closed Lost')){
                   opportunity.Description = 'Opportunity is Closed Lost';
               }
            else if((idToOppMap != NULL && opportunity.StageName != NULL && idToOppMap.get(opportunity.Id).StageName != opportunity.StageName)
               || (idToOppMap == NULL && opportunity.StageName != NULL)){
                   opportunity.Description = 'Opportunity is Open';
               }
        }
    }
    private static void populateLatestOppAmount(List<Opportunity> opportunities){
        List<Account> accounts = OpportunityService.accountSelector(opportunities);
        
        if(!accounts.isEmpty())
        	update accounts; //NOPMD
    }
	/* 	When an opportunity is updated to Closed Lost and 
		Closed Lost Reason (field) is not populated then throw validation
		error that 'Please populate Closed Lost Reason' on opportunity. [before update]*/
    
    private static void populateErrorOnStageName(List<Opportunity> opportunities, Map<Id, Opportunity> idToOppMap){
        //if stage is closed Lost -- and Closed_Lost_Reason__c is empty ---> add Error
        for(Opportunity opp : opportunities){
            if(opp.StageName != idToOppMap.get(opp.Id).StageName && opp.StageName == 'CLosed Lost' && opp.Closed_Lost_Reason__c == NULL){
                opp.addError('Please populate Closed Lost Reason');
            }
        }
    }
    
    /*Task 14*/
    private static void preventDeletionToClosed(List<Opportunity> opportunities){
        String currentUserId = UserInfo.getProfileId();
        Id systemAdministratorId = [Select Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
        
        for(Opportunity opp : opportunities){
            if(currentUserId != systemAdministratorId){
                opp.addError('You cannot delete this record');
            }
        }
    }
}