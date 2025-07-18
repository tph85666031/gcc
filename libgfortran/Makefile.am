## Process this file with automake to produce Makefile.in

AUTOMAKE_OPTIONS = foreign subdir-objects

ACLOCAL_AMFLAGS = -I .. -I ../config

## May be used by toolexeclibdir.
gcc_version := $(shell @get_gcc_base_ver@ $(top_srcdir)/../gcc/BASE-VER)

## Symbol versioning (copied from libssp).
if LIBGFOR_USE_SYMVER
# -Wc is only a libtool option.
comma = ,
PREPROCESS = $(subst -Wc$(comma), , $(COMPILE)) -E

gfortran.ver: $(srcdir)/gfortran.map kinds.inc
	$(EGREP) -v '#(#| |$$)' $< | \
	  $(PREPROCESS) -P -include config.h -include kinds.inc - > $@ || (rm -f $@ ; exit 1)

if LIBGFOR_USE_SYMVER_GNU
version_arg = -Wl,--version-script=gfortran.ver
version_dep = gfortran.ver
endif
if LIBGFOR_USE_SYMVER_SUN
version_arg = -Wl,-M,gfortran.ver-sun
version_dep = gfortran.ver-sun gfortran.ver
gfortran.ver-sun : gfortran.ver \
		$(top_srcdir)/../contrib/make_sunver.pl \
		$(libgfortran_la_OBJECTS) $(libgfortran_la_LIBADD)
	perl $(top_srcdir)/../contrib/make_sunver.pl \
	  gfortran.ver \
	  $(libgfortran_la_OBJECTS) $(libgfortran_la_LIBADD) \
	 > $@ || (rm -f $@ ; exit 1)
endif
else
version_arg =
version_dep =
endif
extra_darwin_ldflags_libgfortran = @extra_ldflags_libgfortran@
if ENABLE_DARWIN_AT_RPATH
extra_darwin_ldflags_libgfortran += -Wc,-nodefaultrpaths
extra_darwin_ldflags_libgfortran += -Wl,-rpath,@loader_path
endif

gfor_c_HEADERS = ISO_Fortran_binding.h
gfor_cdir = $(libdir)/gcc/$(target_alias)/$(gcc_version)/include

LTLDFLAGS = $(shell $(SHELL) $(top_srcdir)/../libtool-ldflags $(LDFLAGS)) \
	    $(lt_host_flags)

toolexeclib_LTLIBRARIES = libgfortran.la
toolexeclib_DATA = libgfortran.spec
libgfortran_la_LINK = $(LINK) $(libgfortran_la_LDFLAGS)
libgfortran_la_LDFLAGS = -version-info `grep -v '^\#' $(srcdir)/libtool-version` \
	$(LTLDFLAGS) $(LIBQUADLIB) ../libbacktrace/libbacktrace.la \
	$(HWCAP_LDFLAGS) \
	$(LIBM) $(extra_darwin_ldflags_libgfortran) \
	$(version_arg) -Wc,-shared-libgcc
libgfortran_la_DEPENDENCIES = $(version_dep) libgfortran.spec $(LIBQUADLIB_DEP)

cafexeclib_LTLIBRARIES = libcaf_single.la
cafexeclibdir = $(libdir)/gcc/$(target_alias)/$(gcc_version)$(MULTISUBDIR)
libcaf_single_la_SOURCES = caf/single.c
libcaf_single_la_LDFLAGS = -static
libcaf_single_la_DEPENDENCIES = caf/libcaf.h
libcaf_single_la_LINK = $(LINK) $(libcaf_single_la_LDFLAGS)

if IEEE_SUPPORT
fincludedir = $(libdir)/gcc/$(target_alias)/$(gcc_version)$(MULTISUBDIR)/finclude
nodist_finclude_HEADERS = ieee_arithmetic.mod ieee_exceptions.mod ieee_features.mod
endif

## io.h conflicts with a system header on some platforms, so
## use -iquote
AM_CPPFLAGS = -iquote$(srcdir)/io -I$(srcdir)/$(MULTISRCTOP)../gcc \
	      -I$(srcdir)/$(MULTISRCTOP)../gcc/config $(LIBQUADINCLUDE) \
	      -I$(MULTIBUILDTOP)../../$(host_subdir)/gcc \
	      -I$(srcdir)/$(MULTISRCTOP)../libgcc \
	      -I$(MULTIBUILDTOP)../libgcc \
	      -I$(srcdir)/$(MULTISRCTOP)../libbacktrace \
	      -I$(MULTIBUILDTOP)../libbacktrace \
	      -I../libbacktrace

# Fortran rules for complex multiplication and division
AM_CFLAGS += -fcx-fortran-rules

# Use -ffunction-sections -fdata-sections if supported by the compiler
AM_CFLAGS += $(SECTION_FLAGS)

# Some targets require additional compiler options for IEEE compatibility.
AM_CFLAGS += $(IEEE_FLAGS)
AM_FCFLAGS += $(IEEE_FLAGS)

if LIBGFOR_MINIMAL
AM_CFLAGS += -DLIBGFOR_MINIMAL
endif

gfor_io_src= \
io/size_from_kind.c

if !LIBGFOR_MINIMAL

gfor_io_src+= \
io/close.c \
io/file_pos.c \
io/format.c \
io/inquire.c \
io/intrinsics.c \
io/list_read.c \
io/lock.c \
io/open.c \
io/read.c \
io/transfer.c \
io/transfer128.c \
io/unit.c \
io/unix.c \
io/write.c \
io/fbuf.c \
io/async.c

endif

