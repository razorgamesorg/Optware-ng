###########################################################
#
# perl-http-response-encoding
#
###########################################################

PERL-HTTP-RESPONSE-ENCODING_SITE=http://$(PERL_CPAN_SITE)/CPAN/authors/id/D/DA/DANKOGAI
PERL-HTTP-RESPONSE-ENCODING_VERSION=0.05
PERL-HTTP-RESPONSE-ENCODING_SOURCE=HTTP-Response-Encoding-$(PERL-HTTP-RESPONSE-ENCODING_VERSION).tar.gz
PERL-HTTP-RESPONSE-ENCODING_DIR=HTTP-Response-Encoding-$(PERL-HTTP-RESPONSE-ENCODING_VERSION)
PERL-HTTP-RESPONSE-ENCODING_UNZIP=zcat
PERL-HTTP-RESPONSE-ENCODING_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
PERL-HTTP-RESPONSE-ENCODING_DESCRIPTION=Adds encoding() to HTTP::Response.
PERL-HTTP-RESPONSE-ENCODING_SECTION=util
PERL-HTTP-RESPONSE-ENCODING_PRIORITY=optional
PERL-HTTP-RESPONSE-ENCODING_DEPENDS=perl-libwww
PERL-HTTP-RESPONSE-ENCODING_SUGGESTS=
PERL-HTTP-RESPONSE-ENCODING_CONFLICTS=

PERL-HTTP-RESPONSE-ENCODING_IPK_VERSION=3

PERL-HTTP-RESPONSE-ENCODING_CONFFILES=

PERL-HTTP-RESPONSE-ENCODING_BUILD_DIR=$(BUILD_DIR)/perl-http-response-encoding
PERL-HTTP-RESPONSE-ENCODING_SOURCE_DIR=$(SOURCE_DIR)/perl-http-response-encoding
PERL-HTTP-RESPONSE-ENCODING_IPK_DIR=$(BUILD_DIR)/perl-http-response-encoding-$(PERL-HTTP-RESPONSE-ENCODING_VERSION)-ipk
PERL-HTTP-RESPONSE-ENCODING_IPK=$(BUILD_DIR)/perl-http-response-encoding_$(PERL-HTTP-RESPONSE-ENCODING_VERSION)-$(PERL-HTTP-RESPONSE-ENCODING_IPK_VERSION)_$(TARGET_ARCH).ipk

$(DL_DIR)/$(PERL-HTTP-RESPONSE-ENCODING_SOURCE):
	$(WGET) -P $(@D) $(PERL-HTTP-RESPONSE-ENCODING_SITE)/$(@F) || \
	$(WGET) -P $(@D) $(FREEBSD_DISTFILES)/$(@F) || \
	$(WGET) -P $(@D) $(SOURCES_NLO_SITE)/$(@F)

perl-http-response-encoding-source: $(DL_DIR)/$(PERL-HTTP-RESPONSE-ENCODING_SOURCE) $(PERL-HTTP-RESPONSE-ENCODING_PATCHES)

$(PERL-HTTP-RESPONSE-ENCODING_BUILD_DIR)/.configured: $(DL_DIR)/$(PERL-HTTP-RESPONSE-ENCODING_SOURCE) $(PERL-HTTP-RESPONSE-ENCODING_PATCHES) make/perl-http-response-encoding.mk
	rm -rf $(BUILD_DIR)/$(PERL-HTTP-RESPONSE-ENCODING_DIR) $(PERL-HTTP-RESPONSE-ENCODING_BUILD_DIR)
	$(PERL-HTTP-RESPONSE-ENCODING_UNZIP) $(DL_DIR)/$(PERL-HTTP-RESPONSE-ENCODING_SOURCE) | tar -C $(BUILD_DIR) -xvf -
#	cat $(PERL-HTTP-RESPONSE-ENCODING_PATCHES) | $(PATCH) -d $(BUILD_DIR)/$(PERL-HTTP-RESPONSE-ENCODING_DIR) -p1
	mv $(BUILD_DIR)/$(PERL-HTTP-RESPONSE-ENCODING_DIR) $(@D)
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS)" \
		PERL5LIB="$(STAGING_LIB_DIR)/perl5/site_perl" \
		$(PERL_HOSTPERL) Makefile.PL \
		PREFIX=$(TARGET_PREFIX) \
	)
	touch $@

perl-http-response-encoding-unpack: $(PERL-HTTP-RESPONSE-ENCODING_BUILD_DIR)/.configured

