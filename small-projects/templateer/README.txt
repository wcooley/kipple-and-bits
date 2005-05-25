    README for /templateer/
    Wil Cooley <wcooley@nakedape.cc>
    12 Apr 2005
    (C) 2005 Naked Ape Consulting, Ltd.

/templateer/ is a quick and easy templating script which has proven to be
tremendously useful to me.  It reads a template file, extracts a list of
template variables, finds values for the variables and then writes the fill-in
instance file.  It will first check the environment, so template variables can
be more automatically handled.  (Note that you must also be careful not to use
template variable names that correspond with common environment variables,
like SHELL or HOSTNAME.)  If not found in the environment, the user will be
prompted (on stderr, so stdout is left virginal for the template instance).

Template variables are just strings delineated with '@@' on each end and
on one line.  There are no plans to do much more than that; it is not a
replacement for a full-blown templating system like Template Toolkit, just
a limited-use, quick and easy templating script.  (The only improvement I'm
currently considering is to allow the delimiter to be set, to be useful in
those rare cases where '@@' is required otherwise.  I will probably fix it
if I run into one of those cases.  I have not yet.)

Before prompting the user, /templateer/ will '-' can also be used for either
template or instance file (or both), in which case it has the usual meaning ---
read from stdin and write to stdout.  However, if it is to read the template
from standard input, it *must* be provided all values by the environment,
because, well, how else would you read in the input?

If both input and output files are the same, it will operate in "one-file"
mode.  The output will be written to a temporary file and renamed over the
previous file.  This lets you just copy template files and overwrite them,
which may be easier in some circumstances.

Except in one-file mode, the output file will be appended to instead of
overwritten; this just seemed far more common a desired behavior.  If you
really want to overwrite the destination file, you can write to stdout and
redirect that.

Here's how you might use it.  Like most people who host web sites with
Apache, you've probably got a whole lot of sites that are pretty much the
same configuration (and for various reasons you're not using mod_vhost_alias)
and you add enough new sites that creating the configuration is tedious and
probably somewhat error-prone.  So you make a template file, 'vhost.tpl',
like this:

<VirtualHost @@VIP_ADDR@@:80>
    ServerName @@DOMAIN@@
    ServerAlias *.@@DOMAIN@@
    DocumentRoot /var/www/vhosts/@@DOMAIN@@/htdocs/
    CustomLog /var/www/vhosts/@@DOMAIN@@/logs/access_log combined
    ErrorLog /var/www/vhosts/@@DOMAIN@@/logs/error_log
</VirtualHost>

Now you can use this template in several ways with templateer.  For
occasional use, you can just run it and add its output to your httpd.conf
file:

$ templateer vhost.tpl httpd.conf
Reading template vhost.tpl...
Kindly provide the values for the following template values:
DOMAIN = example.com
VIP_ADDR = 10.0.0.1
Writing to httpd.conf...
DOMAIN => example.com
VIP_ADDR => 10.0.0.1

If you had a lot of hosts to add and you could put the names into a file and
then use a shell loop to run /templateer/ for each one, putting (for
example) each configuration into a separate file in conf.d:

VIP_ADDR=10.0.0.1

for vhost in $(cat new_vhosts); do
    DOMAIN=$vhost templateer vhost.tpl conf.d/${vhost}.conf
done

Notice that shells let you set variables for each process if you start the
command line with the VAR=val and that the variable only lasts as long as
the process lasts.

