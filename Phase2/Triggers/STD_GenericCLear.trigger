





	-- Populate a table with Type 1 events corresponding to any uncleared Type 2 events
	for each row problem in alerts.status where
				problem.Type = 1 and problem.Severity > 0 and
                                (problem.Node + problem.AlertKey + problem.AlertGroup + problem.Manager) in
                                ( select Node + AlertKey + AlertGroup + Manager from alerts.status where Severity > 0 and Type = 2 ) 
	begin
		insert into alerts.problem_events values ( problem.Identifier, problem.LastOccurrence, 
							problem.AlertKey, problem.AlertGroup, 
							problem.Node, problem.Manager, false );

	end;

	-- For each resolution event, mark the corresponding problem_events entry as resolved
	-- and clear the resolution
	for each row resolution in alerts.status where resolution.Type = 2 and resolution.Severity > 0
	begin
		set resolution.Severity = 0;
-- updated to set ClearTime value - Giles Blake, 13/07/10
		--set resolution.ClearTime = getdate();
--updated to set ClearTime value -- FF 05/09/10		
		set resolution.ClearTime = resolution.LastOccurrence;

-- updated to set ExpireID value - Chris Janes 23/07/2010
		set resolution.ExpireID = 65533;
		update alerts.problem_events set Resolved = true where 
				LastOccurrence < resolution.LastOccurrence and 
				Manager = resolution.Manager and Node = resolution.Node and 
				AlertKey = resolution.AlertKey and AlertGroup = resolution.AlertGroup ;
	end;

	-- Clear the resolved events
	for each row problem in alerts.problem_events where problem.Resolved = true
	begin
-- updated to set ClearTime value - Giles Blake, 13/07/10
		update alerts.status via problem.Identifier set Severity = 0, ClearTime = getdate(), ExpireID = 65533;	
	end;

	-- Remove all entries from the problems table
	delete from alerts.problem_events;


