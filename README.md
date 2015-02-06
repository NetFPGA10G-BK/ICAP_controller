![bk_logo](https://cloud.githubusercontent.com/assets/10867852/6072312/d48e3b14-add2-11e4-842c-dd1a592a05c5.png)
# ICAP_controller
This repository provides the free & open-source FPGA HDL interface to the Internal Configuration Access Port (ICAP) for Virtex-5. It has several write FIFOs, which will store the configuration locally.  Processor can read the configuration from the ICAP, which will be stored in side the read FIFO.
## Motivation
  * Fast reconfiguration
  * Allows the user design to control device reconfiguration at run-time
  * Self-reconfiguration 
  * No need external support for partial reconfiguration
##Include:
+ Interface: AXI-Stream
+ Asynchronous fifo which 2 different clocks.
+ ICAP_statemachine: which control the signal to hard core ICAP.

We are really thank to Kizheppatt Vipin and Suhaib A. Fahmy for their paper: "A high speed open source controller for FPGA Partial reconfiguration".
That really helps us a lots.

** We are on the testing state so we are not sure if it will run right :(
