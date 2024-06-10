## Makefile for publishing Quarto over RSync/SSH

QUARTO=quarto
QUARTOOPTS=

BASEDIR=$(PWD)
OUTPUTDIR=$(BASEDIR)/_site

SSH_HOST=mail.johanssons.org
SSH_PORT=22
SSH_USER=johansso
SSH_TARGET_DIR=public_html/tieknots.how/
SCP=scp

help:
	@echo 'Makefile for a Quarto course website'
	@echo ''
	@echo 'Usage:'
	@echo '  make clean	Remove temporary files'
	@echo '  make render       Generate website files'
	@echo '  make ssh_upload   Upload using SCP'
	@echo '  make rsync_upload Upload using RSync/SSH'
	@echo ''

render: clean $(OUTPUTDIR)/index.html
	@echo 'Done'

$(OUTPUTDIR)/%.html:
	$(QUARTO) render

clean:
	find "$(OUTPUTDIR)" -mindepth 1 -delete

ssh_upload: render
	$(SCP) -P $(SSH_PORT) -p -r "$(OUTPUTDIR)"/* $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR)

rsync_upload: render
	rsync -e "ssh -p $(SSH_PORT)" -P -rvz --delete "$(OUTPUTDIR)"/* $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR)

.PHONY: help render clean ssh_upload rsync_upload
