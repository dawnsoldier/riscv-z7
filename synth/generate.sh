#!/bin/bash

DIR=$1

if [ -d "$DIR/synth/vhdl" ]; then
  rm -rf $DIR/synth/vhdl
fi

mkdir $DIR/synth/vhdl

GHDL=$2

FPGA=$3

cd $DIR/synth/vhdl

$GHDL --synth -fsynopsys \
              $DIR/vhdl/${FPGA}/configure.vhd \
              $DIR/vhdl/lzc/lzc_wire.vhd \
              $DIR/vhdl/lzc/lzc_lib.vhd \
              $DIR/vhdl/lzc/lzc_4.vhd \
              $DIR/vhdl/lzc/lzc_8.vhd \
              $DIR/vhdl/lzc/lzc_16.vhd \
              $DIR/vhdl/lzc/lzc_32.vhd \
              $DIR/vhdl/lzc/lzc_64.vhd \
              $DIR/vhdl/lzc/lzc_128.vhd \
              $DIR/vhdl/lzc/lzc_256.vhd \
              $DIR/vhdl/integer/int_constants.vhd \
              $DIR/vhdl/integer/int_types.vhd \
              $DIR/vhdl/integer/int_wire.vhd \
              $DIR/vhdl/atomic/atom_constants.vhd \
              $DIR/vhdl/atomic/atom_wire.vhd \
              $DIR/vhdl/atomic/atom_functions.vhd \
              $DIR/vhdl/bitmanip/bit_constants.vhd \
              $DIR/vhdl/bitmanip/bit_types.vhd \
              $DIR/vhdl/bitmanip/bit_wire.vhd \
              $DIR/vhdl/bitmanip/bit_functions.vhd \
              $DIR/vhdl/float/fp_cons.vhd \
              $DIR/vhdl/float/fp_typ.vhd \
              $DIR/vhdl/float/fp_wire.vhd \
              $DIR/vhdl/csr/csr_constants.vhd \
              $DIR/vhdl/csr/csr_wire.vhd \
              $DIR/vhdl/csr/csr_functions.vhd \
              $DIR/vhdl/compress/comp_constants.vhd \
              $DIR/vhdl/compress/comp_wire.vhd \
              $DIR/vhdl/setting/constants.vhd \
              $DIR/vhdl/setting/wire.vhd \
              $DIR/vhdl/setting/functions.vhd \
              $DIR/vhdl/compress/comp_decode.vhd \
              $DIR/vhdl/memory/arbiter.vhd \
              $DIR/vhdl/memory/pmp.vhd \
              $DIR/vhdl/memory/timer.vhd \
              $DIR/vhdl/memory/uart.vhd \
              $DIR/vhdl/memory/axi.vhd \
              $DIR/vhdl/memory/ahb.vhd \
              $DIR/vhdl/memory/check.vhd \
              $DIR/vhdl/memory/print.vhd \
              $DIR/vhdl/icache/iwire.vhd \
              $DIR/vhdl/icache/idata.vhd \
              $DIR/vhdl/icache/itag.vhd \
              $DIR/vhdl/icache/ivalid.vhd \
              $DIR/vhdl/icache/ihit.vhd \
              $DIR/vhdl/icache/irandom.vhd \
              $DIR/vhdl/icache/ictrl.vhd \
              $DIR/vhdl/icache/icache.vhd \
              $DIR/vhdl/dcache/dwire.vhd \
              $DIR/vhdl/dcache/ddata.vhd \
              $DIR/vhdl/dcache/dtag.vhd \
              $DIR/vhdl/dcache/dvalid.vhd \
              $DIR/vhdl/dcache/dirty.vhd \
              $DIR/vhdl/dcache/dhit.vhd \
              $DIR/vhdl/dcache/drandom.vhd \
              $DIR/vhdl/dcache/dctrl.vhd \
              $DIR/vhdl/dcache/dcache.vhd \
              $DIR/vhdl/fetchbuffer/fetchram.vhd \
              $DIR/vhdl/fetchbuffer/fetchctrl.vhd \
              $DIR/vhdl/fetchbuffer/fetchbuffer.vhd \
              $DIR/vhdl/storebuffer/storebuffer.vhd \
              $DIR/vhdl/storebuffer/storectrl.vhd \
              $DIR/vhdl/storebuffer/storeram.vhd \
              $DIR/vhdl/bp/bht.vhd \
              $DIR/vhdl/bp/btb.vhd \
              $DIR/vhdl/bp/ras.vhd \
              $DIR/vhdl/bp/bp.vhd \
              $DIR/vhdl/integer/int_library.vhd \
              $DIR/vhdl/integer/int_alu.vhd \
              $DIR/vhdl/integer/int_bcu.vhd \
              $DIR/vhdl/integer/int_agu.vhd \
              $DIR/vhdl/integer/int_mul.vhd \
              $DIR/vhdl/integer/int_div.vhd \
              $DIR/vhdl/integer/int_reg_file.vhd \
              $DIR/vhdl/integer/int_forward.vhd \
              $DIR/vhdl/integer/int_decode.vhd \
              $DIR/vhdl/integer/int_pipeline.vhd \
              $DIR/vhdl/integer/int_unit.vhd \
              $DIR/vhdl/atomic/atom_library.vhd \
              $DIR/vhdl/atomic/atom_alu.vhd \
              $DIR/vhdl/atomic/atom_decode.vhd \
              $DIR/vhdl/bitmanip/bit_library.vhd \
              $DIR/vhdl/bitmanip/bit_alu.vhd \
              $DIR/vhdl/bitmanip/bit_clmul.vhd \
              $DIR/vhdl/bitmanip/bit_decode.vhd \
              $DIR/vhdl/bitmanip/bit_pipeline.vhd \
              $DIR/vhdl/bitmanip/bit_unit.vhd \
              $DIR/vhdl/float/fp_lib.vhd \
              $DIR/vhdl/float/fp_ext.vhd \
              $DIR/vhdl/float/fp_cmp.vhd \
              $DIR/vhdl/float/fp_max.vhd \
              $DIR/vhdl/float/fp_sgnj.vhd \
              $DIR/vhdl/float/fp_cvt.vhd \
              $DIR/vhdl/float/fp_rnd.vhd \
              $DIR/vhdl/float/fp_fma.vhd \
              $DIR/vhdl/float/fp_mac.vhd \
              $DIR/vhdl/float/fp_fdiv.vhd \
              $DIR/vhdl/float/fp_for.vhd \
              $DIR/vhdl/float/fp_reg.vhd \
              $DIR/vhdl/float/fp_dec.vhd \
              $DIR/vhdl/float/fp_exe.vhd \
              $DIR/vhdl/float/fpu.vhd \
              $DIR/vhdl/csr/csr_alu.vhd \
              $DIR/vhdl/csr/csr_file.vhd \
              $DIR/vhdl/csr/csr_unit.vhd \
              $DIR/vhdl/stage/fetch_stage.vhd \
              $DIR/vhdl/stage/decode_stage.vhd \
              $DIR/vhdl/stage/execute_stage.vhd \
              $DIR/vhdl/stage/memory_stage.vhd \
              $DIR/vhdl/stage/writeback_stage.vhd \
              $DIR/vhdl/unit/pipeline.vhd \
              $DIR/vhdl/unit/core.vhd \
              $DIR/vhdl/${FPGA}/bram_mem.vhd \
              $DIR/vhdl/${FPGA}/cpu.vhd \
              $DIR/vhdl/${FPGA}/soc.vhd \
              -e soc > soc.vhd

