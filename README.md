# Radix-4 Modified Booth Multiplier (MBM)
<!-- element with id at top of page -->
<div id="back-to-top"></div>

## Abstract

Adders and multipliers are fundamental components of many circuits. Specifically, multiplication operations are the fundamental computational function in applications such as digital signal processing and machine learning, where multiplier performance plays a crucial role in the overall system behavior.  

The radix-4 modified Booth multiplier (MBM), reduces the number of partial products by 50%. This increases speed, reduces power consumption and saves space on the multiplier layout. Furthermore, the use of Carry Save adders, arranged in Wallace tree structure, for the accumulation of the partial products and a CLA adder, used as the last stage of the adder tree for the final addition, ensures further improvements in the use of logical resources (greater savings in occupied area) and performance in terms of speed and power compared to conventional multipliers.  

This repository contains the VHDL code for a multiplier using the Booth radix-4 algorithm, taking as inputs two signed numbers, X<sub>N-bit, multiplicand</sub> &times; Y<sub>8-bit or 16-bit, multiplier</sub>, in 2's complement notation and returning as output a signed number, Z<sub>(N+8 or 16)-bit</sub>, in 2's complement notation. The Booth radix-4 algorithm computes the two inputs into 8/2 or 16/2 partial products. These partial products are passed through an Wallace tree adder structure, which returns two final partial products. These two partial products are then subjected to a further carry-free addition (CLA adder) to produce the final result.  

> [!NOTE]
> The repository includes the testbench used for functional verification of the proposed architecture using the Xilinx Vivado Design Suite simulation environment. The simulation results confirm the correctness of the multiplication operations for all permitted input combinations, i.e., the N-bit signed multiplicand and the 8-bit or 16-bit signed multiplier.

## Theory

The multiplication operation typically involves three main processes:
1. **Generation of partial products:** Performing the multiplication operation between the "multiplicand" and the "multiplier" produces intermediate data called "partial products."
2. **Compression or accumulation of partial products:** using a specific tree structure to condense multiple generated partial products into two.
3. **Summation:** Using an adder to add the two partial products obtained from compression, the final product is obtained.  

Booth radix-4 encoding algorithm is used to generate partial products. The Wallace tree structure allows for the compression of the partial products, and a CLA adder adds the two partial products output from the tree structure to obtain the final product.  
The principles of Booth radix-4 algorithm and the Wallace tree scheme are briefly introduced below.

### Radix-4 Booth Encoder

## Theorical Architectural Overview

The structural block diagram is as follows:
1. **Booth Encoder and Decoder:** Coding of multiplier triples and generation of partial products.
2. **RCA Module:** Pre-calculation of the possible values ​​of the partial products as a function of the encoding using the Radix-4 Booth algorithm.
3. **Adder Tree (Wallace tree + CLA adder):** Using a Wallace tree structure, the partial products are added and compressed into two final partial products, which are then used in the final addition via a CLA adder to obtain the final product result.
4. **Pipeline Registers:** Mainly used to minimize power dissipation attributed to spurious signal switching (i.e., glitches).
    
  
    
  
  
  
  
  
  
  
<!-- The link you click to go back to top -->
<div align="right">
  &#8673; <a href="#back-to-top" title="Table of Contents">Back to Top</a>
</div>
