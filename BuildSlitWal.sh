#!/bin/perl
# perl build.sh electrode.gro wall.gro x y z slit_d d_wal_ele total_long_z electrode.top wall.top

@EleXYZ= split/\s+/,`tail -1 $ARGV[0]`;
@WalXYZ= split/\s+/,`tail -1 $ARGV[1]`;

for ($i=0; $i<3; $i=$i+1){
   @EleNum[$i] = int($ARGV[$i+2]/@EleXYZ[$i+1]+0.5);
   @WalNum[$i] = int($ARGV[$i+2]/@WalXYZ[$i+1]+0.5);
}

@EleNum[1]=1;
$WantWalY=($ARGV[3]-$ARGV[5])/2-@EleXYZ[2]-$ARGV[6];
@WalNum[1]=int($WantWalY/@WalXYZ[2]+0.5);
@WalNum[2]=1;

$WalXBuild=@WalXYZ[1]*@WalNum[0];
$WalYBuild=@WalXYZ[2]*@WalNum[1];
$EleXBuild=@EleXYZ[1]*@EleNum[0];
$EleZBuild=@EleXYZ[3]*@EleNum[2];
$WalXScale=$EleXBuild/$WalXBuild;

system "genconf -f $ARGV[0] -nbox @EleNum[0] @EleNum[1] @EleNum[2] -o Electrode.gro";
system "genconf -f $ARGV[1] -nbox @WalNum[0] @WalNum[1] @WalNum[2] -o Wall.gro";
system "editconf -f Wall.gro -scale $WalXScale 1 1 -o Wall_Scale.gro";

`python GetGroMaxMin.py -i Electrode.gro >> EleMaxMin`;
`python GetGroMaxMin.py -i Wall_Scale.gro >> WalMaxMin`;

@EleMax=split/\s+/,`tail -2 EleMaxMin | head -1`;
@EleMin=split/\s+/,`tail -1 EleMaxMin`;
@WalMax=split/\s+/,`tail -2 WalMaxMin | head -1`;
@WalMin=split/\s+/,`tail -1 WalMaxMin`;
system "rm -f EleMaxMin WalMaxMin";

#for total box size
@XYZ[0] = $EleXBuild;
if($ARGV[7]<$EleZBuild){
  @XYZ[2] = $EleZBuild+0.5;
}
else{
  @XYZ[2] = $ARGV[7];
}

#for UP electrode
$origin_d = @EleXYZ[2]-(@EleMax[1]-@EleMin[1]);
@XYZ[1] = $ARGV[5]+(@EleMax[1]-@EleMin[1])*2+$ARGV[6]*2+($WalYBuild-@WalMin[1])+@WalMax[1];
#@XYZ[1] = ($ARGV[5]/2 + (@EleMax[1]-@EleMin[1]) + $ARGV[6] + ($WalYBuild-@WalMin[1]))*2;
$origin_c = (@EleMax[2]+@EleMin[2])/2;
@EleTransXYZ[1] = @XYZ[1]/2+$ARGV[5]/2-@EleMin[1];
@EleTransXYZ[2] = @XYZ[2]/2 - $origin_c;
system "editconf -f Electrode.gro -translate 0 @EleTransXYZ[1] @EleTransXYZ[2] -o EleU.gro";
`python GetGroMaxMin.py -i EleU.gro >> EleMaxMin`;
@EleUMax=split/\s+/,`tail -2 EleMaxMin | head -1`;
@EleUMin=split/\s+/,`tail -1 EleMaxMin`;
system "rm -f EleMaxMin";

#for up left wall
$WalLUZ=@EleUMin[2]-@WalMin[2];
$WalLUY=@EleUMax[1]+0.2-@WalMin[1];
system "editconf -f Wall_Scale.gro -translate 0 $WalLUY $WalLUZ -o WalS_LU.gro";

#for up right wall
system "editconf -f WalS_LU.gro -scale 1 1 -1 -o temp.gro";
`python GetGroMaxMin.py -i temp.gro >> LRWalMaxMin`;
@LRWalMax=split/\s+/,`tail -2 LRWalMaxMin | head -1`;
system "rm -f LRWalMaxMin";
$LRWalY = @EleUMax[2]-@LRWalMax[2];
system "editconf -f temp.gro -translate 0 0 $LRWalY -o WalS_RU.gro;rm -f temp.gro";

#for DOWN electrode
system "editconf -f EleU.gro -scale 1 -1 1 -o temp.gro";
`python GetGroMaxMin.py -i temp.gro >> EleMaxMin`;
@EleDtempMax=split/\s+/,`tail -2 EleMaxMin | head -1`;
@EleDtempMin=split/\s+/,`tail -1 EleMaxMin`;
system "rm -f EleMaxMin";
$EleDTransY=@EleUMin[1]-$ARGV[5]-@EleDtempMax[1];
system "editconf -f temp.gro -translate 0 $EleDTransY 0 -o EleD.gro;rm -f temp.gro";
`python GetGroMaxMin.py -i EleD.gro >> EleMaxMin`;
@EleDMax=split/\s+/,`tail -2 EleMaxMin | head -1`;
@EleDMin=split/\s+/,`tail -1 EleMaxMin`;
system "rm -f EleMaxMin";


#for down left wall
$WalLDY = @EleDMin[1]-0.2-@LRWalMax[1];
system "editconf -f WalS_LU.gro -translate 0 $WalLDY 0 -o WalS_LD.gro";

#for down right wall
system "editconf -f WalS_RU.gro -translate 0 $WalLDY 0 -o WalS_RD.gro";

#combine
system "python ComEleWal.py --EleU EleU.gro --EleD EleD.gro --WalLU WalS_LU.gro --WalRU WalS_RU.gro --WalLD WalS_LD.gro --WalRD WalS_RD.gro -x @XYZ[0] -y @XYZ[1] -z @XYZ[2] -o output.gro";

#delete
system "rm -f Ele*.gro Wal*.gro";

#for generate topol file
require('PreProcess.sh');

ChangeTop($ARGV[8],"Electrode.top",2,@EleNum);
ChangeTop($ARGV[9],"Wall.top",4,@WalNum);
CombineTop("output.top", "Electrode.top", "Wall.top");
system "rm -f Electrode.top Wall.top";
