trigger CaseTrigger on Case (before insert, before update, before delete, after insert, after update, after delete) { //NOPMD

    switch on Trigger.OperationType{
        when BEFORE_INSERT{
            
        }
        
        when BEFORE_UPDATE{

        }
        
        when BEFORE_DELETE{
            
        }
        
        when AFTER_INSERT{
            CaseTriggerHandler.afterInsert(Trigger.new);
        }
        
        when AFTER_UPDATE{
            
        }
        
        when AFTER_DELETE{
        	    
        }
    }
}