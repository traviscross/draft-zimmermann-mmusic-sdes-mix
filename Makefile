# makefile

OUTPUTS=draft-sdesmix.txt draft-sdesmix.html draft-sdesmix.nr draft-sdesmix.txt.pdf draft-sdesmix.html.epub draft-sdesmix.xslt.pdf

all: all-docs bundle

all-docs: $(OUTPUTS)

bundle: draft-sdesmix.tar.gz

clean:
	rm -f *.txt *.html *.nr *.ps *.pdf *.epub *.exp.xml *.fo *.fop

fetch:
	wget -N http://zfone.com/docs/ietf/draft-sdesmix.xml

draft-sdesmix.tar.gz: $(OUTPUTS)
	mkdir -p draft-sdesmix
	cp $(OUTPUTS) draft-sdesmix/
	tar cvf draft-sdesmix.tar draft-sdesmix
	rm -rf draft-sdesmix
	gzip -f -9 draft-sdesmix.tar

%.txt: %.xml
	xml2rfc $< $@

%.html: %.xml
	xml2rfc $< $@

%.nr: %.xml
	xml2rfc $< $@

%.exp.xml: %.xml
	xml2rfc $< $@

%.txt.ps: %.txt
	enscript --no-header -M A4 -f Courier12 $< -o $@

%.txt.pdf: %.txt.ps
	ps2pdf $<

%.html.epub: %.html
	ebook-convert $< $@

%.html.pdf: %.html
	wkhtmltopdf --zoom 1.25 $< $@

%.fo: %.exp.xml
	saxon-xslt $< rfc2629toFO.xslt > $@

%.fop: %.fo
	saxon-xslt $< xsl11toFop.xslt > $@

%.xslt.pdf: %.fop
	fop $< $@

