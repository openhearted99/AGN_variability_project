#!/bin/bash


# initialise
#export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ncaplar/.conda/envs/cuda_env/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ncaplar/CodeGpu/software/lib


#dirpath="/tigress/ncaplar/GpuData" 

echo $LD_LIBRARY_PATH

# GPU
gpu_name=0

#general inputs
name="delta2_bpl_in_gets_3"     # What resulting files will be named
repetitions=20             # How many light curves will be generated

#codes inputs
LClength_in=24             # 2^(LClength_in) points will be used for each lightcurve
tbin_in=8640000.           # Resolution of light curve (dt), in seconds
#-------------
A_in=30                    # Dummy variable used for normalization
v_bend_in=2.e-10           # Frequency of the bend of the power-law
a_low_in=1.0               # Low frequency slope
a_high_in=2.0              # High frequency slope
c_in=0.0                   # Offset from zero
#-------------
# Eddington ratio 
# distribution (PDF)
num_it_in=200              # Number of iterative steps
LowerLimit_in=0.00001      # Lower limit of the PDF for the random draw algorithm.
                           # Must be < LowerLimit_acc_in if PDF_in=1, and = LowerLimit_acc_in
                           # for log-normal case
UpperLimit_in=10.          # Upper limit of the PDF for the random draw algorithm.
                           # Must be > UpperLimit_acc_in if PDF_in=1, and = UpperLimit_acc_in
LowerLimit_acc_in=0.001    #
UpperLimit_acc_in=3.       #
#-------------
# LOG-NORMAL
lambda_s_LN_in=0.000562341 # Mean of the log-normal distribution. Linear in our case, check docs for details
sigma_LN_in=0.64           # Width of the log-normal
#-------------
# BROKEN POWER-LAW
delta1_BPL_in=0.47         # Low-Eddington ratio slope
delta2_BPL_in=3.00         # High-Eddington ratio slope
lambda_s_BPL_in=0.01445    # Break Eddington ratio, where the power law bends
#-------------
PDF_in=1                   # Determines whether you use a broken power law or log-normal description of the PDF.
                           # 1=broken power-law, 2=log-normal
#-------------
len_block_rd_in=1024       # Unclear what this does. Check docs for an explanation

for rep in `seq 1 $repetitions`; do

# Create unique results directory for each run
name_file_in=results_${name}_${rep}.bin
echo "results file: $name_file_in"
# Create unique profile file each run
#profFile=prof_${name}_${rep}.nvprof


CUDA_VISIBLE_DEVICES=$gpu_name /home/ncaplar/CodeGpu/main_cuFFT_v15_neven --LClength $LClength_in --RandomSeed $rep --tbin $tbin_in --A $A_in --v_bend $v_bend_in --a_low $a_low_in --a_high $a_high_in --c $c_in --num_it $num_it_in --LowerLimit $LowerLimit_in --UpperLimit $UpperLimit_in --LowerLimit_acc $LowerLimit_acc_in --UpperLimit_acc $UpperLimit_acc_in --lambda_s_LN $lambda_s_LN_in --sigma_LN $sigma_LN_in --delta1_BPL $delta1_BPL_in --delta2_BPL $delta2_BPL_in --lambda_s_BPL $lambda_s_BPL_in --pdf $PDF_in --len_block_rd $len_block_rd_in --output $name_file_in
done
