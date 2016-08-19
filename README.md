# auto-cuckoo
A colection of shell scripts to aid in handling malware samples

  * Monitors a drop folder for incoming samples
  * Moves to a working folder then renames sample removing spaces from name
  * Monitor working folder for samples, pulls each into cuckoo 
  * Monitors for job completeing then calls an email script
  * Email script compresses html report, renames it to bypass some MS Outlook restrictions
  * Sends out email then archives the report 
  
  
  
  
TO DO
Create archive cleanup script. 
