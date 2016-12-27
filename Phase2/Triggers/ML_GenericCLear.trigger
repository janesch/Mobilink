declare
clear_time utc;
prob_server_serial int;
begin


	-- Populate a table with Type 1 events corresponding to any uncleared Type 2 events
	for each row problem in alerts.status where
				problem.Type = 1 and problem.Severity > 0 and
                                (problem.Node + problem.AlertKey + problem.AlertGroup + problem.Manager) in
                                ( select Node + AlertKey + AlertGroup + Manager from alerts.status where Severity > 0 and Type = 2 ) 
	begin
		--Added new field ClearTime in the problem_events table - Alex Silva 10/10/2010
		--store problem server serial - Alex Silva 26/01/2011
		
		insert into alerts.problem_events values ( problem.Identifier, problem.LastOccurrence, 
							problem.AlertKey, problem.AlertGroup, 
							problem.Node, problem.Manager, false, problem.ClearTime, problem.ServerSerial, 0);

	end;

	-- For each resolution event, mark the corresponding problem_events entry as resolved
	-- and clear the resolution
	for each row resolution in alerts.status where resolution.Type = 2 and resolution.Severity > 0
	begin
		set resolution.Severity = 0;
		-- updated to set ClearTime value - Alex Silva 10/10/2010
		set resolution.ClearTime = resolution.LastOccurrence;
		
		-- updated to set ExpireID value - Chris Janes 23/07/2010
		set resolution.ExpireID = 65533;

		--update problem event's ClearTime = resolution.LastOccurrence - Alex Silva 10/10/2010
	--	update alerts.problem_events set Resolved = true,  ClearTime = resolution.LastOccurrence where 
			--	LastOccurrence < resolution.LastOccurrence and 
			--	Manager = resolution.Manager and Node = resolution.Node and 
			--	AlertKey = resolution.AlertKey and AlertGroup = resolution.AlertGroup ;
		--Clear Motorola  evenst when problem LastOccurrence = resolution.LastOccurrence - Alex Silva 19/10/2010
		update alerts.problem_events set Resolved = true,  ClearTime = resolution.LastOccurrence, ResolutionSerial = resolution.ServerSerial where 
                           			(LastOccurrence < resolution.LastOccurrence or LastOccurrence = resolution.LastOccurrence and Manager in ('somcsys2','sunfire2','sunfire3', 'sunfire4', 'OMC1', 'OMC2', 'OMC3', 'OMC4', 'OMC5', 'siemens_sc_scr12', 'M2000 CORE1', 'M2000 CORE2', 'NETACT1', 'NETACT2', 'MTTrapd-STP', 'Alcatel WiMAX')) and 
                           			Manager = resolution.Manager and Node = resolution.Node and 
                           			AlertKey = resolution.AlertKey and AlertGroup = resolution.AlertGroup ;
		
	end;
	-- Populate Resolution events ProblemSerial fiield - Alex Silva 26/01/2011
	for each row cleared in alerts.problem_events
	begin 
		update alerts.status set ProblemSerial = cleared.ProblemSerial where ServerSerial = cleared.ResolutionSerial;	
	end;

	-- Clear the resolved events
	for each row problem in alerts.problem_events where problem.Resolved = true
	begin
	-- updated to set ClearTime value - Alex Silva  10/10/2010
		update alerts.status via problem.Identifier set Severity = 0, ClearTime = problem.ClearTime, ExpireID = 65533;	
	end;

	-- Remove all entries from the problems table
	delete from alerts.problem_events;














end