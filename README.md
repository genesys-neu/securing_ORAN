# securing_ORAN
Tools used to investigate the cost of securing ORAN Open Interfaces. If you use the code or datasets, please cite
> J. Groen, S. D'Oro, U. Demir, L. Bonati, D. Villa, M. Polese, T. Melodia, and K. R. Chowdhury, "Securing O-RAN Open Interfaces," IEEE Transactions on Mobile Computing, accepted, April 2024."
> <a href="https://genesys-lab.org/papers/Securing-ORAN.pdf" target="_blank">[pdf]</a> 

## Profiling Tools
Use the following tools to evaluate the impact of a security protocol

To determine the added delay due to packet size use ```size_test.sh```.

To determine the throughput and CPU utilization use ```throughput_test.sh```.

To determine the delay due to traffic volume use ```bw_delay.sh```.

## Interface specific Tools
The following tools are for specific interfaces and/or security protocols.

### E2 Tools
Use ```start_ipsec.sh``` to build the IPsec tunnel on the E2 interface in Colosseum. 

For example, ```sh start_ipsec.sh genesys-gNB genesys-RIC```.

Starting files, ```ipsec.conf``` and ```ipsec.secrets``` are provided.

### Open Fronthaul Tools
You can use ```macsec.txt``` as a guide to enabling MACsec over the Open Fronthaul.

To replay OpenFronthaul traffic in Colosseum, use ```OFH_setup.sh```. You must specify a .csv file containing the trace to be played. Some sample traces are provided.

eg: ```sh OFH_setup.sh genesys-DU genesys-RU file_name```

To replay OpenFronthaul traffic in a point to point local environment, use ```OFH_MACsec.sh```.

eg: ```sh OFH_MACsec.sh file_name```

Both of these script uses ```OFH_tgen.py```, which will need to be modified depending on if the trace used has layer 2 switching only, or layer 3 routing. 

