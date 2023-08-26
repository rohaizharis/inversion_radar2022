# inversion_radar2022
## Code for study of how radar metrics can inform basal shear stress inversions

### High-High/Low-Low Plots
High-High/Low-Low plots for absolute deviation in mean basal shear stress can be plotted using
the following files (F_supp_pcolor_absdev_ALL_HH_v1, F_supp_pcolor_absdev_ALL_LL_v1)

### Coordinates for Regimes of Significant Deviation
This script generates the coordinates for regimes of significant deviation in mean basal 
shear stress (as plotted in Figure 3)

### KS Testing
There are two versions of code that perform the two-sample Kolmogorov-Smirnov
 (KS test) for the 9 models. One version uses a random sample of the same size as the sub-sampled
data on the basis of radar metrics (D_supp_KS_HH, D_supp_KS_LL). The other version uses the complete 
inversion data set (D_supp_KS_HH_norandomsam, D_supp_KS_LL_norandomsam). These files save the KS test 
results into a .mat file which can be loaded into the plotting code.

### KS Test Plotting
The .mat files generated from the KS testing code can be passed into the plotting files to avoid
running the KS testing code every time a plot needs to be generated (F_supp_KSHH_plot, F_supp_KSLL_plot)