gfor_io_headers= \
io/io.h \
io/fbuf.h \
io/format.h \
io/unix.h \
io/async.h

gfor_helper_src= \
intrinsics/associated.c \
intrinsics/abort.c \
intrinsics/args.c \
intrinsics/cshift0.c \
intrinsics/eoshift0.c \
intrinsics/eoshift2.c \
intrinsics/erfc_scaled.c \
intrinsics/extends_type_of.c \
intrinsics/fnum.c \
intrinsics/ierrno.c \
intrinsics/ishftc.c \
intrinsics/is_contiguous.c \
intrinsics/mvbits.c \
intrinsics/move_alloc.c \
intrinsics/pack_generic.c \
intrinsics/selected_char_kind.c \
intrinsics/size.c \
intrinsics/spread_generic.c \
intrinsics/string_intrinsics.c \
intrinsics/rand.c \
intrinsics/random.c \
intrinsics/reduce.c \
intrinsics/reshape_generic.c \
intrinsics/reshape_packed.c \
intrinsics/selected_int_kind.f90 \
intrinsics/selected_real_kind.f90 \
intrinsics/trigd.c \
intrinsics/unpack_generic.c \
runtime/in_pack_generic.c \
runtime/in_unpack_generic.c \
runtime/in_pack_class.c \
runtime/in_unpack_class.c

if !LIBGFOR_MINIMAL

gfor_helper_src+= \
intrinsics/access.c \
intrinsics/c99_functions.c \
intrinsics/chdir.c \
intrinsics/chmod.c \
intrinsics/clock.c \
intrinsics/cpu_time.c \
intrinsics/ctime.c \
intrinsics/date_and_time.c \
intrinsics/dtime.c \
intrinsics/env.c \
intrinsics/etime.c \
intrinsics/execute_command_line.c \
intrinsics/exit.c \
intrinsics/gerror.c \
intrinsics/getcwd.c \
intrinsics/getlog.c \
intrinsics/getXid.c \
intrinsics/hostnm.c \
intrinsics/kill.c \
intrinsics/link.c \
intrinsics/perror.c \
intrinsics/signal.c \
intrinsics/sleep.c \
intrinsics/system.c \
intrinsics/rename.c \
intrinsics/stat.c \
intrinsics/symlnk.c \
intrinsics/system_clock.c \
intrinsics/time.c \
intrinsics/umask.c \
intrinsics/unlink.c

endif

if IEEE_SUPPORT

gfor_ieee_helper_src=ieee/ieee_helper.c

gfor_helper_src+=ieee/ieee_helper.c

gfor_ieee_src= \
ieee/ieee_arithmetic.F90 \
ieee/ieee_exceptions.F90 \
ieee/ieee_features.F90

else

gfor_ieee_src=

endif

gfor_src= \
runtime/bounds.c \
runtime/compile_options.c \
runtime/memory.c \
runtime/string.c \
runtime/select.c

if LIBGFOR_MINIMAL

gfor_src+= runtime/minimal.c

else

gfor_src+= \
runtime/backtrace.c \
runtime/convert_char.c \
runtime/environ.c \
runtime/error.c \
runtime/fpu.c \
runtime/main.c \
runtime/pause.c \
runtime/stop.c

endif

i_matmul_c= \
generated/matmul_i1.c \
generated/matmul_i2.c \
generated/matmul_i4.c \
generated/matmul_i8.c \
generated/matmul_i16.c \
generated/matmul_r4.c \
generated/matmul_r8.c \
generated/matmul_r10.c \
generated/matmul_r16.c \
generated/matmul_r17.c \
generated/matmul_c4.c \
generated/matmul_c8.c \
generated/matmul_c10.c \
generated/matmul_c16.c \
generated/matmul_c17.c

i_matmulavx128_c= \
generated/matmulavx128_i1.c \
generated/matmulavx128_i2.c \
generated/matmulavx128_i4.c \
generated/matmulavx128_i8.c \
generated/matmulavx128_i16.c \
generated/matmulavx128_r4.c \
generated/matmulavx128_r8.c \
generated/matmulavx128_r10.c \
generated/matmulavx128_r16.c \
generated/matmulavx128_r17.c \
generated/matmulavx128_c4.c \
generated/matmulavx128_c8.c \
generated/matmulavx128_c10.c \
generated/matmulavx128_c16.c \
generated/matmulavx128_c17.c

i_matmull_c= \
generated/matmul_l4.c \
generated/matmul_l8.c \
generated/matmul_l16.c

