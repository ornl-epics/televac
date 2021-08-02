#!../../bin/linux-x86_64/bl4b-televac

## You may have to change bl4b-televac to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/bl4b-televac.dbd"




bl4b_televac_registerRecordDeviceDriver pdbbase
#Televac
asynSetAutoConnectTimeout(1.0)
drvAsynIPPortConfigure( "televac1", "10.112.9.12:4008 tcp", 0, 0, 0 )


#enables debugging 0xff is the max setting
#asynSetTraceIOMask("televac1", 0,0xff)
#asynSetTraceMask("televac1", 0,0xff)



## Load record instances
#dbLoadRecords("db/xxx.db","user=zmaHost")
dbLoadRecords("db/televac.db")
#################################################
#AUTOSAVE
epicsEnvSet IOCNAME bl4-televac
epicsEnvSet SAVE_DIR /home/controls/var/$(IOCNAME)

save_restoreSet_Debug(0)

### status-PV prefix, so save_restore can find its status PV's.
save_restoreSet_status_prefix("BL4B:Chop:Televac:")

set_requestfile_path("$(SAVE_DIR)")
set_savefile_path("$(SAVE_DIR)")

save_restoreSet_NumSeqFiles(3)
save_restoreSet_SeqPeriodInSeconds(600)
set_pass0_restoreFile("$(IOCNAME).sav")
set_pass0_restoreFile("$(IOCNAME)_pass0.sav")
set_pass1_restoreFile("$(IOCNAME).sav")


#################################################
var mediatorVerbosity 7

var mySubDebug 7 

cd ${TOP}/iocBoot/${IOC}
iocInit

dbpf BL4B:Chop:Televac:MarkSensor 1
dbpf BL4B:Chop:Televac:MarkSensor 2
dbpf BL4B:Chop:Televac:MarkSensor 3

dbpf BL4B:Chop:Televac:Press1.HIHI 100
dbpf BL4B:Chop:Televac:Press2.HIHI 100
dbpf BL4B:Chop:Televac:Press3.HIHI 100




#Create request file for periodic save
epicsThreadSleep(5)
makeAutosaveFileFromDbInfo("$(SAVE_DIR)/$(IOCNAME).req", "autosaveFields")
makeAutosaveFileFromDbInfo("$(SAVE_DIR)/$(IOCNAME)_pass0.req", "autosaveFields_pass0")
create_monitor_set("$(IOCNAME).req", 5)
create_monitor_set("$(IOCNAME)_pass0.req", 30)

