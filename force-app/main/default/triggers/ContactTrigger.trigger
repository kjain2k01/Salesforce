trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after delete, after update) {
    switch on Trigger.OperationType{
        when BEFORE_INSERT{
            
        }
        when AFTER_INSERT{
           ContactTriggerHandler.afterInsert(trigger.new); 
        }
        when BEFORE_DELETE{
            
        }
        when AFTER_DELETE{
            
        }
        when BEFORE_UPDATE{
            
        }
        when AFTER_UPDATE{
            
        }
    }
}