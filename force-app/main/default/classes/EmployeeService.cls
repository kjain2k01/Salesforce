public class EmployeeService {
    public static List<Account> getRelatedAccount(Set<Id> ids){
        List<Account> accounts = AccountSelector.fetchRelatedAccounts(ids);
        return !accounts.isEmpty() ? accounts : NULL;
    }
}