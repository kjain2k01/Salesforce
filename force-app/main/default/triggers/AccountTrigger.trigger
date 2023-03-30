trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete){ //NOPMD
    
    switch on Trigger.OperationType{
        when BEFORE_INSERT{
            AccountTriggerHandler.beforeInsert(trigger.new);
        }
        
        when BEFORE_UPDATE{
			AccountTriggerHandler.beforeUpdate(trigger.new, trigger.oldMap);	
        }
        
        when BEFORE_DELETE{
            AccountTriggerHandler.beforeDelete(trigger.old);
        }
        
        when AFTER_INSERT{
            AccountTriggerHandler.afterInsert(Trigger.new);
        }
        
        when AFTER_UPDATE{
            AccountTriggerHandler.afterUpdate(trigger.new, trigger.oldMap);
        }
        
        when AFTER_DELETE{
        	    
        }
    }
}