gfor_built_src= \
generated/all_l1.c \
generated/all_l2.c \
generated/all_l4.c \
generated/all_l8.c \
generated/all_l16.c \
generated/any_l1.c \
generated/any_l2.c \
generated/any_l4.c \
generated/any_l8.c \
generated/any_l16.c \
generated/count_1_l.c \
generated/count_2_l.c \
generated/count_4_l.c \
generated/count_8_l.c \
generated/count_16_l.c \
generated/maxloc0_4_i1.c \
generated/maxloc0_8_i1.c \
generated/maxloc0_16_i1.c \
generated/maxloc0_4_i2.c \
generated/maxloc0_8_i2.c \
generated/maxloc0_16_i2.c \
generated/maxloc0_4_i4.c \
generated/maxloc0_8_i4.c \
generated/maxloc0_16_i4.c \
generated/maxloc0_4_i8.c \
generated/maxloc0_8_i8.c \
generated/maxloc0_16_i8.c \
generated/maxloc0_4_i16.c \
generated/maxloc0_8_i16.c \
generated/maxloc0_16_i16.c \
generated/maxloc0_4_m1.c \
generated/maxloc0_8_m1.c \
generated/maxloc0_16_m1.c \
generated/maxloc0_4_m2.c \
generated/maxloc0_8_m2.c \
generated/maxloc0_16_m2.c \
generated/maxloc0_4_m4.c \
generated/maxloc0_8_m4.c \
generated/maxloc0_16_m4.c \
generated/maxloc0_4_m8.c \
generated/maxloc0_8_m8.c \
generated/maxloc0_16_m8.c \
generated/maxloc0_4_m16.c \
generated/maxloc0_8_m16.c \
generated/maxloc0_16_m16.c \
generated/maxloc0_4_r4.c \
generated/maxloc0_8_r4.c \
generated/maxloc0_16_r4.c \
generated/maxloc0_4_r8.c \
generated/maxloc0_8_r8.c \
generated/maxloc0_16_r8.c \
generated/maxloc0_4_r10.c \
generated/maxloc0_8_r10.c \
generated/maxloc0_16_r10.c \
generated/maxloc0_4_r16.c \
generated/maxloc0_8_r16.c \
generated/maxloc0_16_r16.c \
generated/maxloc0_4_r17.c \
generated/maxloc0_8_r17.c \
generated/maxloc0_16_r17.c \
generated/maxloc1_4_i1.c \
generated/maxloc1_8_i1.c \
generated/maxloc1_16_i1.c \
generated/maxloc1_4_i2.c \
generated/maxloc1_8_i2.c \
generated/maxloc1_16_i2.c \
generated/maxloc1_4_i4.c \
generated/maxloc1_8_i4.c \
generated/maxloc1_16_i4.c \
generated/maxloc1_4_i8.c \
generated/maxloc1_8_i8.c \
generated/maxloc1_16_i8.c \
generated/maxloc1_4_i16.c \
generated/maxloc1_8_i16.c \
generated/maxloc1_16_i16.c \
generated/maxloc1_4_m1.c \
generated/maxloc1_8_m1.c \
generated/maxloc1_16_m1.c \
generated/maxloc1_4_m2.c \
generated/maxloc1_8_m2.c \
generated/maxloc1_16_m2.c \
generated/maxloc1_4_m4.c \
generated/maxloc1_8_m4.c \
generated/maxloc1_16_m4.c \
generated/maxloc1_4_m8.c \
generated/maxloc1_8_m8.c \
generated/maxloc1_16_m8.c \
generated/maxloc1_4_m16.c \
generated/maxloc1_8_m16.c \
generated/maxloc1_16_m16.c \
generated/maxloc1_4_r4.c \
generated/maxloc1_8_r4.c \
generated/maxloc1_16_r4.c \
generated/maxloc1_4_r8.c \
generated/maxloc1_8_r8.c \
generated/maxloc1_16_r8.c \
generated/maxloc1_4_r10.c \
generated/maxloc1_8_r10.c \
generated/maxloc1_16_r10.c \
generated/maxloc1_4_r16.c \
generated/maxloc1_8_r16.c \
generated/maxloc1_16_r16.c \
generated/maxloc1_4_r17.c \
generated/maxloc1_8_r17.c \
generated/maxloc1_16_r17.c \
generated/maxval_i1.c \
generated/maxval_i2.c \
generated/maxval_i4.c \
generated/maxval_i8.c \
generated/maxval_i16.c \
generated/maxval_m1.c \
generated/maxval_m2.c \
generated/maxval_m4.c \
generated/maxval_m8.c \
generated/maxval_m16.c \
generated/maxval_r4.c \
generated/maxval_r8.c \
generated/maxval_r10.c \
generated/maxval_r16.c \
generated/maxval_r17.c \
generated/minloc0_4_i1.c \
generated/minloc0_8_i1.c \
generated/minloc0_16_i1.c \
generated/minloc0_4_i2.c \
generated/minloc0_8_i2.c \
generated/minloc0_16_i2.c \
generated/minloc0_4_i4.c \
generated/minloc0_8_i4.c \
generated/minloc0_16_i4.c \
generated/minloc0_4_i8.c \
generated/minloc0_8_i8.c \
generated/minloc0_16_i8.c \
generated/minloc0_4_i16.c \
generated/minloc0_8_i16.c \
generated/minloc0_16_i16.c \
generated/minloc0_4_m1.c \
generated/minloc0_8_m1.c \
generated/minloc0_16_m1.c \
generated/minloc0_4_m2.c \
generated/minloc0_8_m2.c \
generated/minloc0_16_m2.c \
generated/minloc0_4_m4.c \
generated/minloc0_8_m4.c \
generated/minloc0_16_m4.c \
generated/minloc0_4_m8.c \
generated/minloc0_8_m8.c \
generated/minloc0_16_m8.c \
generated/minloc0_4_m16.c \
generated/minloc0_8_m16.c \
generated/minloc0_16_m16.c \
generated/minloc0_4_r4.c \
generated/minloc0_8_r4.c \
generated/minloc0_16_r4.c \
generated/minloc0_4_r8.c \
generated/minloc0_8_r8.c \
generated/minloc0_16_r8.c \
generated/minloc0_4_r10.c \
generated/minloc0_8_r10.c \
generated/minloc0_16_r10.c \
generated/minloc0_4_r16.c \
generated/minloc0_8_r16.c \
generated/minloc0_16_r16.c \
generated/minloc0_4_r17.c \
generated/minloc0_8_r17.c \
generated/minloc0_16_r17.c \
generated/minloc1_4_i1.c \
generated/minloc1_8_i1.c \
generated/minloc1_16_i1.c \
generated/minloc1_4_i2.c \
generated/minloc1_8_i2.c \
generated/minloc1_16_i2.c \
generated/minloc1_4_i4.c \
generated/minloc1_8_i4.c \
generated/minloc1_16_i4.c \
generated/minloc1_4_i8.c \
generated/minloc1_8_i8.c \
generated/minloc1_16_i8.c \
generated/minloc1_4_i16.c \
generated/minloc1_8_i16.c \
generated/minloc1_16_i16.c \
generated/minloc1_4_m1.c \
generated/minloc1_8_m1.c \
generated/minloc1_16_m1.c \
generated/minloc1_4_m2.c \
generated/minloc1_8_m2.c \
generated/minloc1_16_m2.c \
generated/minloc1_4_m4.c \
generated/minloc1_8_m4.c \
generated/minloc1_16_m4.c \
generated/minloc1_4_m8.c \
generated/minloc1_8_m8.c \
generated/minloc1_16_m8.c \
generated/minloc1_4_m16.c \
generated/minloc1_8_m16.c \
generated/minloc1_16_m16.c \
generated/minloc1_4_r4.c \
generated/minloc1_8_r4.c \
generated/minloc1_16_r4.c \
generated/minloc1_4_r8.c \
generated/minloc1_8_r8.c \
generated/minloc1_16_r8.c \
generated/minloc1_4_r10.c \
generated/minloc1_8_r10.c \
generated/minloc1_16_r10.c \
generated/minloc1_4_r16.c \
generated/minloc1_8_r16.c \
generated/minloc1_16_r16.c \
generated/minloc1_4_r17.c \
generated/minloc1_8_r17.c \
generated/minloc1_16_r17.c \
generated/minval_i1.c \
generated/minval_i2.c \
generated/minval_i4.c \
generated/minval_i8.c \
generated/minval_i16.c \
generated/minval_m1.c \
generated/minval_m2.c \
generated/minval_m4.c \
generated/minval_m8.c \
generated/minval_m16.c \
generated/minval_r4.c \
generated/minval_r8.c \
generated/minval_r10.c \
generated/minval_r16.c \
generated/minval_r17.c \
generated/product_i1.c \
generated/product_i2.c \
generated/product_i4.c \
generated/product_i8.c \
generated/product_i16.c \
generated/product_r4.c \
generated/product_r8.c \
generated/product_r10.c \
generated/product_r16.c \
generated/product_r17.c \
generated/product_c4.c \
generated/product_c8.c \
generated/product_c10.c \
generated/product_c16.c \
generated/product_c17.c \
generated/sum_i1.c \
generated/sum_i2.c \
generated/sum_i4.c \
generated/sum_i8.c \
generated/sum_i16.c \
generated/sum_r4.c \
generated/sum_r8.c \
generated/sum_r10.c \
generated/sum_r16.c \
generated/sum_r17.c \
generated/sum_c4.c \
generated/sum_c8.c \
generated/sum_c10.c \
generated/sum_c16.c \
generated/sum_c17.c \
generated/bessel_r4.c \
generated/bessel_r8.c \
generated/bessel_r10.c \
generated/bessel_r16.c \
generated/bessel_r17.c \
generated/iall_i1.c \
generated/iall_i2.c \
generated/iall_i4.c \
generated/iall_i8.c \
generated/iall_i16.c \
generated/iany_i1.c \
generated/iany_i2.c \
generated/iany_i4.c \
generated/iany_i8.c \
generated/iany_i16.c \
generated/iparity_i1.c \
generated/iparity_i2.c \
generated/iparity_i4.c \
generated/iparity_i8.c \
generated/iparity_i16.c \
generated/norm2_r4.c \
generated/norm2_r8.c \
generated/norm2_r10.c \
generated/norm2_r16.c \
generated/norm2_r17.c \
generated/parity_l1.c \
generated/parity_l2.c \
generated/parity_l4.c \
generated/parity_l8.c \
generated/parity_l16.c \
generated/shape_i1.c \
generated/shape_i2.c \
generated/shape_i4.c \
generated/shape_i8.c \
generated/shape_i16.c \
generated/eoshift1_4.c \
generated/eoshift1_8.c \
generated/eoshift1_16.c \
generated/eoshift3_4.c \
generated/eoshift3_8.c \
generated/eoshift3_16.c \
generated/cshift1_4.c \
generated/cshift1_8.c \
generated/cshift1_16.c \
generated/reshape_i4.c \
generated/reshape_i8.c \
generated/reshape_i16.c \
generated/reshape_r4.c \
generated/reshape_r8.c \
generated/reshape_r10.c \
generated/reshape_r16.c \
generated/reshape_r17.c \
generated/reshape_c4.c \
generated/reshape_c8.c \
generated/reshape_c10.c \
generated/reshape_c16.c \
generated/reshape_c17.c \
generated/in_pack_i1.c \
generated/in_pack_i2.c \
generated/in_pack_i4.c \
generated/in_pack_i8.c \
generated/in_pack_i16.c \
generated/in_pack_r4.c \
generated/in_pack_r8.c \
generated/in_pack_r10.c \
generated/in_pack_r16.c \
generated/in_pack_r17.c \
generated/in_pack_c4.c \
generated/in_pack_c8.c \
generated/in_pack_c10.c \
generated/in_pack_c16.c \
generated/in_pack_c17.c \
generated/in_unpack_i1.c \
generated/in_unpack_i2.c \
generated/in_unpack_i4.c \
generated/in_unpack_i8.c \
generated/in_unpack_i16.c \
generated/in_unpack_r4.c \
generated/in_unpack_r8.c \
generated/in_unpack_r10.c \
generated/in_unpack_r16.c \
generated/in_unpack_r17.c \
generated/in_unpack_c4.c \
generated/in_unpack_c8.c \
generated/in_unpack_c10.c \
generated/in_unpack_c16.c \
generated/in_unpack_c17.c \
generated/pow_i4_i4.c \
generated/pow_i8_i4.c \
generated/pow_i16_i4.c \
generated/pow_r16_i4.c \
generated/pow_r17_i4.c \
generated/pow_c4_i4.c \
generated/pow_c8_i4.c \
generated/pow_c10_i4.c \
generated/pow_c16_i4.c \
generated/pow_c17_i4.c \
generated/pow_i4_i8.c \
generated/pow_i8_i8.c \
generated/pow_i16_i8.c \
generated/pow_r4_i8.c \
generated/pow_r8_i8.c \
generated/pow_r10_i8.c \
generated/pow_r16_i8.c \
generated/pow_r17_i8.c \
generated/pow_c4_i8.c \
generated/pow_c8_i8.c \
generated/pow_c10_i8.c \
generated/pow_c16_i8.c \
generated/pow_c17_i8.c \
generated/pow_i4_i16.c \
generated/pow_i8_i16.c \
generated/pow_i16_i16.c \
generated/pow_r4_i16.c \
generated/pow_r8_i16.c \
generated/pow_r10_i16.c \
generated/pow_r16_i16.c \
generated/pow_r17_i16.c \
generated/pow_c4_i16.c \
generated/pow_c8_i16.c \
generated/pow_c10_i16.c \
generated/pow_c16_i16.c \
generated/pow_c17_i16.c \
generated/pack_i1.c \
generated/pack_i2.c \
generated/pack_i4.c \
generated/pack_i8.c \
generated/pack_i16.c \
generated/pack_r4.c \
generated/pack_r8.c \
generated/pack_r10.c \
generated/pack_r16.c \
generated/pack_r17.c \
generated/pack_c4.c \
generated/pack_c8.c \
generated/pack_c10.c \
generated/pack_c16.c \
generated/pack_c17.c \
generated/unpack_i1.c \
generated/unpack_i2.c \
generated/unpack_i4.c \
generated/unpack_i8.c \
generated/unpack_i16.c \
generated/unpack_r4.c \
generated/unpack_r8.c \
generated/unpack_r10.c \
generated/unpack_r16.c \
generated/unpack_r17.c \
generated/unpack_c4.c \
generated/unpack_c8.c \
generated/unpack_c10.c \
generated/unpack_c16.c \
generated/unpack_c17.c \
generated/spread_i1.c \
generated/spread_i2.c \
generated/spread_i4.c \
generated/spread_i8.c \
generated/spread_i16.c \
generated/spread_r4.c \
generated/spread_r8.c \
generated/spread_r10.c \
generated/spread_r16.c \
generated/spread_r17.c \
generated/spread_c4.c \
generated/spread_c8.c \
generated/spread_c10.c \
generated/spread_c16.c \
generated/spread_c17.c \
generated/cshift0_i1.c \
generated/cshift0_i2.c \
generated/cshift0_i4.c \
generated/cshift0_i8.c \
generated/cshift0_i16.c \
generated/cshift0_r4.c \
generated/cshift0_r8.c \
generated/cshift0_r10.c \
generated/cshift0_r16.c \
generated/cshift0_r17.c \
generated/cshift0_c4.c \
generated/cshift0_c8.c \
generated/cshift0_c10.c \
generated/cshift0_c16.c \
generated/cshift0_c17.c \
generated/cshift1_4_i1.c \
generated/cshift1_4_i2.c \
generated/cshift1_4_i4.c \
generated/cshift1_4_i8.c \
generated/cshift1_4_i16.c \
generated/cshift1_4_r4.c \
generated/cshift1_4_r8.c \
generated/cshift1_4_r10.c \
generated/cshift1_4_r16.c \
generated/cshift1_4_r17.c \
generated/cshift1_4_c4.c \
generated/cshift1_4_c8.c \
generated/cshift1_4_c10.c \
generated/cshift1_4_c16.c \
generated/cshift1_4_c17.c \
generated/cshift1_8_i1.c \
generated/cshift1_8_i2.c \
generated/cshift1_8_i4.c \
generated/cshift1_8_i8.c \
generated/cshift1_8_i16.c \
generated/cshift1_8_r4.c \
generated/cshift1_8_r8.c \
generated/cshift1_8_r10.c \
generated/cshift1_8_r16.c \
generated/cshift1_8_r17.c \
generated/cshift1_8_c4.c \
generated/cshift1_8_c8.c \
generated/cshift1_8_c10.c \
generated/cshift1_8_c16.c \
generated/cshift1_8_c17.c \
generated/cshift1_16_i1.c \
generated/cshift1_16_i2.c \
generated/cshift1_16_i4.c \
generated/cshift1_16_i8.c \
generated/cshift1_16_i16.c \
generated/cshift1_16_r4.c \
generated/cshift1_16_r8.c \
generated/cshift1_16_r10.c \
generated/cshift1_16_r16.c \
generated/cshift1_16_r17.c \
generated/cshift1_16_c4.c \
generated/cshift1_16_c8.c \
generated/cshift1_16_c10.c \
generated/cshift1_16_c16.c \
generated/cshift1_16_c17.c \
generated/findloc0_i1.c \
generated/findloc0_i2.c \
generated/findloc0_i4.c \
generated/findloc0_i8.c \
generated/findloc0_i16.c \
generated/findloc0_r4.c \
generated/findloc0_r8.c \
generated/findloc0_r10.c \
generated/findloc0_r16.c \
generated/findloc0_r17.c \
generated/findloc0_c4.c \
generated/findloc0_c8.c \
generated/findloc0_c10.c \
generated/findloc0_c16.c \
generated/findloc0_c17.c \
generated/findloc0_s1.c \
generated/findloc0_s4.c \
generated/findloc1_i1.c \
generated/findloc1_i2.c \
generated/findloc1_i4.c \
generated/findloc1_i8.c \
generated/findloc1_i16.c \
generated/findloc1_r4.c \
generated/findloc1_r8.c \
generated/findloc1_r10.c \
generated/findloc1_r16.c \
generated/findloc1_r17.c \
generated/findloc1_c4.c \
generated/findloc1_c8.c \
generated/findloc1_c10.c \
generated/findloc1_c16.c \
generated/findloc1_c17.c \
generated/findloc1_s1.c \
generated/findloc1_s4.c \
generated/findloc2_s1.c \
generated/findloc2_s4.c \
generated/maxloc0_4_s1.c \
generated/maxloc0_4_s4.c \
generated/maxloc0_8_s1.c \
generated/maxloc0_8_s4.c \
generated/maxloc0_16_s1.c \
generated/maxloc0_16_s4.c \
generated/maxloc1_4_s1.c \
generated/maxloc1_4_s4.c \
generated/maxloc1_8_s1.c \
generated/maxloc1_8_s4.c \
generated/maxloc1_16_s1.c \
generated/maxloc1_16_s4.c \
generated/maxloc2_4_s1.c \
generated/maxloc2_4_s4.c \
generated/maxloc2_8_s1.c \
generated/maxloc2_8_s4.c \
generated/maxloc2_16_s1.c \
generated/maxloc2_16_s4.c \
generated/maxval0_s1.c \
generated/maxval0_s4.c \
generated/maxval1_s1.c \
generated/maxval1_s4.c \
generated/minloc0_4_s1.c \
generated/minloc0_4_s4.c \
generated/minloc0_8_s1.c \
generated/minloc0_8_s4.c \
generated/minloc0_16_s1.c \
generated/minloc0_16_s4.c \
generated/minloc1_4_s1.c \
generated/minloc1_4_s4.c \
generated/minloc1_8_s1.c \
generated/minloc1_8_s4.c \
generated/minloc1_16_s1.c \
generated/minloc1_16_s4.c \
generated/minloc2_4_s1.c \
generated/minloc2_4_s4.c \
generated/minloc2_8_s1.c \
generated/minloc2_8_s4.c \
generated/minloc2_16_s1.c \
generated/minloc2_16_s4.c \
generated/minval0_s1.c \
generated/minval0_s4.c \
generated/minval1_s1.c \
generated/minval1_s4.c \
generated/pow_m1_m1.c \
generated/pow_m1_m2.c \
generated/pow_m1_m4.c \
generated/pow_m1_m8.c \
generated/pow_m1_m16.c \
generated/pow_m2_m1.c \
generated/pow_m2_m2.c \
generated/pow_m2_m4.c \
generated/pow_m2_m8.c \
generated/pow_m2_m16.c \
generated/pow_m4_m1.c \
generated/pow_m4_m2.c \
generated/pow_m4_m4.c \
generated/pow_m4_m8.c \
generated/pow_m4_m16.c \
generated/pow_m8_m1.c \
generated/pow_m8_m2.c \
generated/pow_m8_m4.c \
generated/pow_m8_m8.c \
generated/pow_m8_m16.c \
generated/pow_m16_m1.c \
generated/pow_m16_m2.c \
generated/pow_m16_m4.c \
generated/pow_m16_m8.c \
generated/pow_m16_m16.c \
$(i_matmul_c) $(i_matmull_c) $(i_matmulavx128_c) \
selected_int_kind.inc selected_real_kind.inc kinds.h \
kinds.inc c99_protos.inc fpu-target.h fpu-target.inc \
include/ISO_Fortran_binding.h runtime/ISO_Fortran_binding.c

