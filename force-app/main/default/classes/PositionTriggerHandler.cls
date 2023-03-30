public class PositionTriggerHandler { 
    public static void beforeInsert(List<Position__c> positions){ //NOPMD
        PositionTriggerHandler.populatePosition(positions);
    }
     public static void beforeDelete(List<Account> oldList){ //NOPMD
        
    }
    
    public static void afterDelete(List<Account> oldList){ //NOPMD
        
    }
    
    public static void beforeUpdate(List<Account> newList, Map<Id, Account> oldMap){ //NOPMD
        
    }
    
    public static void afterUpdate(List<Account> newList, Map<Id, Account> oldMap){ //NOPMD
        
    }
    private static void populatePosition(List<Position__c> Positions){ //NOPMD
        for(Position__c position : Positions){
            if(position.Open_Date__c == NULL && position.Max_Pay__c == NULL && position.Min_Pay__c == NULL){
                position.Min_Pay__c = 10000;
                position.Max_Pay__c = 15000;
                position.Open_Date__c = System.today();
            }
        }
    }
}