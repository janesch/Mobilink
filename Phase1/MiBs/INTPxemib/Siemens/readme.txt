------------------------------------------------------------------------
Siemens AG, Information and Communication Mobile      Munich, 01.03.2002
------------------------------------------------------------------------

========================================================================
@vantage Commander SNMP MIB modules and Event Configuration for an 
Operations System ( OS )
========================================================================

Assumptions:
============
- The operations system is based on the HP OV NNM V4.1 (UNIX) or higher.
- The TAR file containing this file, the SNMP MIB modules and the
  shell scripts was extracted with "/var/opt/OV/share/snmp_mibs/Vendor/"
  as the current working directory.

Notes for other operations systems:
===================================
The SNMP MIB modules are based on the SNMPv2C SMI according to the
RFC 1902. They could be loaded also into other operations systems
conforming to this internet standard. 
The loading order could be derived from the MIB loading shell script 
for the HP OV NNM mentioned below.

MIB Module Loading:
-------------------
The following steps are required to load the INCommander SNMP modules 
into the operation system:

1) Insert the floppy disk containing the INCommander SNMP modules needed by 
   an operation system as well as the shell scripts to load and unload them.
   Note: the TAR file could be provided on the operations system also by
   other means (e.g. file transfer via ftp).

2) Login as UNIX user 'root'

3) Perform the following shell commands :
   
   . /opt/OV/bin/ov.envvars.sh
   cd $OV_SNMP_MIBS/Vendor
   tar -xvf <Name_of_the_Floppy_Device_File_OR_Pathname_of_TAR_File>
   cd Siemens
   ./ti_loadmib

MIB Module Unloading:
---------------------
The following steps are required to unload the INCommander SNMP modules 
from the operation system:

1) Login as UNIX user 'root'

2) Perform the following shell commands :
   
   . /opt/OV/bin/ov.envvars.sh
   cd $OV_SNMP_MIBS/Vendor/Siemens
   ./ti_unloadmib

Event Configuration Loading:
----------------------------
The following steps are required to load the INCommander Event Configuration
into the operation system:

1) Login as UNIX user 'root'

2) Perform the following shell commands :
   
   . /opt/OV/bin/ov.envvars.sh
   cd $OV_SNMP_MIBS/Vendor/Siemens
   ./ti_loadEvtConf

------------------------------------------------------------------------
