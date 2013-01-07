
use strict;
use warnings;
use RT;
use RT::Test tests => 16;


{

ok (require RT::SearchBuilder);


}

{

use_ok('RT::Queues');
ok(my $queues = RT::Queues->new(RT->SystemUser), 'Created a queues object');
ok( $queues->UnLimit(),'Unlimited the result set of the queues object');
my $items = $queues->ItemsArrayRef();
my @items = @{$items};

ok($queues->NewItem->_Accessible('Name','read'));
my @sorted = sort {lc($a->Name) cmp lc($b->Name)} @items;
ok (@sorted, "We have an array of queues, sorted". join(',',map {$_->Name} @sorted));

ok (@items, "We have an array of queues, raw". join(',',map {$_->Name} @items));
my @sorted_ids = map {$_->id } @sorted;
my @items_ids = map {$_->id } @items;

is ($#sorted, $#items);
is ($sorted[0]->Name, $items[0]->Name);
is ($sorted[-1]->Name, $items[-1]->Name);
is_deeply(\@items_ids, \@sorted_ids, "ItemsArrayRef sorts alphabetically by name");



}

#20767: UnLimit doesn't clear RT::SearchBuilder's flags for handling Disabled columns
{
  my $items;

  ok(my $queues = RT::Queues->new(RT->SystemUser), 'Created a queues object');
  ok( $queues->UnLimit(),'Unlimited the result set of the queues object');

  $queues->FindAllRows;

  $items = $queues->ItemsArrayRef();
  is( @$items, 2, 'found disabled queue in search' );

  ok( $queues->UnLimit(),'Unlimited the result set of the queues object');
  $items = $queues->ItemsArrayRef();
  is( @$items, 1, 'disabled queue was not in search' );
}

