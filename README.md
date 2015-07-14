[title]: - "GROMACS"
[TOC]
 
## Overview

[GROMACS](http://www.gromacs.org/) is a  molecular dynamics simulation program.  In this tutorial, we learn how to run 
GROMACS simulations on the OSG. Our example system is a 1CTA protein dimer in implicit water.  
![fig 1](https://raw.githubusercontent.com/OSGConnect/tutorial-gromacs/master/Figs/1cta_dimer_blackBG.png)


## GROMACS tutorial files

It is easiest to start with the `tutorial` command. In the command prompt, type
	 $ tutorial gromacs # Copies input and script files to the directory tutorial-gromacs.
 
This will create a directory `tutorial-gromacs`. Inside the directory, you will see the following files

    1cta_nvt.tpr          # GROMACS binary input file
    gromacs_job.sh        # Job execution script file
    gromacs_job.submit    # Condor job submission script file

Here, `gromacs_job.submit` is the job submission file, `gromacs_job.sh` is the job execution shell script and `1cta_nvt.tpr` is 
the [GROMACS input binary file](http://manual.gromacs.org/current/online/tpr.html). To find out how to prepare the GROMACS input file from the input strucure, check the [GROMACS tutorials](http://www.gromacs.org/Documentation/Tutorials). 

## Job execution and submission files

Let us take a look at `gromacs_job.submit` file: 

    Universe = vanilla                                             # One OSG Connect vanilla, the prefered job universe is "vanilla"
    Executable = gromacs_job.sh                                    # Job execution file which is transfered to worker machine

    transfer_input_files = 1cta_nvt.tpr                            # list of file(s) need be transfered to the remote worker machine
    should_transfer_files=Yes                                      # Say yes, if you want to transfer the output files 
    when_to_transfer_output = ON_EXIT                              # We transfer the files after finishing the calculations

    request_memory = 2GB⋅                                          # Request 2GB memory (no harm upto 2GB)
    request_cpus = 1                                               # Number of requested cores

    output        = job.output                                     # stardard output
    error         = job.error                                      # stardard error
    log           = job.log                                        # stardard log contains information about job execution

    requirements = (HAS_CVMFS_oasis_opensciencegrid_org =?= TRUE)  # Check if the worker machine has CVMFS 
    Queue 1                                                        # The above job descriptions are send to the queue once


As mentioned in the job description file, the executable is `gromacs_job.sh` which has the following information 

    #!/bin/bash                                                         # this sets up the shell environement (always inlclude this line)
    module load gromacs/5.0.5                                           # loads the gromacs module
    gmx mdrun -ntmpi 1 -ntomp 1 -nt 1 -deffnm 1cta_nvt.tpr -nsteps 500  # Calling gmx (GROMACS) to run mdrun on single CPU for the input file 1cta_nvt.tpr


The input options ntmpi, ntomp and nt are related to number of mpi threads, number of openMP threads and total number of threads, respectively. The option [deffnm](http://manual.gromacs.org/programs/gmx-mdrun.html) produces output files with an extention of input file `1cta_nvt.tpr`. The option `nsteps` controls the number of MD steps. Here, we choose small number of steps for simplicity, feel free to experiment with this number as you like. 


## Running the simulation

We submit the job using `condor_submit` command as follows

	$ condor_submit gromacs_job.submit //Submit the condor job script "gromacs_job.submit"

Now you have submitted the GROMACS simulation of 1CTA dimer in implicit solvent on the OSG.  The present job should be finished quickly (less than an hour). You can check the status of the submitted job by using the `condor_q` command as follows

	$ condor_q username  # The status of the job is printed on the screen. Here, username is your login name.
After the simulation is completed, you will see the output files (including gro, cpt and trr files) from GROMACS in your work directory.


## Getting Help
For assistance or questions, please email the OSG User Support team  at [user-support@opensciencegrid.org](mailto:user-support@opensciencegrid.org) or visit the [help desk and community forums](http://support.opensciencegrid.org).