# Specifics
gfor_specific_src= \
generated/_abs_c4.F90 \
generated/_abs_c8.F90 \
generated/_abs_c10.F90 \
generated/_abs_c16.F90 \
generated/_abs_c17.F90 \
generated/_abs_i4.F90 \
generated/_abs_i8.F90 \
generated/_abs_i16.F90 \
generated/_abs_r4.F90 \
generated/_abs_r8.F90 \
generated/_abs_r10.F90 \
generated/_abs_r16.F90 \
generated/_abs_r17.F90 \
generated/_aimag_c4.F90 \
generated/_aimag_c8.F90 \
generated/_aimag_c10.F90 \
generated/_aimag_c16.F90 \
generated/_aimag_c17.F90 \
generated/_exp_r4.F90 \
generated/_exp_r8.F90 \
generated/_exp_r10.F90 \
generated/_exp_r16.F90 \
generated/_exp_r17.F90 \
generated/_exp_c4.F90 \
generated/_exp_c8.F90 \
generated/_exp_c10.F90 \
generated/_exp_c16.F90 \
generated/_exp_c17.F90 \
generated/_log_r4.F90 \
generated/_log_r8.F90 \
generated/_log_r10.F90 \
generated/_log_r16.F90 \
generated/_log_r17.F90 \
generated/_log_c4.F90 \
generated/_log_c8.F90 \
generated/_log_c10.F90 \
generated/_log_c16.F90 \
generated/_log_c17.F90 \
generated/_log10_r4.F90 \
generated/_log10_r8.F90 \
generated/_log10_r10.F90 \
generated/_log10_r16.F90 \
generated/_log10_r17.F90 \
generated/_sqrt_r4.F90 \
generated/_sqrt_r8.F90 \
generated/_sqrt_r10.F90 \
generated/_sqrt_r16.F90 \
generated/_sqrt_r17.F90 \
generated/_sqrt_c4.F90 \
generated/_sqrt_c8.F90 \
generated/_sqrt_c10.F90 \
generated/_sqrt_c16.F90 \
generated/_sqrt_c17.F90 \
generated/_asin_r4.F90 \
generated/_asin_r8.F90 \
generated/_asin_r10.F90 \
generated/_asin_r16.F90 \
generated/_asin_r17.F90 \
generated/_asinh_r4.F90 \
generated/_asinh_r8.F90 \
generated/_asinh_r10.F90 \
generated/_asinh_r16.F90 \
generated/_asinh_r17.F90 \
generated/_acos_r4.F90 \
generated/_acos_r8.F90 \
generated/_acos_r10.F90 \
generated/_acos_r16.F90 \
generated/_acos_r17.F90 \
generated/_acosh_r4.F90 \
generated/_acosh_r8.F90 \
generated/_acosh_r10.F90 \
generated/_acosh_r16.F90 \
generated/_acosh_r17.F90 \
generated/_atan_r4.F90 \
generated/_atan_r8.F90 \
generated/_atan_r10.F90 \
generated/_atan_r16.F90 \
generated/_atan_r17.F90 \
generated/_atanh_r4.F90 \
generated/_atanh_r8.F90 \
generated/_atanh_r10.F90 \
generated/_atanh_r16.F90 \
generated/_atanh_r17.F90 \
generated/_sin_r4.F90 \
generated/_sin_r8.F90 \
generated/_sin_r10.F90 \
generated/_sin_r16.F90 \
generated/_sin_r17.F90 \
generated/_sin_c4.F90 \
generated/_sin_c8.F90 \
generated/_sin_c10.F90 \
generated/_sin_c16.F90 \
generated/_sin_c17.F90 \
generated/_cos_r4.F90 \
generated/_cos_r8.F90 \
generated/_cos_r10.F90 \
generated/_cos_r16.F90 \
generated/_cos_r17.F90 \
generated/_cos_c4.F90 \
generated/_cos_c8.F90 \
generated/_cos_c10.F90 \
generated/_cos_c16.F90 \
generated/_cos_c17.F90 \
generated/_tan_r4.F90 \
generated/_tan_r8.F90 \
generated/_tan_r10.F90 \
generated/_tan_r16.F90 \
generated/_tan_r17.F90 \
generated/_sinh_r4.F90 \
generated/_sinh_r8.F90 \
generated/_sinh_r10.F90 \
generated/_sinh_r16.F90 \
generated/_sinh_r17.F90 \
generated/_cosh_r4.F90 \
generated/_cosh_r8.F90 \
generated/_cosh_r10.F90 \
generated/_cosh_r16.F90 \
generated/_cosh_r17.F90 \
generated/_tanh_r4.F90 \
generated/_tanh_r8.F90 \
generated/_tanh_r10.F90 \
generated/_tanh_r16.F90 \
generated/_tanh_r17.F90 \
generated/_conjg_c4.F90 \
generated/_conjg_c8.F90 \
generated/_conjg_c10.F90 \
generated/_conjg_c16.F90 \
generated/_conjg_c17.F90 \
generated/_aint_r4.F90 \
generated/_aint_r8.F90 \
generated/_aint_r10.F90 \
generated/_aint_r16.F90 \
generated/_aint_r17.F90 \
generated/_anint_r4.F90 \
generated/_anint_r8.F90 \
generated/_anint_r10.F90 \
generated/_anint_r16.F90 \
generated/_anint_r17.F90 \
generated/_sign_i4.F90 \
generated/_sign_i8.F90 \
generated/_sign_i16.F90 \
generated/_sign_r4.F90 \
generated/_sign_r8.F90 \
generated/_sign_r10.F90 \
generated/_sign_r16.F90 \
generated/_sign_r17.F90 \
generated/_dim_i4.F90 \
generated/_dim_i8.F90 \
generated/_dim_i16.F90 \
generated/_dim_r4.F90 \
generated/_dim_r8.F90 \
generated/_dim_r10.F90 \
generated/_dim_r16.F90 \
generated/_dim_r17.F90 \
generated/_atan2_r4.F90 \
generated/_atan2_r8.F90 \
generated/_atan2_r10.F90 \
generated/_atan2_r16.F90 \
generated/_atan2_r17.F90 \
generated/_mod_i4.F90 \
generated/_mod_i8.F90 \
generated/_mod_i16.F90 \
generated/_mod_r4.F90 \
generated/_mod_r8.F90 \
generated/_mod_r10.F90 \
generated/_mod_r16.F90 \
generated/_mod_r17.F90 \
generated/misc_specifics.F90 \
intrinsics/dprod_r8.f90 \
intrinsics/f2c_specifics.F90 \
intrinsics/random_init.f90