$(PERL-HTTP-RESPONSE-ENCODING_BUILD_DIR)/.built: $(PERL-HTTP-RESPONSE-ENCODING_BUILD_DIR)/.configured
	rm -f $@
	$(MAKE) -C $(@D) \
	PERL5LIB="$(STAGING_LIB_DIR)/perl5/site_perl"
	touch $@

perl-http-response-encoding: $(PERL-HTTP-RESPONSE-ENCODING_BUILD_DIR)/.built

$(PERL-HTTP-RESPONSE-ENCODING_BUILD_DIR)/.staged: $(PERL-HTTP-RESPONSE-ENCODING_BUILD_DIR)/.built
	rm -f $@
	$(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
	touch $@

perl-http-response-encoding-stage: $(PERL-HTTP-RESPONSE-ENCODING_BUILD_DIR)/.staged

$(PERL-HTTP-RESPONSE-ENCODING_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: perl-http-response-encoding" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PERL-HTTP-RESPONSE-ENCODING_PRIORITY)" >>$@
	@echo "Section: $(PERL-HTTP-RESPONSE-ENCODING_SECTION)" >>$@
	@echo "Version: $(PERL-HTTP-RESPONSE-ENCODING_VERSION)-$(PERL-HTTP-RESPONSE-ENCODING_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PERL-HTTP-RESPONSE-ENCODING_MAINTAINER)" >>$@
	@echo "Source: $(PERL-HTTP-RESPONSE-ENCODING_SITE)/$(PERL-HTTP-RESPONSE-ENCODING_SOURCE)" >>$@
	@echo "Description: $(PERL-HTTP-RESPONSE-ENCODING_DESCRIPTION)" >>$@
	@echo "Depends: $(PERL-HTTP-RESPONSE-ENCODING_DEPENDS)" >>$@
	@echo "Suggests: $(PERL-HTTP-RESPONSE-ENCODING_SUGGESTS)" >>$@
	@echo "Conflicts: $(PERL-HTTP-RESPONSE-ENCODING_CONFLICTS)" >>$@

$(PERL-HTTP-RESPONSE-ENCODING_IPK): $(PERL-HTTP-RESPONSE-ENCODING_BUILD_DIR)/.built
	rm -rf $(PERL-HTTP-RESPONSE-ENCODING_IPK_DIR) $(BUILD_DIR)/perl-http-response-encoding_*_$(TARGET_ARCH).ipk
	$(MAKE) -C $(PERL-HTTP-RESPONSE-ENCODING_BUILD_DIR) DESTDIR=$(PERL-HTTP-RESPONSE-ENCODING_IPK_DIR) install
	find $(PERL-HTTP-RESPONSE-ENCODING_IPK_DIR)$(TARGET_PREFIX) -name 'perllocal.pod' -exec rm -f {} \;
	(cd $(PERL-HTTP-RESPONSE-ENCODING_IPK_DIR)$(TARGET_PREFIX)/lib/perl5 ; \
		find . -name '*.so' -exec chmod +w {} \; ; \
		find . -name '*.so' -exec $(STRIP_COMMAND) {} \; ; \
		find . -name '*.so' -exec chmod -w {} \; ; \
	)
	find $(PERL-HTTP-RESPONSE-ENCODING_IPK_DIR)$(TARGET_PREFIX) -type d -exec chmod go+rx {} \;
	$(MAKE) $(PERL-HTTP-RESPONSE-ENCODING_IPK_DIR)/CONTROL/control
	echo $(PERL-HTTP-RESPONSE-ENCODING_CONFFILES) | sed -e 's/ /\n/g' > $(PERL-HTTP-RESPONSE-ENCODING_IPK_DIR)/CONTROL/conffiles
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PERL-HTTP-RESPONSE-ENCODING_IPK_DIR)

perl-http-response-encoding-ipk: $(PERL-HTTP-RESPONSE-ENCODING_IPK)

perl-http-response-encoding-clean:
	-$(MAKE) -C $(PERL-HTTP-RESPONSE-ENCODING_BUILD_DIR) clean

perl-http-response-encoding-dirclean:
	rm -rf $(BUILD_DIR)/$(PERL-HTTP-RESPONSE-ENCODING_DIR) $(PERL-HTTP-RESPONSE-ENCODING_BUILD_DIR) $(PERL-HTTP-RESPONSE-ENCODING_IPK_DIR) $(PERL-HTTP-RESPONSE-ENCODING_IPK)
