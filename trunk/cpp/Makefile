CXXFLAGS =	-g -Wall -fmessage-length=0
#CXXFLAGS =	-O2 -g -Wall -fmessage-length=0

SOURCES =   slr.cpp \
			io.cpp \
			options.cpp \
			utilities.cpp \

HEADERS =	$(SOURCES:.cpp=.h)

OBJS =		$(SOURCES:.cpp=.o)

INCLUDE =   -I/usr/include/boost -I./include

LIBS =      -L/usr/lib \
			-lboost_program_options \
			-lboost_regex

TARGET =	slr

$(TARGET):	$(OBJS)
	$(CXX) -o $(TARGET) $(OBJS) $(LIBS)

all:	$(TARGET)

clean:
	rm -f $(OBJS) $(TARGET)

reallyclean: clean
	rm -f *~

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDE) -c -o $@ $<



BOOSTDIR = boost_program_options_example


test:	$(BOOSTDIR)/first $(BOOSTDIR)/options_description $(BOOSTDIR)/multiple_sources

$(BOOSTDIR)/first:	$(BOOSTDIR)/first.cpp
	$(CXX)  $(CXXFLAGS) $(INCLUDE) $(BOOSTDIR)/first.cpp -o $(BOOSTDIR)/first $(LIBS)
$(BOOSTDIR)/options_description:	$(BOOSTDIR)/options_description.cpp
	$(CXX)  $(CXXFLAGS) $(INCLUDE) $(BOOSTDIR)/options_description.cpp -o $(BOOSTDIR)/options_description $(LIBS)
$(BOOSTDIR)/multiple_sources:	$(BOOSTDIR)/multiple_sources.cpp
	$(CXX)  $(CXXFLAGS) $(INCLUDE) $(BOOSTDIR)/multiple_sources.cpp -o $(BOOSTDIR)/multiple_sources $(LIBS)
