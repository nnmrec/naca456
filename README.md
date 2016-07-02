Quickly, to compile naca456 use:

    gfortran naca456.f90 -o naca456

From the same directory as the naca456 compiled program, you may wish
to create a symbolic link, so naca456 can be called easily
from any directory:

    ln -s naca456 /home/$USER/bin/naca456

Then to run the program, specify the input file as a command line argument:
    
    naca456 samples/4415_danny.nml

The program should run and produce 3 output files:
*.dbg 
*.out
*.gnu

There is a helper Matlab script that reads the relevant
part of the naca456 output files, and can be used to create
input files for various other programs, such as:
xfoil
mses
openfoam
starccm+

These programs above produce the Lift and Drag polars from the airfoil coordinates

Additionally, can write input files for:
harp_opt
co-blade

