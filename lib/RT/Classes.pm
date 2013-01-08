# BEGIN BPS TAGGED BLOCK {{{
#
# COPYRIGHT:
#
# This software is Copyright (c) 1996-2012 Best Practical Solutions, LLC
#                                          <sales@bestpractical.com>
#
# (Except where explicitly superseded by other copyright notices)
#
#
# LICENSE:
#
# This work is made available to you under the terms of Version 2 of
# the GNU General Public License. A copy of that license should have
# been provided with this software, but in any event can be snarfed
# from www.gnu.org.
#
# This work is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301 or visit their web page on the internet at
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.html.
#
#
# CONTRIBUTION SUBMISSION POLICY:
#
# (The following paragraph is not intended to limit the rights granted
# to you to modify and distribute this software under the terms of
# the GNU General Public License and is only of importance to you if
# you choose to contribute your changes and enhancements to the
# community by submitting them to Best Practical Solutions, LLC.)
#
# By intentionally submitting any modifications, corrections or
# derivatives to this work, or any other work intended for use with
# Request Tracker, to Best Practical Solutions, LLC, you confirm that
# you are the copyright holder for those contributions and you grant
# Best Practical Solutions,  LLC a nonexclusive, worldwide, irrevocable,
# royalty-free, perpetual, license to use, copy, create derivative
# works based on those contributions, and sublicense and distribute
# those contributions and any derivatives thereof.
#
# END BPS TAGGED BLOCK }}}

use strict;
use warnings;

package RT::Classes;
use base 'RT::SearchBuilder';

sub Table {'Classes'}

sub _Init {
    my $self = shift;
    $self->{'with_disabled_column'} = 1;
    return ($self->SUPER::_Init(@_));
}

=head2 Next

Returns the next Object that this user can see.

=cut

sub Next {
    my $self = shift;


    my $Object = $self->SUPER::Next();
    if ((defined($Object)) and (ref($Object))) {
   if ( $Object->CurrentUserHasRight('SeeClass') ) {
        return($Object);
    }

    #If the user doesn't have the right to show this Object
    else {
        return($self->Next());
    }
    }
    #if there never was any Object
    else {
    return(undef);
    }

}

sub ColumnMapClassName {
    return 'RT__Class';
}

=head2 NewItem

Returns an empty new RT::Class item

=cut

sub NewItem {
    my $self = shift;
    return(RT::Class->new($self->CurrentUser));
}


RT::Base->_ImportOverlays();

1;