# Turn on vectorization and loop unrolling for matmul.
$(patsubst %.c,%.lo,$(i_matmul_c)): AM_CFLAGS += -ffast-math -ftree-vectorize -funroll-loops --param max-unroll-times=4

if HAVE_AVX128
# Turn on AVX128 for AMD-specific matmul, but only if the compiler understands -mprefer-avx128
$(patsubst %.c,%.lo,$(i_matmulavx128_c)): AM_CFLAGS += -ffast-math -ftree-vectorize -funroll-loops --param max-unroll-times=4 -mprefer-avx128
endif
# Logical matmul doesn't vectorize.
$(patsubst %.c,%.lo,$(i_matmull_c)): AM_CFLAGS += -funroll-loops

# Add the -fallow-leading-underscore option when needed
$(patsubst %.F90,%.lo,$(patsubst %.f90,%.lo,$(gfor_specific_src))): AM_FCFLAGS += -fallow-leading-underscore -fbuilding-libgfortran
intrinsics/selected_real_kind.lo intrinsics/selected_int_kind.lo: AM_FCFLAGS += -fallow-leading-underscore -fbuilding-libgfortran

# Build *_r17.F90 and *_c17.F90 with additional -mabi=ieeelongdouble on powerpc64le-linux.

if HAVE_REAL_17
$(patsubst %_r16.F90,%_r16.lo,$(gfor_specific_src)): AM_FCFLAGS += -mabi=ibmlongdouble
$(patsubst %_c16.F90,%_c16.lo,$(gfor_specific_src)): AM_FCFLAGS += -mabi=ibmlongdouble
$(patsubst %_r17.F90,%_r17.lo,$(gfor_specific_src)): AM_FCFLAGS += -mabi=ieeelongdouble -D__powerpc64__
$(patsubst %_c17.F90,%_c17.lo,$(gfor_specific_src)): AM_FCFLAGS += -mabi=ieeelongdouble -D__powerpc64__
$(patsubst %_r16.c,%_r16.lo,$(gfor_built_src)): AM_CFLAGS += -mabi=ibmlongdouble
$(patsubst %_c16.c,%_c16.lo,$(gfor_built_src)): AM_CFLAGS += -mabi=ibmlongdouble
$(patsubst %_r17.c,%_r17.lo,$(gfor_built_src)): AM_CFLAGS += -mabi=ieeelongdouble
$(patsubst %_c17.c,%_c17.lo,$(gfor_built_src)): AM_CFLAGS += -mabi=ieeelongdouble
endif

