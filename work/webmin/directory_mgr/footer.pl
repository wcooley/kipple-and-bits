
=head1 NAME

I<footer.pl>

=head1 DESCRIPTION

I<footer.pl> is a common footer script.

=cut

use strict ;
no strict "vars" ;

use diagnostics ;
$diagnostics::PRETTY =1 ;


print <<FOOTER;
<hr noshade size=2>
<div align="right">
<small>
Version 0.1.0<br>
Copyright &copy; 2001,2002 by Fernando Lozano &lt;fernando\@lozano.eti.br&gt; and Wil Cooley &lt;wcooley\@nakedape.cc&gt<br>
This Webmin module is under the GNU GPL - www.gnu.org
<a href="http://nakedape.cc/index.php3/webmin/directory_mgr" 
>Module Home</a>
</small>
</div>
FOOTER


=head1 NOTES

This should probably be moved to html.pl.

=head1 CREDITS

This module begun by Fernando Lozano <fernando@lozano.etc.br>
in his I<ldap-users> module.  Incorporated into I<directory_mgr>
by Wil Cooley <wcooley@nakedape.cc>.  All bug reports should go to
Wil Cooley.

=head1 LICENSE

This file is copyright Fernando Lozano <frenando@lozano.etc.br>
and Wil Cooley <wcooley@nakedape.cc>, under the GNU General Public
License <http://www.gnu.org/licenses/gpl.txt> or the file B<LICENSE>
included with this program.

=cut

1;
