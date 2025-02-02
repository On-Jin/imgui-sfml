.PHONY: all clean fclean re

#==========EXECUTABLES==========#

EXE= libimgui-sfml.a

#=======COMPILER AND FLAGS======#

CXX= clang++
CXXFLAGS= -Wall -Wextra -Werror -Wvla -std=c++14 -fsanitize=address -g3 -MMD
#============HEADERS============#

HEADER_DIR= ./

#============COLORS=============#

RED=\033[1;31m
GREEN=\033[1;32m
EOC=\033[0m

#==============SRC=============#

SRC_DIR = ./

SRC_FILE= imgui.cpp \
imgui_demo.cpp \
imgui_draw.cpp \
imgui_widgets.cpp \
imgui-SFML.cpp

SRC = $(addprefix $(SRC_DIR), $(SRC_FILE))


OBJ_DIR = ./obj/
OBJ = $(addprefix $(OBJ_DIR), $(OBJ_FILE))
OBJ_FILE= $(SRC_FILE:.cpp=.o)

DEPENDS= $(OBJ:.o=.d)

#==========AGNOSTIC==========#

UNAME := $(shell uname)

ADDITIONNAL_LIB= -framework Cocoa -framework OpenGL -framework IOKit -framework CoreVideo
ifeq ($(UNAME), Linux)
ADDITIONNAL_LIB += -L /usr/lib/ -lsfml-graphics -lsfml-window -lsfml-system
HEADER_DIR += -I /usr/include/
endif
ifeq ($(UNAME), Darwin)
ADDITIONNAL_LIB +=-L ~/.brew/lib/ -lsfml-graphics -lsfml-window -lsfml-system -lsfml-audio -rpath ~/.brew/lib
HEADER_DIR += ~/.brew/include/
endif

#=============RULES=============#

all: $(OBJ_DIR) $(EXE)

$(EXE): $(OBJ)
	@ar rc $(EXE) $(OBJ) && ranlib $(EXE)
	@printf "\nLibrary $(GREEN)$(EXE)$(EOC) created\n"

$(OBJ_DIR) :
	@mkdir $(OBJ_DIR)

$(OBJ_DIR)%.o: $(addprefix $(SRC_DIR), %.cpp) Makefile
	$(CXX) $(CXXFLAGS) -c $< -o $@ $(addprefix -I , $(HEADER_DIR))

clean:
	@rm -rf $(OBJ_DIR)
	@echo "$(RED)[x]$(EOC) $(EXE)'s objects cleaned"

fclean: clean
	@rm -f $(EXE)
	@echo "executable $(RED)$(EXE)$(EOC) removed"
	@echo "$(RED)<<<----------$(EOC)"

re: fclean all

-include $(DEPENDS)