if IEEE_SUPPORT
# Add flags for IEEE modules
$(patsubst %.F90,%.lo,$(gfor_ieee_src)): AM_FCFLAGS += -Wno-unused-dummy-argument -Wno-c-binding-type -ffree-line-length-0 -fallow-leading-underscore -fsignaling-nans -fbuilding-libgfortran

# Add flags for IEEE helper code
$(patsubst %.c,%.lo,$(gfor_ieee_helper_src)): AM_CFLAGS += -fsignaling-nans
endif


# Dependencies between IEEE_ARITHMETIC and IEEE_EXCEPTIONS
ieee/ieee_arithmetic.lo: ieee/ieee_arithmetic.F90 ieee/ieee_exceptions.lo
	$(LTPPFCCOMPILE) -c -o $@ $<

ieee_features.mod: ieee/ieee_features.lo
	:
ieee_exceptions.mod: ieee/ieee_exceptions.lo
	:
ieee_arithmetic.mod: ieee/ieee_arithmetic.lo
	:

BUILT_SOURCES=$(gfor_built_src)

libgfortran_la_SOURCES = $(gfor_src) $(gfor_built_src) $(gfor_io_src) \
	$(gfor_helper_src) $(gfor_ieee_src) $(gfor_io_headers) $(gfor_specific_src)

