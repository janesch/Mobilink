ALTER TABLE alerts.status
ADD  TargetEntity varchar(64)
ADD  SpecificProblem varchar(64)
ADD  OCName varchar(64)
ADD  MaximoStatus integer
ADD  MaximoInfo varchar(64)
ADD  MaximoCreateTime UTC
ADD  ImpactFlag integer
ADD  HibernateFlag integer
ADD  ImpactTime UTC
ADD  MaintFlag integer
ADD  MaintEndTime UTC
Add  ParentName varchar(64)
ADD  ParentSerial integer
ADD  SuppressEvent integer



