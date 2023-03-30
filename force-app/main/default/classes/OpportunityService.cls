public class OpportunityService {
    public static List<Account> accountSelector(List<Opportunity> opportunities){
        List<Account> accounts = new List<Account>();
        for(Opportunity opp : opportunities){
            if(opp.Amount != NULL && opp.AccountId != NULL){
                Account account = new Account();
                account.Id = opp.AccountId;
                account.Latest_Opp_Amount__c = opp.Amount;
                accounts.add(account);
            }
        }
        return accounts;
    }
}