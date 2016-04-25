AWK=awk
MKBOOTIMG=mkbootimg
DTBTOOL=dtbTool
SPLIT_BOOTIMG=split_bootimg.pl

ifeq ($(OUT),)
    $(error "*** var OUT not set yet!")
endif
BOOTIMG=$(OUT)/boot.img-new
OLD_BOOTIMG=$(OUT)/boot.img
ZIMAGE=$(OUT)/boot.img-kernel
RDIMG=$(OUT)/boot.img-ramdisk.gz
DTIMG=$(OUT)/boot.img-dt

# Must have '/' at tail, dtbTool dose not append it automatically
DTB_DIR=$(KERNEL_DIR)/arch/arm/boot/dts/
KERNEL_DIR :=$(OUT)/obj/KERNEL_OBJ

SPLIT_OUT=$(OUT)/.tmp.split_out

newboot: clean $(BOOTIMG)
	@echo Done.

$(BOOTIMG): $(DTIMG) $(ZIMAGE)
	$(MKBOOTIMG) --kernel $(ZIMAGE) --ramdisk $(RDIMG) --cmdline "$(CMDLINE)" --dt $(DTIMG) -o $@ --pagesize $(PAGESIZE)

$(DTIMG): dtblob
	$(DTBTOOL) -o $@ $(DTB_DIR)

$(ZIMAGE):
	$(shell $(SPLIT_BOOTIMG) $(OLD_BOOTIMG) > $(SPLIT_OUT))
	@mv ./boot.img-kernel $@
	@mv ./boot.img-ramdisk.gz $(RDIMG)
	$(eval PAGESIZE=$(shell cat $(SPLIT_OUT)|$(AWK) -F'Page size:' '{print $$2}'|$(AWK) -F' ' '{print $$1}'))
	@echo pagesize: $(PAGESIZE)
	$(eval CMDLINE=$(shell cat $(SPLIT_OUT)|$(AWK) -F'Command line:' '{print $$2}'))
	@echo cmdline: $(CMDLINE)
	@rm $(SPLIT_OUT)

PWD=$(shell pwd)

dtblob:
	make ARCH=arm -C $(KERNEL_DIR) SUBDIRS=$(PWD) dtbs

clean:
	@rm -f $(ZIMAGE) $(RDIMG) $(BOOTIMG) $(DTIMG)

