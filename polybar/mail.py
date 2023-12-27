#!/usr/bin/python

import imaplib
obj = imaplib.IMAP4_SSL('imap-mail.gmail.com',993)
obj.login('nilanshsharma23@gmail.com','ash123ASH!@#')
obj.select()
number = len(obj.search(None, 'UnSeen')[1][0].split())
if number>0:
    print(number)
else:
    print('')
