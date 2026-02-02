# Modified Booth Multiplier or MBM (Radix-4 Booth Algorithm)


## Abstract

Adders and multipliers are fundamental components of many circuits. Specifically, multiplication operations are the fundamental computational function in applications such as digital signal processing and machine learning, where multiplier performance plays a crucial role in the overall system behavior.  

The modified Booth multiplier or MBM (radix-4 multiplier), reduces the number of partial products by 50%. This increases speed, reduces power consumption and saves space on the multiplier layout. Furthermore, the use of Carry Save adders, arranged in Wallace tree structure, for the accumulation of the partial products and a CLA adder, used as the last stage of the Wallace tree for the final addition, ensures further improvements in the use of logical resources (greater savings in occupied area) and performance in terms of speed and power compared to conventional multipliers.  

This repository contains the VHDL code for a multiplier using the Booth radix-4 algorithm, taking as inputs two signed numbers in 2's complement notation (N-bit multiplicand × 8-bit multiplier) and returning as output a signed (N+M)-bit number in 2's complement notation. The Booth radix-4 algorithm computes the two inputs into M/2 partial products. These partial products are passed through an Wallace tree adder structure, which returns two final partial products. These two partial products are then subjected to a further carry-free addition (CLA adder) to produce the final result.  
The structural block diagram is as follows:
