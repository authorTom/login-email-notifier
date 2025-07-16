# SSH & Login Email Notifier

[](https://opensource.org/licenses/MIT)

A simple, configurable Bash script for Linux servers that sends an email notification for every user login event, including SSH, local console, `su`, and more.

It uses the standard Pluggable Authentication Modules (PAM) framework, making it a robust and secure way to monitor access to your server.

-----

## Features

  * 📧 **Email Alerts**: Get instant notifications for all new user sessions.
  * ℹ️ **Detailed Information**: The notification includes the username, remote IP address, login service (e.g., `sshd`), TTY, and timestamp.
  * 👥 **Current Users**: The email body includes a list of all currently logged-in users for immediate context.
  * 🔧 **Easy Configuration**: Set the recipient email address by changing a single variable.
  * 🛡️ **PAM Integration**: Hooks into the standard Linux authentication system for wide compatibility and reliability.

-----

## Prerequisites

Before you begin, ensure you have a command-line email client installed on your server. On **Debian/Ubuntu**, you can install `mailutils`:

```bash
sudo apt update && sudo apt install mailutils -y
```

> During the `mailutils` installation, you may be prompted to configure Postfix. For most use cases, selecting **"Local only"** is sufficient.

-----

## Installation

Follow these steps to set up the login notifier on your server.

### **1. Get the Script**

Clone this repository or download the `login-notify.sh` script to your server.

```bash
git clone https://github.com/authorTom/login-email-notifier.git
cd login-email-notifier
```

### **2. Configure the Script**

Open `login-notify.sh` with a text editor and change the `RECIPIENT_EMAIL` variable to the address where you want to receive alerts.

```bash
# ... inside login-notify.sh

# Set the email address to receive the notifications.
RECIPIENT_EMAIL="your-email@example.com"
```

### **3. Set Permissions and Location**

Move the script to a standard location for system binaries and set the correct ownership and permissions.

```bash
# Move the script to /usr/local/sbin
sudo mv login-notify.sh /usr/local/sbin/

# Set root as the owner
sudo chown root:root /usr/local/sbin/login-notify.sh

# Set permissions so only root can read, write, and execute
sudo chmod 700 /usr/local/sbin/login-notify.sh
```

### **4. Configure PAM**

Finally, configure PAM to execute the script every time a new user session is created.

1.  Open `/etc/pam.d/common-session` with a text editor:

    ```bash
    sudo nano /etc/pam.d/common-session
    ```

2.  Add the following line to the **very end** of the file:

    ```
    # Execute script on login to send email notification
    session optional pam_exec.so /usr/local/sbin/login-notify.sh
    ```

> **Warning**: The `optional` keyword is very important. It ensures that if the script fails for any reason, user logins will **not be blocked**. Changing this to `required` could lock you out of your server if the script has an error or the mail service is down.

-----

## Testing

To test the configuration, simply log out and log back into your server.

```sh
exit
```

After you successfully log back in, check the recipient's email inbox. You should receive a notification within a few moments.

**Example Email:**

```
Subject: [Login Alert] User: ubuntu on my-server

Greetings,

This is an automated notification to inform you of a new login event on the server 'my-server'.

--- Login Details ---
Username:     ubuntu
Remote Host:  192.168.1.101
Service:      sshd
TTY:          pts/0
Date & Time:  2025-07-16 00:15:00 BST
---

Current Logged-in Users:
ubuntu   pts/0        2025-07-16 00:15 (192.168.1.101)

Regards,
Server Notification System
```

-----

## License

This project is licensed under the MIT License.