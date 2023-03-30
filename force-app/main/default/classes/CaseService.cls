public class CaseService {
    public static List<Account> createAccount(List<Case> cases){
         List<Account> accounts = new List<Account>();
        	for(Case currentCase : cases){
            Account account = new Account();
            account.Id = currentCase.AccountId;
            account.Latest_Case_Num__c = currentCase.CaseNumber;
            accounts.add(account);
        }
        return accounts;
    }
    
    public static List<Account> getRelatedAccount(Set<Id> accountIds){
        List<Account> accounts = AccountSelector.fetchCasesRelatedAccount(accountIds);
        return accounts;
    }
}