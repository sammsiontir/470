#!/usr/bin/python

###
### This program runs an AIM chat bot that lets you
### query BGP (Internet routing) tables remotely
###

from twisted.internet import default
default.install()
from twisted.protocols import oscar
from twisted.internet import protocol, reactor
import getpass
import re
import random
import os, commands

SN = "bgpbotz"                         # screenname
PASS =  "manish"                             # ghosted
hostport = ('login.oscar.aol.com', 5190)
icqMode = 0

AIM_MAX_MSG_SIZE = 512
debug = 1 
menu_option = 0
bgpcmd = ""

def print_menu():
    menu_text = ""
    menu_text = "Welcome to BGPBotz the BGP RouteBot:\n\n"
    menu_text = menu_text + "Select Query Option 1-4:\n"
    menu_text = menu_text + "  Enter menu or help at any time to return to the main menu\n"
    menu_text = menu_text + "    1: show ip bgp\n"
    menu_text = menu_text + "    2: show ip bgp regexp\n"
    menu_text = menu_text + "    3: show ip bgp summary\n"
    menu_text = menu_text + "    4: Quit\n"
    return menu_text

class B(oscar.BOSConnection):
    capabilities = [oscar.CAP_CHAT]
    def initDone(self):
        self.requestSelfInfo().addCallback(self.gotSelfInfo)
        self.requestSSI().addCallback(self.gotBuddyList)
    def gotSelfInfo(self, user):
        if debug: print user.__dict__
        self.name = user.name
    def gotBuddyList(self, l):
        if debug: print l
        self.activateSSI()
        self.setProfile("BGPBotz")
        self.setIdleTime(0)
        self.clientReady()
    def receiveMessage(self, user, multiparts, flags):
        if debug: print user.name, multiparts, flags
        if debug: print "multiparts!! ", multiparts
        # auto messages should not be responded to. identify them by
        # the string auto, found in flags[0] (sometimes).
        try:
            auto = flags[0]
            if auto == "auto":
                return
        except IndexError:
            pass
        self.lastUser = user.name
        multiparts = self.modifyReturnMessage(multiparts)
	msg = multiparts[0][0]
	msize = len(msg)
	if msize > AIM_MAX_MSG_SIZE:
	    for index in range(0, len(msg), AIM_MAX_MSG_SIZE):
	        msg_to_send = msg[index: min(index + AIM_MAX_MSG_SIZE, len(msg))]
		multiparts[0] = (msg_to_send,)
                self.sendMessage(user.name, multiparts, wantAck = 1, \
                        autoResponse = (self.awayMessage!=None)).addCallback( \
                        self.respondToMessage)
        else:
            self.sendMessage(user.name, multiparts, wantAck = 1, \
                    autoResponse = (self.awayMessage!=None)).addCallback( \
                    self.respondToMessage)

    def respondToMessage(self, (username, message)):
        if debug: print "in respondToMessage"
        pass
    def receiveChatInvite(self, user, message, exchange, fullName, instance, shortName, inviteTime):
        pass
    def extractText(self, multiparts):
        message = multiparts[0][0]
        # find non-html surrounded by html; anything between > and < which
        # contains neither > nor <
        match = re.compile(">([^><]+?)<").search(message)
        if match:
            return match.group(1)
        else:
            return message

    def modifyReturnMessage(self, multiparts):
        global menu_option, bgpcmd
        if debug: print "in modifyReturnMessage"
        message_text = self.extractText(multiparts)
        snippets = []
        query = message_text
        
	if len(query) == 1:
	    menu_option = int(query) 

	    if menu_option == 0:
	        message_text = print_menu()
            elif menu_option == 1:
                message_text = "Mode now: \n" 
                bgpcmd = "show ip bgp "
                message_text = message_text + bgpcmd + "> "
                message_text = message_text + "Please enter prefix:\n" 
            elif menu_option == 2:
                bgpcmd = "show ip bgp regexp "
                message_text = "Mode now: \n" 
                message_text = message_text + bgpcmd + "> \n"
                message_text = message_text + "Please enter ASPATH regexp:\n" 
            elif menu_option == 3:
                bgpcmd = "show ip bgp summary "
                message_text = bgpcmd + "> \n"
	        cmd = "/usr/bin/vtysh -c " +  "\"" + bgpcmd + "\""
                output = commands.getoutput(cmd)
                message_text = message_text + output
            else:
                bgpcmd = ""
                message_text = print_menu() 
        elif 0 < menu_option < 4:
	    if query == "help":
	        menu_option = 0
		message_text = print_menu()
	    elif query == "menu":
	        menu_option = 0
		message_text = print_menu()
            else:
	        cmd = "/usr/bin/vtysh -c " +  "\"" + bgpcmd + query + "\""
                output = commands.getoutput(cmd)
                message_text = output
        else:
	    message_text = print_menu()

        multiparts[0] = (message_text,)
        return multiparts

class OA(oscar.OscarAuthenticator):
   BOSClass = B

protocol.ClientCreator(reactor, OA, SN, PASS, icq=icqMode).connectTCP(*hostport)
reactor.run()


