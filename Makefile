
.PHONY: all clean sample badsample
.SUFFIXES: .swift .swiftmodule .swiftdoc .o .dylib

SWIFT_LIBPATH = /Applications/Xcode6-Beta5.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx

MODULE_SWIFTS	= Enumerable.swift BadEnumerable.swift

MODULE_NAMES		= $(MODULE_SWIFTS:.swift=)
MODULE_SWIFTMODULES	= $(MODULE_SWIFTS:.swift=.swiftmodule)
MODULE_SWIFTDOCS	= $(MODULE_SWIFTS:.swift=.swiftdoc)
MODULE_OBJS		= $(MODULE_SWIFTS:.swift=.o)
MODULE_DYLIBS		= $(patsubst %,lib%.dylib,$(MODULE_NAMES))


all : $(MODULE_SWIFTMODULES) $(MODULE_DYLIBS)



.swift.swiftmodule .swift.swiftdoc :
	swiftc -module-name $(<:.swift=) -emit-module $<

.swift.o :
	swiftc -module-name $(<:.swift=) -emit-object $<

lib%.dylib : %.o
	libtool -L$(SWIFT_LIBPATH) -dynamic -lc -o $@ $<


clean :
	rm -f $(MODULE_SWIFTMODULES) $(MODULE_SWIFTDOCS) $(MODULE_OBJS) $(MODULE_DYLIBS)




sample : enumerable_sample.swift Enumerable.swiftmodule libEnumerable.dylib
	swift -I . -L . -lEnumerable enumerable_sample.swift

badsample : badEnumerable_sieve.swift BadEnumerable.swiftmodule libBadEnumerable.dylib
	swift -I . -L . -lBadEnumerable badEnumerable_sieve.swift

