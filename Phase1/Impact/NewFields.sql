ALTER TABLE alerts.status
ADD COLUMN Domain varchar(64)
ADD COLUMN Region varchar(64)
ADD COLUMN ManCity varchar(64)
ADD COLUMN CovCity varchar(64)
ADD COLUMN OmcEms varchar(64)
ADD COLUMN NePriority varchar(64)
ADD COLUMN NoSimilarAlm varchar(64)
ADD COLUMN AddText varchar(255)
ADD COLUMN OutageFlag integer
ADD COLUMN NotifiedFlag integer
ADD COLUMN MaximoStatus integer
ADD COLUMN MaximoInfo varchar(255)
ADD COLUMN ImpactFlag integer
