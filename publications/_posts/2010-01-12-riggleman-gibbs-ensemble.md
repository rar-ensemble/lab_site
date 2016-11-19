---
layout: publication
title: Field-theoretic simulations in the Gibbs ensemble
image: /images/publications/riggleman-gibbs-ensemble.png
authors:
 - Robert A. Riggleman
 - Glenn H. Fredrickson
authors-short:
 - R. A. Riggleman
 - G. H. Fredrickson
year: 2010
journal: "Journal of Chemical Physics"
journal-short:  "J Chem Phys"
ref: "<b>132</b>: 024104"
doi: 10.1063/1.3292004
---

Calculating phase diagrams and measuring the properties of multiple phases in equilibrium is one of the most common applications of field-theoretic simulations. Such a simulation often attempts to simulate two phases in equilibrium with each other in the same simulation box. This is a computationally demanding approach because it is necessary to perform a large enough simulation so that the interface between the two phases does not affect the estimate of the bulk properties of the phases of interest. In this paper, we describe an efficient method for performing field-theoretic simulations in the Gibbs ensemble, a familiar construct in particle-based simulations where two phases in equilibrium with each other are simulated in separate simulation boxes. Chemical and mechanical equilibrium is maintained by allowing the simulation boxes to swap both chemical species and volume. By fixing the total number of each chemical species and the total volume, the Gibbs ensemble allows for the efficient simulation of two bulk phases at equilibrium in the canonical ensemble. After providing the theoretical framework for field-theoretic simulations in the Gibbs ensemble, we demonstrate the method on two two-dimensional modelpolymer test systems in both the mean-field limit (self-consistent field theory) and in the fluctuating field theory.
