NAME = MinLocator.dll 
VERSION = 0.1.0
TARGET = library

ROOT_SOURCE_DIR = src
getSources = $(shell find $(ROOT_SOURCE_DIR) -name "*.cs")
SRC = $(getSources) 

REFS = System.Data.dll 
REFS_FLAG = $(addprefix -r:, $(REFS))


PKG = $(BIN)/$(NAME)
PKG += $(wildcard $(BIN)/*.dll)
PKG_SRC = $(PKG) $(SRC) README.md makefile $(SRC_TEST)

########
# Test #
########
TEST_SOURCE_DIR = tests
SRC_TEST = $(filter-out $(ROOT_SOURCE_DIR)/app.cs, $(SRC)) 
SRC_TEST += $(wildcard $(TEST_SOURCE_DIR)/*.cs)

REFS_TEST = $(REFS) 
REFS_FLAG_TEST = $(addprefix -r:, $(REFS_TEST))
PKG_FLAG_TEST = $(PKG_FLAG)

###############
# Common part #
###############

BIN = bin
BIN_TEST = $(BIN)
CSC = dmcs

BASE_NAME = $(basename $(NAME))
CSCFLAGS += -debug -nologo -target:$(TARGET)
CSCFLAGS += -lib:$(BIN)
CSCFLAGS += $(RES_OPT)

NAME_TEST = $(BASE_NAME)-test 
CSCFLAGS_TEST += -debug -nologo -target:exe
CSCFLAGS_TEST += -lib:$(BIN_TEST)
CSCFLAGS_TEST += -lib:$(BIN)

PETATEST_OPT = -showreport:no -htmlreport:yes -dirtyexit:no

PUBLISH_DIR = $(CS_DIR)/lib/Microline/$(BASE_NAME)/$(VERSION)
PKG_PREFIX = $(BASE_NAME)-$(VERSION)
PKG_DIR = pkg/$(PKG_PREFIX)

.PHONY: all clean clobber test testv ver var pkg pkgtar pkgsrc publish

DEFAULT: all
all: builddir $(BIN)/$(NAME)

test: builddir $(BIN_TEST)/$(NAME_TEST)
	mono $(BIN_TEST)/$(NAME_TEST) $(PETATEST_OPT)

testv: builddir $(BIN_TEST)/$(NAME_TEST)
	mono $(BIN_TEST)/$(NAME_TEST) -verbose:yes $(PETATEST_OPT)

builddir:
	@mkdir -p $(BIN)
	@mkdir -p $(BIN_TEST)

$(BIN)/$(NAME): $(SRC) | builddir
	$(CSC) $(CSCFLAGS) $(REFS_FLAG) $(PKG_FLAG) -out:$@ $^
	
$(BIN_TEST)/$(NAME_TEST): $(SRC_TEST) | builddir
	$(CSC) $(CSCFLAGS_TEST) $(REFS_FLAG_TEST) $(PKG_FLAG_TEST) -out:$@ $^

pkgdir:
	@mkdir -p $(PKG_DIR)

pkg: $(PKG) | pkgdir
	zip $(PKG_DIR).zip $(PKG)

pkgtar: $(PKG) | pkgdir
	cp $(PKG) --parents $(PKG_DIR)
	tar -jcf $(PKG_DIR).tar.bz2 --directory pkg $(PKG_PREFIX)/

pkgsrc: $(PKG_SRC) | pkgdir
	tar -jcf pkg/$(BASE_NAME)-$(VERSION)-src.tar.bz2 $^

publishdir:
	@mkdir -p $(PUBLISH_DIR)

publish: publishdir
	cp -u --verbose --backup=t --preserve=all $(BIN)/$(NAME) $(PUBLISH_DIR)

tags: $(SRC)
	ctags $^

ver:
	@echo $(VERSION)

clean:
	-rm -f $(BIN)/$(NAME)
	-rm -f $(BIN)/$(NAME_TEST)

clobber:
	-rm -Rf $(BIN)

var:
	@echo SRC:$(SRC)
	@echo 
	@echo REFS: $(REFS)
	@echo REFS_FLAG: $(REFS_FLAG)
	@echo PKG_FLAG: $(PKG_FLAG)
	@echo 
	@echo CSCFLAGS: $(CSCFLAGS)
	@echo 
	@echo SRC_TEST:$(SRC_TEST)
	@echo 
	@echo REFS_TEST: $(REFS_TEST)
	@echo REFS_FLAG_TEST: $(REFS_FLAG_TEST)
	@echo PKG_FLAG_TEST: $(PKG_FLAG_TEST)
	@echo 
	@echo CSCFLAGS_TEST: $(CSCFLAGS_TEST)
	@echo 
	@echo PKG: $(PKG)
	@echo 
	@echo VERSION: $(VERSION)

#include i18n.makefile
