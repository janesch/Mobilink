CREATE  OR REPLACE  TRIGGER ML_TT_ClearEvent
	GROUP primary_only
	DEBUG  FALSE  
	ENABLED  TRUE   
	PRIORITY 10
COMMENT 'This triigger is to clear events when an associated TT is RESOLVED\n\n20110915   Chris Janes   Original'
 BEFORE    UPDATE ON alerts.status
FOR EACH  ROW  

BEGIN

	If old.TicketStatus <> new.TicketStatus and new.TicketStatus = 'RESOLVED' and new.Severity > 1
	then
		Set new.Severity = 0;
	end if;

END;