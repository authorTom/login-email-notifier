#!/bin/bash
#
# ==============================================================================
#
#          FILE: login-notify.sh
#
#         USAGE: This script is intended to be called by the PAM framework
#                on user login to send an email notification.
#
#   DESCRIPTION: Sends an email to a specified address upon successful user
#                logins (including SSH, local console, su, etc.).
#
#        AUTHOR: Tom Wright
#       CREATED: July 2025
#       VERSION: 1.0
#
# ==============================================================================

# --- [!] BEGIN CONFIGURATION [!] ---

# Set the email address to receive the notifications.
RECIPIENT_EMAIL="your-email@example.com"

# --- [!] END CONFIGURATION [!] ---

# This script is triggered by PAM. We only want to act when a session is opened.
if [ "$PAM_TYPE" = "open_session" ]; then

  # --- Construct the email message ---
  SUBJECT="[Login Alert] User: $PAM_USER on $(hostname)"
  MESSAGE=$(cat <<-EOF
	Greetings,

	This is an automated notification to inform you of a new login event on the server '$(hostname)'.

	--- Login Details ---
	Username:     $PAM_USER
	Remote Host:  ${PAM_RHOST:-"N/A (Local Login)"}
	Service:      $PAM_SERVICE
	TTY:          $PAM_TTY
	Date & Time:  $(date +"%Y-%m-%d %H:%M:%S %Z")
	---

	Current Logged-in Users:
	$(who)

	Regards,
	Server Notification System
	EOF
  )

  # --- Send the email ---
  # The 'mail' command is provided by the 'mailutils' package.
  echo "$MESSAGE" | mail -s "$SUBJECT" "$RECIPIENT_EMAIL"
fi

exit 0