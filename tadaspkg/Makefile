# $NetBSD: Makefile $

PKGNAME=		tadaspkg-1.0
PKGREVISION=		1
CATEGORIES=		devel

LICENSE=		gnu-gpl-v3
USE_LANGUAGES=	# empty
INSTALLATION_DIRS=	bin
NO_BUILD=       yes

do-install:
.for f in ff htmlfixups.sh mutt-ics pptx2txt.sh viewhtmlmail viewmailattachments
	${INSTALL_SCRIPT} ${FILESDIR}/${f} ${DESTDIR}${PREFIX}/bin
.endfor

.include "../../mk/bsd.pkg.mk"
