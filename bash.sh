#!/bin/perl
#INPUT
#Input order: directory, electrode.gro, wall.gro, x, y, z, slit_d, d_wal_ele, total_long_z, electrode.top, wall.top
#eg, perl bash.sh /share/data1/lz/Simulation/Mo2C/Gro/build_test/use/ Mo2C_0_90_90.gro carbon_1.gro 3 4 10 1 0.2 -1 Mo2C.top CWall.top

system "cp *.sh *.py *.pl *.mdp $ARGV[0]";
chdir $ARGV[0];
system "perl BuildSlitWal.sh $ARGV[1] $ARGV[2] $ARGV[3] $ARGV[4] $ARGV[5] $ARGV[6] $ARGV[7] $ARGV[8] $ARGV[9] $ARGV[10]"; 
system "rm -f *.mdp *.sh *.pl *.py *.xvg";
#system "rm -f *.sh *.pl *.py";
