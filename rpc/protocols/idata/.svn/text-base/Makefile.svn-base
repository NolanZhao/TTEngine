#
# Net Library Makefile
#
#
PROGRAM = libidata.a
SOURCE  = $(wildcard *.cpp) $(wildcard ../Protocol/*.cpp)  
OBJS 	= $(patsubst %.cpp,%.o, $(SOURCE)) 

%.o: %.cpp
	$(CXX) -c $(BUILD_INCS) -o $@ $?

$(PROGRAM):$(OBJS)
	ar -cr $(BUILD_OUT_DIR)/$@ $(OBJS)
	ranlib $(BUILD_OUT_DIR)/$@

clean:
	rm -f $(OBJS) $(BUILD_OUT_DIR)/$(PROGRAM)

