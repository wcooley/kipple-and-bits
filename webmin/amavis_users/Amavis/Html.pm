=head1 NAME

I<Amavis/Html.pm>

=head1 DESCRIPTION

I<Amavis/Html.pm> is a Perl module for generating HTML for
Amavis Users Admins.

=cut


use strict;
use diagnostics;
use Amavis::Policy;

package Amavis::Html;

sub user_form {
    my ($u) = @_ ;
    my $html = "<!-- User Form -->" ;
    my $do ;

    if ($u) {
        $do = "update" ;
    } else {
        $do = "create" ;
    }

    $html .= qq(
        <table width=100% border=0>
        <form method="post" action="save_user.cgi">
        <input type="hidden" name="do" value="$do">
    );

    if ($u->{'id'}) {
        $html .= qq(
            <input type="hidden" name="id" value="$u->{'id'}">
        ) ;
    }

    $html .= qq(
        <tr $::cb>
            <td>$::text{'email'}</td>
            <td>
                <input type="text" name="email" value="$u->{'email'}">
            </td>
        </tr>
    ) ;

    $html .= qq(
        <tr $::cb>
            <td>$::text{'fullname'}</td>
            <td>
                <input type="text" name="fullname" value="$u->{'fullname'}">
            </td>
        </tr>
    ) ;

    $html .= qq(
        <tr $::cb>
            <td>$::text{'policy'}</td>
            <td>
                <select name="policy">
    ) ;

    $html .= &policy_select_options($u->{'policy_id'}) ;

    $html .= qq(
                </select>
            </td> 
        </tr>
    ) ;

    $html .= qq(
        <tr $::cb>
            <td>$::text{'priority'}</td>
            <td>
                <select name="priority">
    ) ;

    $html .= &priority_select_options($u->{'priority'}) ;

    $html .= qq(
                </select>
            </td> 
        </tr>
    ) ;
        
    $html .= qq(
        <tr $::cb>
            <td>
                <input type="submit" name="Submit" value="$::text{'submit'}">
            </td>
            <td>&nbsp;</td>
        </tr>
        </form>
        </table>
    ) ;


    return $html ;

}

sub user_table($) {
    my ($u) = @_ ;
    my $html = "" ;
    my $pol = new Amavis::Policy ;

    $html .= qq(
        <table broder width=100%>
        <th $::tb>$::text{'id'}</th>
        <th $::tb>$::text{'priority'}</th>
        <th $::tb>$::text{'policy'}</th>
        <th $::tb>$::text{'email'}</th>
        <th $::tb>$::text{'fullname'}</th>
    ) ;

    foreach my $r (@{$u}) {
        $r->{'policy'} = $pol->name_by_id($r->{'policy_id'}) ;

        $html .= qq(
        <tr>
            <td $::cb><a href="edit_user.cgi?id=$r->{'id'}">$r->{'id'}</a></td>
            <td $::cb>$r->{'priority'}</td>
            <td $::cb>$r->{'policy'}</td>
            <td $::cb>$r->{'email'}</td>
            <td $::cb>$r->{'fullname'}</td>
        </tr>
        ) ;
    }

    $html .= qq(
            </table>
            <a href="edit_user.cgi">Add User</a>
    ) ;

    return $html ;
}

sub policy_select_options(:$) {
    my ($policy) = @_ ;
    my $html = "\t\t<!-- Policy Selections -->\n";
    my $selected = "" ;
    my $pol = new Amavis::Policy ;

    $policy = $::config{'default_policy_id'} unless $policy ;

    foreach my $row ($pol->list()) {
        $selected = "selected" if ($policy == $row->[0]) ;
        $html .= "\t\t<option value=\"$row->[0]\" $selected>$row->[1]"
            . "</option>\n" ;
        $selected = "" ;
    } ;

    return $html ;
}

sub priority_select_options(:$) {
    my ($prio) = @_ ;
    my $html = "\t\t<!-- Priority Selections -->\n";
    my ($i, $selected);

    for ($i=0; $i <= $::config{'max_prio'}; $i++) {
        if ($i == $::config{'default_prio'}) {
            $selected = "selected" ;
        }
        $html .= "\t\t<option value=\"$i\" $selected>$i</option>\n" ;
        $selected = "" ;
    }

    return $html ;

}

1;

=head1 CREDITS

This module begun by Wil Cooley <wcooley@nakedape.cc>.  All bug
reports should go to Wil Cooley.

=head1 LICENSE

This file is copyright Wil Cooley <wcooley@nakedape.cc>, under the
GNU General Public License <http://www.gnu.org/licenses/gpl.txt>
or the file B<LICENSE> included with this program.

=cut


