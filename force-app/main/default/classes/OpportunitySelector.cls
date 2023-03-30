public class OpportunitySelector {
    public static List<Opportunity> fetchRelatedOpportunity(Set<Id> accountIds){
          List<Opportunity> opp = [SELECT Id, StageName, AccountId FROM Opportunity WHERE AccountId IN : accountIds];
          return opp;
    }
    
    public static List<Account> fetchAccountRelatedOpportunity(Set<Id> accountIds){
        //Using parent-child soql
        System.debug('accountIds'+accountIds);
        List<Account> accounts = [SELECT Id,Name, (SELECT Id, AccountId FROM Opportunities) FROM ACCOUNT WHERE Id IN: accountIds];
        System.debug('accounts'+accounts);
        return accounts;
    }
}// [Select Id, Name, (Select AccountId, Name, StageName From Opportunities)From Account Where Id In :setacc];