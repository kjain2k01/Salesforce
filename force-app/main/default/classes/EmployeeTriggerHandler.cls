public class EmployeeTriggerHandler {
    public static void beforeInsert(List<Employee__c> newList){
        updateActive(newList);
        getEmployeeCount(newList);
    }
    public static void afterDelete(List<Employee__c> oldList, Map<Id, Employee__c> oldMap){
        getLeftEmployee(oldList);
         
    }
    public static void afterInsert(List<Employee__c> newList){
        getEmployeeCount(newList);
    }
    
    private static void updateActive(List<Employee__c> employeeList){
        Set<Id> accountIds = new Set<Id>();
        for(Employee__c employee : employeeList){
            accountIds.add(employee.Account__c);
        }
        
        List<Account> accounts = EmployeeService.getRelatedAccount(accountIds);
        for(Account account : accounts){
            account.Active__c = 'Yes';
        }
        if(!accounts.isEmpty()){
            update accounts;
        }
    }
    
    private static void getLeftEmployee(List<Employee__c> employeeList){
        Set<Id> accountIds = new Set<Id>();
        for(Employee__c employee : employeeList){
            accountIds.add( employee.Account__c);
        }
        System.debug('getting left employee');
        List<Account> accounts = EmployeeService.getRelatedAccount(accountIds);
        
        for(Account account : accounts){    
            account.Left_Employee_Count__c = account.Employees__r.size();
        }
        
        if(!accounts.isEmpty()){
            update accounts;
        }
    }
    
    private static void getEmployeeCount(List<Employee__c> employeeList){
        Set<Id> accountIds = new Set<Id>();
        for(Employee__c employee : employeeList){
            accountIds.add( employee.Account__c);
        }
        List<Account> accounts = EmployeeService.getRelatedAccount(accountIds);
        for(Account account : accounts){
            System.debug(account.Id);
            account.NumberOfEmployees = account.Employees__r.size();
        }
        
        if(!accounts.isEmpty()){
            update accounts;
        }
    }
}