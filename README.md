Introduction
============
This module aims to provide an alternative to the Net::DNS module, based the ldns library from NLnet Labs (https://www.nlnetlabs.nl/projects/ldns/). As such, that library needs to be installed for the module to build (and, obviously, work).

While the long-term goal is of course to expose the full functionality of ldns, as of this writing (December 2013) priority is given to those parts of the library that we need for another project. This explains, for example, the relatively small number of RR types that are currently fully supported. If you want to use this library and need not yet implemented parts, please log a ticket on Github. If nothing else it will let us know where interest lies.

If you want a module that specifically aims to be a complete and transparent interface to ldns, DNS::LDNS is a better fit than this module. 

API
===
The intention is that this module should be a viable alternative to Net::DNS. As such, the interface is similar but not identical. The main difference at the moment is that the expected entrypoint to the system is through Net::LDNS directly rather than a submodule (like Net::DNS::Resolver). It's also not possible to set the flags in the resolver object at creation, although that may change.

The API should at the moment be considered slightly volatile. We have other code written to the current interface, so it's unlikely that we'll want to make any drastic changes, but at least until we start calling it version 1.0 it's a good idea to check for changes before upgrading.

IDN
===
If GNU libidn is installed when this module is compiled, it will be used to add a simple function that converts strings from Perl's internal encoding to IDNA domain name format. In order to convert strings from whatever encoding you have to Perl's internal format, use L<Encode>. If you need any kind of control or options, use L<Net::LibIDN>. The included function here is only meant to assist in the most basic case, although that should cover a lot of real-world use cases.

Installation
============
Installation uses the normal `perl Makefile.PL && make && make test && make install` sequence. This assumes that `ldns` can be found in one of the places where the C compiler looks by default. `make test` assumes that it can send queries to the outside world.

There is a small part in the code that may not be compatible with non-Unix operating systems, in that it assumes that the file /dev/null exists. If you try using this on Windows, VMS, z/OS or something else non-Unix, I'd love to hear from you so we can sort that bit out.

/Calle Dybedahl <calle@init.se>, 9 December 2013