kinds.h: $(srcdir)/mk-kinds-h.sh
	$(SHELL) $(srcdir)/mk-kinds-h.sh '@LIBGOMP_CHECKED_INT_KINDS@' \
					 '@LIBGOMP_CHECKED_REAL_KINDS@' \
					 '$(FCCOMPILE)' '@USE_IEC_60559@' > $@ || rm $@

kinds.inc: kinds.h $(srcdir)/kinds-override.h
	cat kinds.h $(srcdir)/kinds-override.h | grep '^#' | grep -v include > $@

c99_protos.inc: $(srcdir)/c99_protos.h
	grep '^#' < $(srcdir)/c99_protos.h > $@

selected_int_kind.inc: $(srcdir)/mk-sik-inc.sh
	$(SHELL) $(srcdir)/mk-sik-inc.sh '@LIBGOMP_CHECKED_INT_KINDS@' '$(FCCOMPILE)' > $@ || rm $@

selected_real_kind.inc: $(srcdir)/mk-srk-inc.sh
	$(SHELL) $(srcdir)/mk-srk-inc.sh '@LIBGOMP_CHECKED_REAL_KINDS@' '$(FCCOMPILE)' > $@ || rm $@

fpu-target.h: $(srcdir)/$(FPU_HOST_HEADER)
	cp $(srcdir)/$(FPU_HOST_HEADER) $@

fpu-target.inc: fpu-target.h $(srcdir)/libgfortran.h
	grep '^#define GFC_FPE_' < $(top_srcdir)/../gcc/fortran/libgfortran.h > $@ || true
	grep '^#define GFC_FPE_' < $(srcdir)/libgfortran.h >> $@ || true

# Place ISO_Fortran_binding.h under include/ in the build directory such
# that it can be used for in-built-tree testsuite runs without interference of
# other files in the build dir - like intrinsic .mod files or other .h files.
include/ISO_Fortran_binding.h: $(srcdir)/ISO_Fortran_binding.h
	-rm -f $@
	$(MKDIR_P) include
	cp $(srcdir)/ISO_Fortran_binding.h $@

clean-local:
	-rm -rf include $(version_dep)

EXTRA_DIST = m4

# target overrides
-include $(tmake_file)

include $(top_srcdir)/../multilib.am
