public class contactSelector {
    public static List<Contact> fetchRelatedContacts(Set<Id> accountIds){
          List<Contact> contacts = [SELECT Id, Phone, AccountId FROM Contact WHERE AccountId IN : accountIds];
          return !contacts.isEmpty() ? contacts : NULL;
    }
}