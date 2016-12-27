	delete from alerts.status where LogTicket = 0 AND Severity = 0 AND InternalClearTime < (getdate() - 300) AND (
		(SyntheticServerSerial = 0 And EventId Not In ('MSD_001', 'NET_MED_OUT_001', 'NET_C7_001', 'NET_GPRS_001', 'NET_X25_FAIL_001')) 
		OR (SyntheticServerSerial = 0 And EventId In ('MSD_001', 'NET_MED_OUT_001', 'NET_C7_001', 'NET_GPRS_001','NET_X25_FAIL_001', 'NET_X25_FAIL_002') and Type = 1 and ImpactFlag < 5) 
		OR (SyntheticServerSerial > 0 And ImpactFlag = 100) OR (ImpactFlag = 6 and EventId In ('MSD_001', 'NET_MED_OUT_001', 'NET_C7_001', 'NET_GPRS_001','NET_EXT_CUS_001')) 
		OR (EventId = 'BSSE_001' and Type = 2 and ImpactFlag = 6) 
		OR (EventId = 'NET_MED_OUT_001' and ImpactFlag = 4 and MaintFlag not in (1,2)) )