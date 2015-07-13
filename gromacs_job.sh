#!/bin/bash

module load gromacs/5.0.5
gmx mdrun -ntmpi 1 -ntomp 1 -nt 1 -deffnm 1cta_nvt.tpr -nsteps 500

