#
# Makefile - Automate installing module
#

EPYLOG_MOD_PATH		=	/usr/share/epylog/modules
EPYLOG_MOD_CONF		=	/etc/epylog/modules.d
EPYLOG_OWNER		=	root
EPYLOG_GROUP		=	root
EPYLOG_MODE			=	0644
INSTALL				=	/usr/bin/install
MOD					=	amavis_mod.py
MOD_CONF_SRC		=	conf/modules.d/amavis.conf
MOD_CONF_DST		=	$(EPYLOG_MOD_CONF)/$(shell basename $(MOD_CONF_SRC))
INSTALL_CMD			=	$(INSTALL) -g $(EPYLOG_GROUP) -o $(EPYLOG_OWNER) -m $(EPYLOG_MODE)

install:
	$(INSTALL_CMD) $(MOD) $(EPYLOG_MOD_PATH)
	[ ! -e "$(MOD_CONF_DST)" ] && $(INSTALL_CMD) $(MOD_CONF_SRC) $(MOD_CONF_DST) || :

