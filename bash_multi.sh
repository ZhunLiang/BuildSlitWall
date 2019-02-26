#!/bin/perl
#INPUT
#Input order: directory, electrode.gro, wall.gro, x, y, z, slit_d, d_wal_ele, total_long_z, electrode.top, wall.top
#eg, perl bash_multi.sh /share/data1/lz/Simulation/Mo2C/Gro/build_test/use/ Mo2C_0_90_90.gro carbon_1.gro 3 4 10 1 0.2 -1 Mo2C.top CWall.top

$slit_start=0.4;
$slit_end=1.2;
$slit_interval=0.1;

for($d=$slit_start;$d<=$slit_end;$d=$d+$slit_interval){
  $temp_fold = "D-$d";
  $temp_dic = "$ARGV[0]$temp_fold";
  system "cd $ARGV[0];mkdir $temp_fold;cp * $temp_fold";
  system "cp *.sh *.py *.pl *.mdp $temp_dic";
  system "cd $temp_dic;perl BuildSlitWal.sh $ARGV[1] $ARGV[2] $ARGV[3] $ARGV[4] $ARGV[5] $d $ARGV[7] $ARGV[8] $ARGV[9] $ARGV[10];rm -f *.mdp *.sh *.pl *.py *.xvg";
  system "cd $temp_dic;rm -f $ARGV[1] $ARGV[2] $ARGV[9] $ARGV[10] *.dat";
  system "cd $temp_dic;mv output.gro D-$d.gro;mv output.top D-$d.top";
}

