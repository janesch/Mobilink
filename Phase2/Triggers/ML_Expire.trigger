	for each row expire in alerts.status where expire.ExpireTime > 0 and expire.Severity > 0
	begin
		update alerts.status via expire.Identifier set Severity = 0, ExpireID = 65532, ClearTime = getdate() where LastOccurrence < (getdate() - expire.ExpireTime);
	end;