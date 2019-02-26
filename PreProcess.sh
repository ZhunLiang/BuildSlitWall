#!/bin/perl

sub GetMSD{
    my @TEMP = split/\s+/,`grep $_[0] MSD_out.dat`;
    my $TEMP_num = @TEMP;
    my @Out;
    for($i=1;$i<$TEMP_num;$i=$i+1){
        $j=$i-1;
        @Out[$j] = @TEMP[$i];
    }
    return @Out;
}

#for generate topol file
system "python GetMSDpara.py";
our @MoleName = GetMSD("NAME");
our @MoleMass = GetMSD("MASS");
our @MoleNum = GetMSD("NUM");
our $TotalNum = @MoleName;
system "rm -f MSD_out.dat";

sub GetTopNum{
  my $count = 0;
  my ($temp,@temp2,@Out);
  for(my $i=0;$i<$TopTypeNum;$i+=1){
    $temp = `grep -w @Name_Out[$i] $_[0]`;
    if($temp){
      @temp2 = split/\s+/,$temp;
      @Out[$count] = @temp2[1];
      $count += 1;
    }
  }
  return @Out;
}

sub ChangeTop{
  my $temp;
  my (@temp_all,$temp_name,$temp_num);
  my ($temp_re,$temp_match);
  system "cp @_[0] @_[1]";
  for(my $i=0;$i<$TotalNum;$i+=1){
    $temp = `grep -w @MoleName[$i] @_[1]`;
    if($temp){
      @temp_all = split/\s+/,$temp;
      $temp_name = @temp_all[0];
      $temp_num = @temp_all[1]*@_[3]*@_[4]*@_[5]*@_[2];
      $temp_match = "$temp_name\\s\\+\\([0-9]\\+\\)";
      $temp_re = "$temp_name\\t$temp_num";
      #print "$temp_match\n$temp_re\n";
      system "sed -i 's/$temp_match/$temp_re/g' @_[1]";                                                                                                                
    }                                                                                                                                                                  
  }                                                                                                                                                                    
}

sub CombineTop{
  my $Num = @_;
  my $i,$j;
  system "cp @_[1] $_[0]";
  for($i=2;$i<$Num;$i+=1){
    for($j=0;$j<$TotalNum;$j+=1){
       `grep -w @MoleName[$j] @_[$i] >> @_[0]`;
    }
  }
}

1;

