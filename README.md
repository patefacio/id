# Id

<!-- custom <introduction> -->

A library for consistently representing identifiers, usually in a code
generation setting.

<!-- end <introduction> -->


# Purpose

<!-- custom <purpose> -->

The purpose of the library is to have a standard way of generating an
object, an _Id_, that can be used in any of a variety of casing
contexts.

<!-- end <purpose> -->


# Examples

<!-- custom <examples> -->

For example, suppose you are writing a code generator that has a need
for a single id with multiple representations. The following
representations are covered:

 * _snake case_: words are all lower case with underscores (_how\_now\_brown\_cow_)
 * _emacs_: words are all lower with hyphens (_how-now-brown-cow_)
 * _shout_: words are all upper case with underscores (_HOW\_NOW\_BROWN\_COW_)
 * _camel_: words are joined with each word capitalized excluding the first (_howNowBrownCow_)
 * _capCamel_: words are joined with all words capitalized (_HowNowBrownCow_)
 * _title_: All words capitalized and joined with spaces (_How Now Brown Cow_)
 * _squish_: Lower case with no hypens or underscores (_hownowbrowncow_)
 * _abbrev_: The abbreviation in lower case (_hnbc_)

The default constructor requires the identifier to be snake case:

    var id = new Id('how_now_brown_cow');
    print(id);                   // => howNowBrownCow        
    print(id.snake);             // => how_now_brown_cow     
    print(id.emacs);             // => how-now-brown-cow     
    print(id.shout);             // => HOW_NOW_BROWN_COW     
    print(id.camel);             // => howNowBrownCow        
    print(id.capCamel);          // => HowNowBrownCow        
    print(id.title);             // => How Now Brown Cow     
    print(id.squish);            // => hownowbrowncow        
    print(id.abbrev);            // => hnbc                  

An library function accepts either _snake_ or any _camel_ and returns a new Id:

    var id = idFromString('testName');

<!-- end <examples> -->


# TODO

<!-- custom <todos> -->
<!-- end <todos> -->


