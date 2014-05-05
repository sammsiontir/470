#!/usr/bin/env python

###
### This program was built to take a list of uniqnames and validate that they
### are all "active" students at the University of Michigan. It's a good example
### of an ad-hoc python script built to do a one-off task but with enough
### flexibility / good design that it could be relatively easily repurposed for
### a similar task
###

import csv, getpass, ldap, ldif, string, sys, time, xlrd
from collections import defaultdict


def getUniqnames(filename):
	book = xlrd.open_workbook(filename)
	sh = book.sheet_by_index(0)
	uniqnames = []
	counts = defaultdict(int)
	sheets = defaultdict(list)
	for r in range(sh.nrows):
		if r > 0:
			sheet = sh.cell_value(r,0)
			uniqname = sh.cell_value(r,1)
			uniqnames.append(uniqname)
			counts[uniqname] += 1
			sheets[uniqname].append(int(sheet))
	# list(set(l)) filters out duplicates
	uniqs = set(uniqnames)
	return list(uniqs), counts, sheets


def UMODlookup(uniqnames):
	server = "ldap.itd.umich.edu"
	l = ldap.open(server)
	username = raw_input('Uniqname: ')
	password = getpass.getpass('Password: ')
	l.simple_bind(username,password)

	#secure authentication (doesn't work on Mac OS X 10.5)
	#l = ldap.initialize(server)
	#l.start_tls_s()
	
	# based on http://blogs.sun.com/marginNotes/entry/ldap_basics_with_python
	base_dn = 'ou=People,dc=umich,dc=edu'
	displayNames = {}
	registrationstatus = {}
	school = {}
	i = 0
	for uniqname in uniqnames:
		filter = "(|(uid=" + uniqname + "))"
		results = l.search_s(base_dn, ldap.SCOPE_SUBTREE, filter)
		if not results:
			displayNames[uniqname] = "Not found"
			school[uniqname] = "Not found"
			registrationstatus[uniqname] = "Not found"
			print "%s not found in directory" % uniqname
		else:
			for dn,entry in results:
				# get display name
				try:
					name = entry['displayName'][0]
					displayNames[uniqname] = name
				except:
					displayNames[uniqname] = "Missing"

				# get affiliations
				try:
					affiliations = entry['ou']
					schools = [x for x in affiliations if x.endswith('Student')]
					school[uniqname] = schools[0].rsplit('-',1)[0].replace('Undergraduate','UG')
				except:
					school[uniqname] = "Missing"

				# get registration status
				try:
					status = entry['registrationstatus'][0]
					registrationstatus[uniqname] = status
				except:
					registrationstatus[uniqname] = "Missing"
					print "Missing directory information for " + uniqname
		# be nice to the UMich LDAP server
		time.sleep(0.1)
		# let the user know how it's going
		if i % 100 == 0:
			print "Progress: %d of %d" % (i,len(uniqnames))
		i += 1
	return displayNames, registrationstatus, school


def csvwrite(uniqnames,displayNames,sheets,registrationstatus,school,outfile):
	writer = csv.writer(open(outfile, 'w'))
	writer.writerow(['uniqname','displayName','sheet(s)','registrationstatus','school'])
	for uniqname in uniqnames:
		writer.writerow([uniqname, displayNames[uniqname],str(sheets[uniqname]),registrationstatus[uniqname],school[uniqname]])


def main():
	filename = "petitionsigners.xls"
	uniqnames, counts, sheets = getUniqnames(filename)
	# find duplicates
	duplicates = []
	for (uniqname,count) in counts.iteritems():
		if count > 1:
			print uniqname + ' ' + str(sheets[uniqname])
			duplicates.append(uniqname)
	print "%d unique signers" % len(uniqnames)
	print "%d duplicates" % len(duplicates)
	
	displayNames, registrationstatus, school = UMODlookup(uniqnames)
	
	outfile = "petitionstats.csv"
	csvwrite(uniqnames,displayNames,sheets,registrationstatus,school,outfile)
	

if __name__ == '__main__':
	main()