cp $DIR/vhdl/${FPGA}/configure.vhd $DIR/synth/vhdl/.
cp $DIR/vhdl/lzc/lzc_wire.vhd $DIR/synth/vhdl/.
cp $DIR/vhdl/lzc/lzc_lib.vhd $DIR/synth/vhdl/.
cp $DIR/vhdl/integer/int_constants.vhd $DIR/synth/vhdl/.
cp $DIR/vhdl/integer/int_types.vhd $DIR/synth/vhdl/.
cp $DIR/vhdl/integer/int_wire.vhd $DIR/synth/vhdl/.
cp $DIR/vhdl/atomic/atom_constants.vhd $DIR/synth/vhdl/.
cp $DIR/vhdl/atomic/atom_wire.vhd $DIR/synth/vhdl/.
cp $DIR/vhdl/bitmanip/bit_constants.vhd $DIR/synth/vhdl/.
cp $DIR/vhdl/bitmanip/bit_types.vhd $DIR/synth/vhdl/.
cp $DIR/vhdl/bitmanip/bit_wire.vhd $DIR/synth/vhdl/.
cp $DIR/vhdl/float/fp_cons.vhd $DIR/synth/vhdl/.
cp $DIR/vhdl/float/fp_typ.vhd $DIR/synth/vhdl/.
cp $DIR/vhdl/float/fp_wire.vhd $DIR/synth/vhdl/.
cp $DIR/vhdl/csr/csr_constants.vhd $DIR/synth/vhdl/.
cp $DIR/vhdl/csr/csr_wire.vhd $DIR/synth/vhdl/.
cp $DIR/vhdl/compress/comp_constants.vhd $DIR/synth/vhdl/.
cp $DIR/vhdl/compress/comp_wire.vhd $DIR/synth/vhdl/.
cp $DIR/vhdl/setting/constants.vhd $DIR/synth/vhdl/.
cp $DIR/vhdl/setting/wire.vhd $DIR/synth/vhdl/.
cp $DIR/vhdl/setting/functions.vhd $DIR/synth/vhdl/.
