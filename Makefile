tests:
	cd python2 && python2.4 httplib2test.py
	-cd python2 && python2.5 httplib2test.py
	cd python2 && python2.6 httplib2test.py
	cd python2 && python2.6 httplib2test_appengine.py
	cd python2 && python2.7 httplib2test.py
	cd python2 && python2.7 httplib2test_appengine.py
	cd python3 && python3.2 httplib2test.py

VERSION = $(shell python setup.py --version)
INLINE_VERSION = $(shell cd python2; python -c "import httplib2;print httplib2.__version__")
INLINE_VERSION_3 = $(shell cd python3; python3.2 -c "import httplib2;print(httplib2.__version__)")
DST = dist/httplib2-$(VERSION)

release:
	[ "$(VERSION)" == "$(INLINE_VERSION)" ] # Check for version number mismatch
	[ "$(VERSION)" == "$(INLINE_VERSION_3)" ] # Check for version number mismatch
	-find . -name "*.pyc" | xargs rm 
	-find . -name "*.orig" | xargs rm 
	-rm -rf python2/.cache
	-rm -rf python3/.cache
	-mkdir dist
	-rm -rf dist/httplib2-$(VERSION)
	-rm dist/httplib2-$(VERSION).tar.gz
	-rm dist/httplib2-$(VERSION).zip
	-mkdir dist/httplib2-$(VERSION)
	cp -r python2 $(DST) 
	cp -r python3 $(DST) 
	cp setup.py README MANIFEST CHANGELOG $(DST)
	cd dist && tar -czv -f httplib2-$(VERSION).tar.gz httplib2-$(VERSION) 
	cd dist && zip httplib2-$(VERSION).zip -r httplib2-$(VERSION)
	python setup.py register upload
	wget "http://support.googlecode.com/svn/trunk/scripts/googlecode_upload.py" -O googlecode_upload.py
	python googlecode_upload.py --summary="Version $(shell python setup.py --version)" --project=httplib2 dist/*.tar.gz
	python googlecode_upload.py --summary="Version $(shell python setup.py --version)" --project=httplib2 dist/*.zip

docs:
	pudge -v -f --modules=httplib2 --dest=build/doc 
