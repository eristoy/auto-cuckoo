#!/usr/bin/python
import sys,smtplib,os,zipfile,mimetypes
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.MIMEBase import MIMEBase
from email import encoders
from os.path import expanduser,basename

#Check if there are reports to send out
HOME = expanduser("~")
RPTDIR = HOME+"/reports"
ARCH = HOME+"/archive"

def doEmail(FILE):
    #Compress Report
    FPATH=(RPTDIR + "/" + FILE)
    FNAME=(FPATH + ".rnzip")
    ARCD=(ARCH+"/"+FILE)
    zf = zipfile.ZipFile("%s" % (FNAME), 'w')
    zf.write(FPATH, basename(FPATH))
    zf.close()
    #print "Full File Name is %s" %(FNAME)
    #Build email
    TO='NHCIRC@novanthealth.org'
    CC='eastoycon@novanthealth.org'
    FROM='CUCKOO-Sandbox@novanthealth.org'
    SBJ = 'CUCKOO Analysis Results for %s' %(FILE)
    mailSRV = 'localhost'
    msg = MIMEMultipart()
    msg["From"] = FROM
    msg["To"] = TO
    msg["CC"] = CC
    msg["Subject"] = SBJ
    msg.preamble = "Results from Cuckoo Analysis of possible malware %s" %(FILE)
    body = """\
            <html>
                <head></head>
                <body>
                    <h1>Cuckoo Analysis Report for %s</h1>
                    <p>Please remember to rename .rnzip attachment to .zip in order to decompress the html archive</p>
                </body>
            </html>
            """ %(FILE)
    msg.add_header('reply-to', 'do-not-reply@null.void')
    msg.attach(MIMEText(body, 'html'))
    attachment = open(FNAME, 'rb')
    part = MIMEBase('appllication','octet-stream')
    part.set_payload((attachment).read())
    encoders.encode_base64(part)
    part.add_header('Content-Disposition', "attachment; filename= %s" % (basename(FNAME)))
    msg.attach(part)
    server = smtplib.SMTP(mailSRV)
    text = msg.as_string()
    #print "processed message text is %s" % (text)
    try:
        server.sendmail(FROM, TO, text)
    except Exception as e:
        print e
    os.remove(FNAME)
    os.remove(FPATH)
    server.quit()


if __name__=="__main__":

    if os.listdir(RPTDIR) != []:
        print "has stuff"
        for FILE in os.listdir(RPTDIR):
            doEmail(FILE)
    else:
        print "no sutff"
        foo="true"


