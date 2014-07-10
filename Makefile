
.PHONY: all clean sample badsample
.SUFFIXES: .swift .swiftmodule .swiftdoc .o .dylib

SWIFT_LIBPATH = /Applications/Xcode6-Beta3.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx

MODULE_SWIFTS	= Enumerable.swift BadEnumerable.swift

MODULE_NAMES		= $(MODULE_SWIFTS:.swift=)
MODULE_SWIFTMODULES	= $(MODULE_SWIFTS:.swift=.swiftmodule)
MODULE_SWIFTDOCS	= $(MODULE_SWIFTS:.swift=.swiftdoc)
MODULE_OBJS		= $(MODULE_SWIFTS:.swift=.o)
MODULE_DYLIBS		= $(patsubst %,lib%.dylib,$(MODULE_NAMES))


all : $(MODULE_SWIFTMODULES) $(MODULE_DYLIBS)



.swift.swiftmodule .swift.swiftdoc :
	swift -module-name $(<:.swift=) -emit-module $<

.swift.o :
	swift -module-name $(<:.swift=) -emit-object $<

lib%.dylib : %.o
	libtool -L$(SWIFT_LIBPATH) -dynamic -lswift_stdlib_core -lc -o $@ $<


clean :
	rm -f $(MODULE_SWIFTMODULES) $(MODULE_SWIFTDOCS) $(MODULE_OBJS) $(MODULE_DYLIBS)




sample : enumerable_sample.swift Enumerable.swiftmodule libEnumerable.dylib
	swift -I . -L . -lEnumerable -i enumerable_sample.swift

badsample : badEnumerable_sieve.swift BadEnumerable.swiftmodule libBadEnumerable.dylib
	swift -I . -L . -lBadEnumerable -i badEnumerable_sieve.swift

