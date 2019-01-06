#!/bin/bash
grep "<drv" revo/* | awk -F":" '{print $1}' | uniq -c |sort -nr |head -100

