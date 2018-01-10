################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../AIC_func.c \
../main.c 

CMD_SRCS += \
../lnkx.cmd 

OBJS += \
./AIC_func.obj \
./main.obj 

C_DEPS += \
./AIC_func.pp \
./main.pp 

OBJS__QTD += \
".\AIC_func.obj" \
".\main.obj" 

C_DEPS__QTD += \
".\AIC_func.pp" \
".\main.pp" 

C_SRCS_QUOTED += \
"../AIC_func.c" \
"../main.c" 


# Each subdirectory must supply rules for building sources it contributes
AIC_func.obj: ../AIC_func.c $(GEN_OPTS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/C5500 Code Generation Tools 4.3.9/bin/cl55" -v5515 -g --include_path="C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/C5500 Code Generation Tools 4.3.9/include" --include_path="C:/EE4413/C5515/Exercises/C5515_Support_Files/452_Support" --include_path="C:/EE4413/C5515/Exercises/C5515_Support_Files/C5515_Includes" --diag_warning=225 --ptrdiff_size=32 --memory_model=large --preproc_with_compile --preproc_dependency="AIC_func.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

main.obj: ../main.c $(GEN_OPTS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/C5500 Code Generation Tools 4.3.9/bin/cl55" -v5515 -g --include_path="C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/C5500 Code Generation Tools 4.3.9/include" --include_path="C:/EE4413/C5515/Exercises/C5515_Support_Files/452_Support" --include_path="C:/EE4413/C5515/Exercises/C5515_Support_Files/C5515_Includes" --diag_warning=225 --ptrdiff_size=32 --memory_model=large --preproc_with_compile --preproc_dependency="main.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '


