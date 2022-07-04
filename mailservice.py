import time
import xml.etree.ElementTree as ET
import smtplib, ssl
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
try:
    from email import encoders
except:
    from email import Encoders as encoders

success = 0
def sendMail(currentFolder, currentAddress, currentAttach):
    from_email_address = "itinerarios@projetorepublica.org" 
    to_email_address = currentAddress 
    rcpt = ['sumbiountech@gmail.com']+[to_email_address]
    # to_email_address = "sumbiountech@gmail.com"

    smtp_server = "smtp.socketlabs.com"
    smtp_username = "server44416"
    smtp_password = "j5B4FfLw28RdTa9s"
    port = 587

    message = MIMEMultipart("alternative")
    message["Subject"] = "Sua sessão de fotos nos Itinerários da Independência"
    message["From"] = from_email_address
    message["To"] = to_email_address
    # message["Cc"] = 'sumbiountech@gmail.com'

    html = "<html><p>Olá!</p><p>Agradecemos a sua visita à exposição <i>Itinerários da Independência</i> no Caminhão-museu.</p><p>Sua sessão de fotos está em anexo.</p><p>Atenciosamente,<br/>Equipe do Caminhão-museu</p></html>"

    part = MIMEText(html, "html")
    message.attach(part)

    # to add an attachment is just add a MIMEBase object to read a picture locally.
    counter = 0
    for item in currentAttach:
        if(item != ""):
            tmpatt = item.split("-")
            tmpatt = str(tmpatt[1])
            counter+=1
            print(tmpatt)
            with open('../Chroma/Imagens/'+currentFolder+'/itinerarios-'+tmpatt, 'rb') as f:
                # set attachment mime and file name, the image type is png
                mime = MIMEBase('image', 'jpg', filename='itinerarios-'+str(counter)+'.jpg')
                # add required header data:
                mime.add_header('Content-Disposition', 'attachment', filename='itinerarios-'+str(counter)+'.jpg')
                mime.add_header('X-Attachment-Id', str(counter)) #pode ser o problema para imagens repetidas
                mime.add_header('Content-ID', '<image'+str(counter)+'>') #pode ser o problema para imagens repetidas
                # read attachment file content into the MIMEBase object
                mime.set_payload(f.read())
                # encode with base64
                encoders.encode_base64(mime)
                # add MIMEBase object to MIMEMultipart object
                message.attach(mime)

    try:

        context = ssl.create_default_context()

        with smtplib.SMTP(smtp_server, port) as server:

            server.starttls(context=context)

            server.login(
                smtp_username,
                smtp_password
                )

            server.sendmail(
                from_email_address,
                rcpt, #to_email_address,
                message.as_string()
            )

            success = 1
            server.quit()

    except SMTPException as e:
        print(e)

    except Exception as e:
        print(e)

tree = ET.parse('../Chroma/chroma_video/data/mailqueue.xml')
root = tree.getroot()
count = 1
for item in root:
    tfolder = item.get('timestamp').split('-')
    tfolder = tfolder[0]
    taddress = item.get('address')
    tattach = [item.get('attach1'), item.get('attach2'), item.get('attach3')]
    print('sending email')
    if(count>46):
        sendMail(tfolder, taddress, tattach)
        print('sent: '+taddress)
    print(str(count) + "/" + str(len(root.findall('message'))))
    count +=1


# while(True):
#     tree = ET.parse('../Chroma/chroma_video/data/mailqueue.xml')
#     root = tree.getroot()
#     for item in root:
#         if(item.get('sent') == "0"):
#             tfolder = item.get('timestamp').split('-')
#             tfolder = tfolder[0]
#             taddress = item.get('address')
#             tattach = [item.get('attach1'), item.get('attach2'), item.get('attach3')]
#             print('sending email')
#             sendMail(tfolder, taddress, tattach)
#             print('sent: '+taddress)
#             if(success == 1):
#                 item.set('sent', '1')
#                 tree.write('../Chroma/chroma_video/data/mailqueue.xml');
#                 success = 0
#     time.sleep(300)
    