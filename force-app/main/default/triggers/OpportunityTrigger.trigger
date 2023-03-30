trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete) { //NOPMD
    switch on Trigger.operationType{
        when BEFORE_INSERT{
        	OpportunityTriggerHandler.beforeInsert(trigger.new);    
        } 
        when BEFORE_UPDATE{
			OpportunityTriggerHandler.beforeUpdate(trigger.new, trigger.oldMap);
        }
        
        when BEFORE_DELETE{
            OpportunityTriggerHandler.beforeDelete(trigger.old);
        }
        
        when AFTER_INSERT{
            OpportunityTriggerHandler.afterInsert(trigger.new);
        }
        
        when AFTER_UPDATE{
            
        }
        
        when AFTER_DELETE{
            
        }
    }
}