#!/usr/bin/env python
#
# listexists - Little CGI to test for the existence of a list
#
# Try to use as much of the Mailman framework as possible to make this simpler
# and more portable
#
# NB: This script doesn't run with same SGID permissions as the other CGIs. It
# does not need much in the way of permissions--just to check the existence of
# the config.pck in the list's directory: $MAILMAN/lists/<listname>/config.pck
#
# It also represents a potential information disclosure--it does not respect
# the advertised or unadvertised status of lists.

import cgi
import cgitb; cgitb.enable()
import os, sys
sys.path.append('/usr/lib/mailman/scripts')

import paths
import xmlrpclib

from Mailman import Utils

def send_text_response(response):
    print "Content-Type: text/plain"
    print
    print response

def http_error(status, message):
    """ Display an error message and return an HTTP status code.
        This function causes the script to exit!
    """
    print """Status: %(status)s
Content-Type: text/html

<html>
<title>Error %(status)s</title>
<body>
<h1>Error %(status)s: %(message)s</h1>
<p>Unexpected error processing request.</p>
</body></html>
""" % { 'status': status, 'message': message }
    sys.exit(0)

def handle_http_get_request(form):
    """ Handle an HTTP GET request for the list.
    """

    if not form.has_key('list'):
        # TODO: Maybe print a form here instead?
        http_error(400, "Usage: %s?list=<listname>" % os.environ['REQUEST_URI'])

    listname = form['list'].value
    safe_listname = Utils.websafe(listname)

    if Utils.list_exists(listname):
        send_text_response("TRUE: %s exists" % safe_listname)
    else:
        send_text_response("FALSE: %s does not exist" % safe_listname)

def handle_pathinfo_request(pathparts):
    """ Handle a request with the list in the PATH_INFO
    """

    listname = pathparts[0].lower()

    safe_listname = Utils.websafe(listname)

    if Utils.list_exists(listname):
        send_text_response("TRUE: %s exists" % safe_listname)
    else:
        send_text_response("FALSE: %s does not exist" % safe_listname)

def handle_xmlrpc_request():
    """ Handle a request using XML-RPC
    """

    from SimpleXMLRPCServer import CGIXMLRPCRequestHandler
    from xmlrpclib import boolean

    handler = CGIXMLRPCRequestHandler()
    handler.register_function(lambda listname: 
            boolean(Utils.list_exists(listname)), 
            'check_list_exists')
    handler.register_introspection_functions()
    handler.handle_request()

def main():

#    cgi.test(); return

    req_method = os.environ['REQUEST_METHOD']

    # GET is used for request GET queries and PATH_INFO queries
    if req_method == 'GET':
        parts = Utils.GetPathPieces()

        if parts:
            handle_pathinfo_request(parts)

        else:
            form = cgi.FieldStorage()
            handle_http_get_request(form)


    # POST is used for XML-RPC queries
    elif req_method == 'POST':
        handle_xmlrpc_request()

    else:
        http_error(500, "Unrecognized request method: " + req_method)


if __name__ == '__main__':
    main()

