CC = g++
CFLAGS = -std=c++11
UNAME := $(shell uname)

LDFLAGS =
ifeq ($(UNAME), Linux)
	LDFLAGS += -L/usr/lib/x86_64-linux-gnu -lboost_system
endif
ifeq ($(UNAME), Darwin) # macOS
	LDFLAGS += -L/usr/local/include -lboost_system
endif

DEBUG_FLAGS = -g -Wall -Werror

COVCC = gcov
COVRFLAGS = -r
COVFLAGS = -fprofile-arcs -ftest-coverage
#-fprofile-dir="./cov"

MAIN = src/main.cc
CC_FILES = $(filter-out $(MAIN), $(wildcard src/*.cc))
TEST_FILES = $(wildcard tests/*.cc)

GTEST_DIR = googletest/googletest
GMOCK_DIR = googletest/googlemock
TEST_FLAGS = -isystem $(GTEST_DIR)/include -isystem $(GMOCK_DIR)/include -pthread


all:
	$(CC) $(CFLAGS) $(DEBUG_FLAGS) $(MAIN) $(CC_FILES) -o webserver $(LDFLAGS)

test:
	$(CC) $(CFLAGS) $(TEST_FLAGS) -I$(GMOCK_DIR) -I$(GTEST_DIR) -c $(GTEST_DIR)/src/gtest-all.cc $(LDFLAGS)
	$(CC) $(CFLAGS) $(TEST_FLAGS) -I$(GMOCK_DIR) -I$(GTEST_DIR) -c $(GMOCK_DIR)/src/gmock-all.cc $(LDFLAGS)
	ar -rv libgmock.a gtest-all.o gmock-all.o
	$(CC) $(CFLAGS) $(TEST_FLAGS) -Isrc/ $(CC_FILES) $(TEST_FILES) $(GTEST_DIR)/src/gtest_main.cc libgmock.a -o run_tests $(LDFLAGS)
	./run_tests

integration:
	tests/integration.py

coverage:
	$(CC) $(CFLAGS) $(TEST_FLAGS) -I$(GMOCK_DIR) -I$(GTEST_DIR) -c $(GTEST_DIR)/src/gtest-all.cc $(LDFLAGS)
	$(CC) $(CFLAGS) $(TEST_FLAGS) -I$(GMOCK_DIR) -I$(GTEST_DIR) -c $(GMOCK_DIR)/src/gmock-all.cc $(LDFLAGS)
	ar -rv libgmock.a gtest-all.o gmock-all.o
	$(CC) $(CFLAGS) $(TEST_FLAGS) -Isrc/ $(CC_FILES) $(TEST_FILES) $(GTEST_DIR)/src/gtest_main.cc libgmock.a -o run_tests $(LDFLAGS) $(COVFLAGS)
	./run_tests
	$(COVCC) $(COVRFLAGS) -s src $(notdir $(CC_FILES))

test-all: test integration

clean:
	-rm *.o
	-rm *.a
	-rm *.gcno
	-rm *.gcov
	-rm *.gcda
	-rm -rf *.dSYM
	-rm webserver
	-rm run_tests


