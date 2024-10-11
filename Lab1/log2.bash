#!/bin/bash

grep -E 'WW|II' /var/log/Xorg.0.log | sed -e 's/WW/Warning:/g' -e 's/II/Information:/g' | sort -k1,1 -t':' > X_info_warn.log
cat X_info_warn.log