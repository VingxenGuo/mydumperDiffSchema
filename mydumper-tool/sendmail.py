import smtplib
import sys
import glob
import os
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders

py_path = os.path.dirname(os.path.abspath(__file__))
# Load SMTP settings from config file
config_dict = {}
config_file_path = os.path.join(py_path, 'sendmail.config')

with open(config_file_path, 'r', encoding='UTF-8') as file:
    flie_lines = file.readlines()
    for line in flie_lines:
        if '=' not in line:
            continue
        key, value = line.split('=')
        config_dict[key.strip()] = value.strip()

print('Successfully read sendmail.config')
# SMTP server configuration
smtp_server = config_dict['smtp_server']
port = int(config_dict['port'])
sender_email = config_dict['sender_email']
receiver_emails = config_dict['receiver_emails']
password = config_dict['password']
subject = config_dict['subject']
body = config_dict['body']

# If a command line argument is provided, use it as the attachment path
if len(sys.argv) > 1:
    attachment_path = sys.argv[1]
    print(f"Using command line argument as attachment: {attachment_path}")
else:
    # Use path from config, relative to the script location
    attachment_path = os.path.join(py_path, config_dict['attachment_path'])

# Receiver email addresses (split by commas)
receiver_emails = [email.strip() for email in receiver_emails.split(',')]

# Find files matching the pattern
attachment_files = glob.glob(attachment_path)

if not attachment_files:
    print(f"Error: No files found matching pattern '{attachment_path}'")
    sys.exit(1)

# Pick the first matching file
target_file = attachment_files[0]
print(f"Sending file: {target_file}")

# Create multipart message object
message = MIMEMultipart()
message['Subject'] = subject
message['From'] = sender_email
message['To'] = ", ".join(receiver_emails)

# # Add email body
message.attach(MIMEText(body, 'plain'))

# Add attachment
try:
    with open(target_file, "rb") as attachment:
        part = MIMEBase("application", "octet-stream")
        part.set_payload(attachment.read())

    # Encode the attachment
    encoders.encode_base64(part)

    # Add attachment header
    part.add_header(
        "Content-Disposition",
        f"attachment; filename= {os.path.basename(target_file)}",
    )

    # Attach the file to the email
    message.attach(part)

    # Set up the SMTP server and send the email
    server = smtplib.SMTP(smtp_server, port)
    server.ehlo()  # Identify yourself to the server
    server.starttls()  # Upgrade the connection to secure
    server.login(sender_email, password)
    server.sendmail(sender_email, receiver_emails, message.as_string())
    server.quit()
    print("Email sent successfully!")

except FileNotFoundError:
    print(f"Error: The file '{attachment_path}' was not found.")
except Exception as e:
    print(f"Error: {e}")
