public class AccountSelector {
    public static List<Account> fetchRelatedAccounts(Set<Id> accIds){
        List<Account> accounts = [SELECT Id, NumberOfEmployees, Left_Employee_Count__c FROM ACCOUNT WHERE Id IN : accIds];
        return !accounts.isEmpty() ? accounts : NULL;
    }
    
    public static List<Account> fetchCasesRelatedAccount(Set<Id> accIds){
        List<Account> accounts = [SELECT Id, Total_Partner_Case__c,Total_Customer_Case__c, (SELECT Id, AccountId, Type FROM Cases) FROM ACCOUNT WHERE ID IN: accIds];
        return !accounts.isEmpty() ? accounts : NULL;
    }	
}