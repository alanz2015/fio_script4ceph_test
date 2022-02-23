# Copyright (C) 2022 Alan Zhang <zhangx2000@hotmail.com>
# =======
# This file is free software; as a special exception the author gives
# unlimited permission to copy and/or distribute it, with or without
# modifications, as long as this notice is preserved.

# Purpose
# =======
# This script will perform ceph cluster test cases via fio utility.
# The test cases are grouped per the combinations per the following different
# dimensions.
#   Access Engine: rbd, libaio
#   Access Mode:   Seq Write, Seq Read, Rand Write, Rand Read, Rand RWMixed
#   Num Threads:   1, 4, 8, 16
#   IO_DEPTH:      1, 4, 8, 16
#   BLK SIZE:      4K, 8K, 32K, 1M, 4M
# So the total test cases are 2 x 5 x 4 x 4 x 5 = 800 test cases.

#!/bin/sh

# access_engine="rbd libaio"
access_engine="rbd"
access_modes="write read randwrite randread randrw"
num_threads="1 4 8 16"
io_depth="1 4 8 16"
blk_size="4k 8k 32k 1m 4m"

result_folder="/var/log/test_ceph/"`date '+%Y-%m-%d %H:%M:%S'`
if [ ! -d "${result_folder}" ]
then
    sudo mkdir "${result_folder}"
fi

echo "Starting..."

for engine_item in ${access_engine}; do
    for mode_item in ${access_modes}; do
        for thread_item in ${num_threads}; do
            for depth_item in ${io_depth}; do 
                for blk_item in ${blk_size}; do
                    echo ${blk_item}
                    # echo fio fio_global_settings.fio --name="${engine_item}"-"${mode_item}"-"${thread_item}"-"${depth_item}"-"${blk_item}" --ioengine="${engine_item}" --rw="${mode_item}" --numjobs="${thread_item}" --iodepth=${depth_item} --bs=${blk_item} --size=512M --output="$result_folder"/"${engine_item}"-"${mode_item}"-"${thread_item}"-"${depth_item}"-"${blk_item}".log
                    sudo -E fio fio_global_settings.fio --name="${engine_item}"-"${mode_item}"-"${thread_item}"-"${depth_item}"-"${blk_item}" --rw="${mode_item}" --numjobs="${thread_item}" --iodepth=${depth_item} --bs=${blk_item} --size=128M --output="$result_folder"/"${engine_item}"-"${mode_item}"-j"${thread_item}"-depth"${depth_item}"-"${blk_item}".log
                    sleep 10
                done
            done
        done
    done
done

echo Done
