# ADLockoutAlert.ps1, written 2018-06-10 by ngwmddgh
# Feed a ticketing or other email-interfaced system whenever an AD account is locked.
# Future revision should query email address directly rather than infer it from combination of username and domain.

import-module activedirectory

$AccountLockOutEvent = Get-EventLog -LogName "Security" -InstanceID 4740 -Newest 1
$LockedAccount = $($AccountLockOutEvent.ReplacementStrings[0])
$AccountLockOutEventTime = $AccountLockOutEvent.TimeGenerated
$AccountLockOutEventMessage = $AccountLockOutEvent.Message

$ADUserDisplayName = (Get-ADUser $LockedAccount -Properties DisplayName).DisplayName

$recipients = "support@domain.tld"

send-mailmessage -from "$LockedAccount@domain.tld" `
            -to $recipients `
            -subject "Account Locked Out: $LockedAccount" `
            -body "Account $LockedAccount was locked out on $AccountLockOutEventTime.`n`nEvent Details:`n`n$AccountLockOutEventMessage`n`nUser: $ADUserDisplayName" `
            -smtpServer smtp.domain.tld
