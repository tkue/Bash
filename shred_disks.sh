#!/bin/bash

for i in `seq 1 10`; do 
	echo $i
	dd if=/dev/zero of=/dev/sda &
	dd if=/dev/zero of=/dev/sdb &
	dd if=/dev/zero of=/dev/sdc &
	dd if=/dev/zero of=/dev/sdd &
	dd if=/dev/zero of=/dev/sde &
	echo "Done"
done

for i in `seq 1 10`; do echo $i; dd if=/dev/zero of=/dev/sda; done
for i in `seq 1 10`; do echo $i; dd if=/dev/zero of=/dev/sdb; done
for i in `seq 1 10`; do echo $i; dd if=/dev/zero of=/dev/sdc; done
for i in `seq 1 10`; do echo $i; dd if=/dev/zero of=/dev/sdd; done
for i in `seq 1 10`; do echo $i; dd if=/dev/zero of=/dev/sde; done
for i in `seq 1 10`; do echo $i; dd if=/dev/zero of=/dev/sdf; done
