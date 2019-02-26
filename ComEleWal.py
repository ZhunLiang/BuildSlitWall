from optparse import OptionParser
import numpy as np

parser = OptionParser()
parser.add_option("--EleU", dest = "EleU", default = "EleU.gro", help = "up electrode gro file")
parser.add_option("--EleD", dest = "EleD", default = "EleD.gro", help = "down electrode gro file")
parser.add_option("--WalLU", dest = "WalLU", default = "WalS_LU.gro", help = "left up wall gro file")
parser.add_option("--WalRU", dest = "WalRU", default = "WalS_RU.gro", help = "right up wall gro file")
parser.add_option("--WalLD", dest = "WalLD", default = "WalS_LD.gro", help = "left down wall gro file")
parser.add_option("--WalRD", dest = "WalRD", default = "WalS_RD.gro", help = "right down wall gro file")
parser.add_option("-x",dest = "x", default = "3", help = "output gro box size x")
parser.add_option("-y",dest = "y", default = "4", help = "output gro box size y")
parser.add_option("-z",dest = "z", default = "20", help = "output gro box size z")
parser.add_option("-o", dest = "output_gro", default = "total.gro", help = "output gro file name, default total.gro")
(options, args) = parser.parse_args()
EleU = options.EleU
EleD = options.EleD
WalLU = options.WalLU
WalRU = options.WalRU
WalLD = options.WalLD
WalRD = options.WalRD
x = options.x
y = options.y
z = options.z
output_gro = options.output_gro

EleU_file = open(EleU,'r')
EleD_file = open(EleD,'r')
WalLU_file = open(WalLU,'r')
WalRU_file = open(WalRU,'r')
WalLD_file = open(WalLD,'r')
WalRD_file = open(WalRD,'r')
output_file = open(output_gro,"w")
EleU_lines = EleU_file.readlines()
EleD_lines = EleD_file.readlines()
WalLU_lines = WalLU_file.readlines()
WalRU_lines = WalRU_file.readlines()
WalLD_lines = WalLD_file.readlines()
WalRD_lines = WalRD_file.readlines()

EleNum=int(EleU_lines[1])
WalNum=int(WalLU_lines[1])

output_file.write("ele_wall gro\n")
output_file.write(str(EleNum*2+WalNum*4)+"\n")
output_file.writelines(EleU_lines[2:-1])
output_file.writelines(EleD_lines[2:-1])
output_file.writelines(WalLU_lines[2:-1])
output_file.writelines(WalRU_lines[2:-1])
output_file.writelines(WalLD_lines[2:-1])
output_file.writelines(WalRD_lines[2:-1])

output_file.write("    "+str(x)+'    '+str(y)+'    '+str(z)+"\n")
output_file.write("\n")

EleU_file.close()
EleD_file.close()
WalLU_file.close()
WalRU_file.close()
WalLD_file.close()
WalRD_file.close()
output_file.close()




