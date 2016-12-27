
###############################################################
#
#	Setting
#
###############################################################

pre database action on Insert





###############################################################
#
#	When
#
###############################################################



new.EventId='' and new.AlarmClass<>''






###############################################################
#
#	Action
#
###############################################################


begin


set new.Sysname = new.Node;

for each row EventLookup in custom.parent_child where EventLookup.AlarmClass=new.AlarmClass and EventLookup.Manager=new.Manager
	begin
		set new.EventId = EventLookup.Source_Event_ID;
		set new.EnrichmentSource = EventLookup.Enrichment_Source ;
		
	end;
-- to create auto trouble tickets for events where no parent child relationships defined
if (new.EventId = '') and (new.ActionRequired = 1)
then
		set new.ParentChildFlag = 8;
		set new.ParentChildTime = getdate;
end if;


end