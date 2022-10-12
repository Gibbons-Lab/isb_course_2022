<!-- .slide: data-background="assets/isb/data-midnight.jpg" class="dark" -->

# Predicting personalized microbiome-mediated responses


### Nick Bohmann, Gibbons Lab

<img src="assets/isb/logo.png" width="40%">

from the *ISB Microbiome Course 2022*

<br>
<div class="footer">
<a href="https://creativecommons.org/licenses/by-sa/4.0/"><i class="fa fa-bullhorn"></i>CC-BY-SA</a>
<a href="https://gibbons.isbscience.org/"><i class="fa fa-globe"></i>gibbons.isbscience.org</a>
<a href="https://github.com/gibbons-lab"><i class="fa fa-github"></i>gibbons-lab</a>
<a href="https://twitter.com/thaasophobia"><i class="fa fa-twitter"></i>@BioBohmann</a>
</div>

---

<!-- .slide: data-background="var(--primary)" class="dark" -->

Let's get the slides first (use your computer, phone, TV, fridge)

*https://gibbons-lab.github.io/isb_course_2022/micom*
---

<!-- .slide: data-background="var(--primary)" class="dark" -->

## Quick reminder :clock:

<img src="assets/materials.png" width="80%">

<br>

<a href="https://colab.research.google.com/github/gibbons-lab/isb_course_2022/blob/master/micom.ipynb"
   target="_blank">Click me to open the notebook!</a>

---

<!-- .slide: data-background="var(--primary)" class="dark" -->

## Let's set up our Notebook!

:computer: Let's switch to the notebook


---

# Functional analyses

Tries to predict what the microbiome *does* from sequencing data.

Uses gene/transcript/protein/metabolite abundances (metagenomics, metatranscriptomics, proteomics or metabolomics).

Gene content yields metabolic *capacity* or *potential*.


Note:

Today we'll look at functional analyses of the gut microbiome. That is, not just what's there, but what it does. You can somewhat use gene and metabolite abundances to get to this, but not entirely, as these measures rather give you insight into the potential of the community. Other approaches exist, as well. For instance, metagenomics can tell you what genes are present in the community, and metatranscriptomics can tell you exactly which of those genes are expressed, but these are costly and still tell you only about what reactions might take place. Proteomics can be used to assess which enzymes are present to catalyze a reaection, but not how active those enzymes are. Metabolomics can tell you what metabolites are present, but as you'll see, this doesn't always tell the whole story.

---

<!-- .slide: data-background="var(--secondary)" class="dark" -->

# Genes and metabolite abundances are cool but not what you really care about*

<div class="footnote">

hot take :fire:

</div>


Note:

Here's the thing: what we really care about in the lens of functional analysis is actually metabolic flux. This will tell us more about the behavior of the microbiome than any abundances.

---

## Fluxes

<img src="assets/fluxes.png" width="45%">
<video width="45%" autoplay loop>
  <source src="assets/fluxes.mp4" type="video/mp4">
</video>

<div class="footnote">

video courtesy of [S. Nayyak](https://twitter.com/Na_y_ak) and [J. Iwasa](https://twitter.com/janetiwasa)

</div>

Note:

Fluxes are measures of metabolic transport, into the system and through internal reactions. They can be very informative, since they tell you which pathways are the most active in a system, and what subsequent pathways are initiated. The visual here shows us why fluxes are more informative than abundances for metabolites: in this case, we have a high import flux for glucose, but the glucose very quickly is converted to pyruvate, so if we measure interal glucose levels, they might be super low. This doesn't tell the whole story, though, since glucose is obviously very important. The problem with measuring fluxes, however, is that it is laborious and quite costly. Longitudinal metabolomics can work, but takes time, effort and expense. Isotopic labeling is another option, bu t that can be even more costly. So what we need is a way to estimate fluxes, without the experimental expense.

---

<!-- .slide: data-background="var(--secondary)" class="dark" -->

# Flux Balance Analysis (FBA)

Can we infer the most likely fluxes in a biological system?


Note:

To do just that, we can use a method called flux balance analysis. This is a computational method that infers the most likely fluxes in a biological system.

---

## The flux cone

<img src="assets/flux_cone.png" width="100%">

Note:

FBA is a powerful computational tool, that allows us to infer fluxes by reducing the possible flux space to a biologically relevant one. FBA makes the critical assumption that the system being modeled, in this case the metabolism of a microbe, is in a state of constant flow, or steady state. This just means that the inflow and outflow of reactions in the systems are equal, so there is no build up of metabolites. This also means that the system can computationally run forever, and won't reach a limiting point. The steady state assumption can be represented mathematically by this first equation - reactants with negative coefficients and products with positive coeffients, balanced to zero. Additionally, we put constraints on the reactions, as seen in the second equation. This will force the production of water, thereby adding flux through the first equation. Then, through some linear algebra, we can constrain the solution space of the fluxes to a possible "flux cone". This cone represents the set of fluxes that satisfy the constraints we've imparted on the system.

---

The goal of FBA is to *reduce* the flux space to a *biologically relevant* one.

Note:

But how do we find an optimal solution, within the possible solution space?


---

## Genome-scale metabolic modeling

<img src="assets/fba.png" width="100%">

Note:

To find that solution, we can look at growth rates. We know that bacteria can only be present in the system if they can grow, otherwise they would be excreted and no longer exist in the system. So basically, we can say we want the solution in that flux cone that corresponds with maximum biomass. Within MICOM we can add information from a number of sources in order to determine our optimal solution. As we've mentioned, we can use the reactions present in the system to build a stoichiometric matrix, mathematically representing the reactions taking place and how they interact with each other, for instance precursors from one reaction required in another. We can infer this whole stoichiometric maxtrix from the genome, by mapping the enzymes the genome codes for to reactions. Also, as we've mentioned, we assume the system is at steady state. In practice, this means the bacteria is in the exponential growth phase, as the growth rate is constant and biomass production is constant. Reversibility of reactions can be determined by thermodynamics, as many reactions can only occur in one direction. We can also add upper bounds on fluxes, specifically flux of metabolites imported into the cell, based on the environment. For instance, if a metabolite is only available in the diet at a certain amount, we can set the upper bound of the import flux to that limit. Adding these constraints in, we can find the region in the flux cone that represents maximum biomass, shown here in red.

---

## Selecting biologically relevant fluxes

<img src="assets/reduction.png" width="80%">

For instance, parsimonious FBA reproduces experimental fluxes in <i>E. coli</i> [very well](https://dx.doi.org/10.1038%2Fmsb.2010.47).


Note:

The art of FBA is to then find a single solution in that solution space that is the most biologically relevant. One method that seems to work well is finding the parsimonious solution, which basically means a solution that uses the least amount of enzymes, as bacteria are super efficient and don't like to produce more enzymes than they need to grow. Other methods for finding a solution exist, such as minimizing the import fluxes, and these have also been found to be successful for predicting flux from the microbiome. So the method you use to find a solution is really dependent on the question being asked.



---

# MICOM

<img src="assets/summary.png" width="100%">

<div class="footnote">

https://micom-dev.github.io/micom

</div>


Note:

To make metabolic models of the microbiome community, we use a tool called MICOM, which extends flux balance analysis into microbial communities. To initially build the models, we need to pass in the relative abundance of bacteria in the sample. Due to sequencing efficiency differences, there may be some bias toward some bacteria over others, but the abundance from sequencing data should be more or less representative of the community. We can then specify particular diets that are representative of the food being eaten by the subject of the model. MICOM will then build a massive stoichiometric matrix that includes not only the internal reactions within each taxon, but also the exchanges between them and external reactions, which in this case is the host. It will then calculate unique growth rates for all the bacteria based on the process we've outlined previously, and then estimate all the fluxes in the system based on those growth rates, giving a most likely flux distribution. With all that data, we can then make detailed and interesting predictions about imports, exports, the inner machinations of bacterial reaction networks, co-dependcies between bacteria, and provides a testing ground for potential interventions.


---



<img src="assets/overview.png" width="120%">


Note:

Here's the typical workflow for building metabolic models. There are two interfaces in which you can use MICOM, in python or in Qiime2. Today we'll be using the python interface, as that works in Colab, but you can preform any task with either of the interfaces, either actions like building or growing models or producing visualizations. It's also easy to switch between the two interfaces between steps, as MICOM can readily read Qiime artifacts and vice versa.

---

<!-- .slide: data-background="var(--primary)" class="dark" -->

## Let's continue with our data

:computer: Let's switch to the notebook...

---

<!-- .slide: data-background="var(--primary)" class="dark" -->

## Community-wide growth is hard :cry:

In a single genome-scale model we only have a single growth rate $\mu$. In a microbial community
we have several $\mu_i$ and a community growth rate

$$
\mu_c = \sum_i a_i\cdot\mu_i
$$

Why is this so hard? Can't we just maximize the community growth rate? Well...

---

## When 2 leads to infinity...

<img src="assets/ctFBA.png" width="60%">

Note:

In practice, getting a community-wide growth rate using classic FBA doesn't work very well. While we can use FBA to calculate the maximal community growth rate, it doesn't return a unique solution, and it will include solutions in which the growth rate for some individual taxa is zero, while some really fast growers will have a high growth rate. This isn't good, since this introduces a lot of ambiguity and increases the size of the flux cone to include non-biologically relevant solutions. To overcome this, MICOM uses L2 regularization, wherein the optimal solution that minimizes the sum of the squares of the individual growth rates is found. This reduces the space of the optimal solutions to just one rather than infinity, and returns a solution of growth rates that is non-zero for all taxa present in the sample, smoothing out growth between members of the community. Thinking biologically, though, it is intuitive that for every bacteria in a community to be able to grow, optimal growth rate might not be acheieved. We can use the cooperative tradeoff to set the minimum fraction of the optimal growth rate we want to achieve, allowing all the taxa to grow in a biologically relevant manner.

---

*Cooperative Tradeoff FBA* allows us to treat metagenome-scale models with the *same*
methods as genome-scale metabolic models (pFBA, minimal media, etc).

---

## But does it work?

<img src="assets/validation.png" width="100%">

<div class="footnote">

https://doi.org/10.1128/mSystems.00606-19

</div>


Note:

The age-old question. Here, we can see the number of taxa growing in a sample community at various tradeoff values. If we do nothing (no L2 regularization), there is a super small number of taxa growing at high growth rate, and almost all the taxa effectively not growing at all. Obviously, this is not what's actually happening in the microbiome. If we apply L2 regularization at the maximal growth rate, we see that a lot more taxa are able to grow. Lowering the tradeoff value just a little, we see that almost all the taxa are able to grow, echoing what we expect to see in the microbial community. This was also validated by comparing predicted growth rates with actual growth rates. For these data, the team had metagenomes. Bacterial genomes replicate from one origin of replication, and is then replicated completely. So, you can count how many reads in the metagenomes map to different places on the genome, you can then calculate a coverage profile. Since it starts replicating at the origin, we see a decay as we get farther away. It was shown by the Segal lab that the slope of this decay can be used to estimate the growth rate. Using this method, the team could validate the growth rates predicted by MICOM. You can see in this panel on the right that without regularization, or at high tradeoff values with regularization, the predicted growth rate did not correlate with calculated growth rate. Lower the tradeoff value slightly showed a much stronger correlation with calculated growth rate, serving to validate this method.

---

Easy peasy. What's taking so long then?

<br>

Well, metagenome-scale models are slightly larger... :sweat:

---

<img src="assets/model_gephi.png" width="90%">


---

<!-- .slide: data-background="var(--primary)" class="dark" -->

## Let's return to the models we've built

:computer: Let's switch to the notebook!

---
<!-- .slide: data-background="var(--primary)" class="dark" -->

## Modeling the microbiome of underrepresented groups

---

## Underrepresented Groups

<img src="assets/map.png" width="80%">


<div class="footnote">

RJ Abdill et al., https://doi.org/10.1371/journal.pbio.3001536

Note:

Let's take a look again at the them of this year's symposium - studying the gut microbiome of underrepresented groups in microbiome research. This visual, shown yesterday, shows us just how overrepresented North American and European microbiomes are in the field of microbiome research. Today, we will build models of the microbiome of the three indigenous groups introduced in yesterday's lesson, and use these models to make predictions of the metabolic behavior of each microbiome based on the dietary context.



---

## Environmental Context

How does the environment affect the microbiome?

<img src="assets/env_effects.png" width="70%">

Note:

The environmental context to which the microbiome is exposed to is a key determinant of composition and subsequent metabolic response. In MICOM, we can partially represent the environmental context through an _in silico_ medium. Since the metabolites in the diet are direct precursors of microbially produced metabolites, it is critical that the medium passed into the growth simulation is representative of the diet typically consumed by the subject being modeled. Today, we'll investigate this by using two separate media - a matched medium, representing the diet of the indigenous groups we are modeling, and an unmatched medium, representing an average Austrian diet, not typically consumed by the individuals upon whom the models are based.

---

## Medium Construction

Media must be *componentized* (broken down into constitutent metabolites) to be used in MICOM

Many diets common in North America and Europe have been developed (average Western, vegan etc.)

Componetized dietary reconstructions of underrepreseted groups are not easily available

<img src="assets/baobab.png" width="30%">


Note:

To use a medium for a growth simulation in MICOM, the medium must be componetized, that is, described by its constituent metabolic components. This is a laborious task, as it requires determining the consitutents of various food components present in a diet, and adding them in the proper amounts. For diets of highly represented groups in microbiome research, such as North American or European diets, componetized media are publically available. However, it is difficult to find pre-constructed componetized media representative of the diet of underrepresented groups, like the three indigenous populations for whom we are building metabolic models today. For instance, baobab fruit is a common component in the Hadza diet, but it is not present in commmonly used food databases, which provide constituent components, so further investigation was required.

---

## What's in the media?
- [Hadza in Tanzania](https://www.science.org/doi/10.1126/science.aan4834) - <br> 
  Baobab fruit & seeds, honey, antelope
- [Chepang in Nepal](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6237292/) - <br>
  Nettles, mountain yam, cowpea
- [Me'Phaa in Mexico](https://pubmed.ncbi.nlm.nih.gov/33081076/) - <br>
  Corn, beans, chayote, chicken
  
---

## Medium Construction

<img src="assets/medium.png" width="80%">

Note:

To construct the matched media we will use for modeling the growth of the microbiome for these indigenous communities, we first had to determine the dietary components present in the standard diet of each community. We reviewed literature until we found a typical, representative meal for each community. Next, we mapped each component to its constituent components using a food database. Like we mentioned previously, some foods like baobab were not available on these databases. In these instances, more literature review was required to determine the composition. In the case of baobab fruit, we found an NMR-based study detailing it's metabolic composition. We then added the constitutent components to our medium at the correct relative abundances, mimicking the matched diet. Finally, each medium underwent a gap-filling process, that added a minimal set of metabolites required for the growth simulation to work properly.


---
<!-- .slide: data-background="var(--primary)" class="dark" -->

## Let's Peek at Our Results!

Note:

Let's take a peak at the results of our growth simulation, and see what insights we can glean from them. First, lets go over what the results will look like.

---

## Growth Rates

Visualize growth rates of individual taxa per sample

<img src="assets/growthrates.png" width="50%">

---

## The niche space

The context-dependent way in which a microbial taxon uses its environment

<img src="assets/niches.png" width="75%">


Note:
The niche space represents the context-dependent way in which a taxon uses it's environment - in this case, how it uses the metabolites available to it. We'll be able to map each taxon on a tSNE plot using a prebuilt MICOM tool, and see how the niche space changes per taxon between dietary contexts.


---

## Comparative metabolomics

Metabolomic exchanges are highly dependent on dietary context

<img src="assets/exchanges.png" width="50%">

Note:

We'll also take a look at the metabolomic profile of the taxa in our sample. Similar to the niche space, the metabolic activity of a taxon is dependent on the context in which it grows - here, we'll look at exports from the microbiome between the two diets we've used for modeling. Since the environmental context in these two growth simulations is so disparate, we expect to see different exchange fluxes between the two media. Since the matched medium represents the diet typically eaten by each individual, we expect this to be a closer match to the actual behavior of the microbiome. This will also be good practice at using MICOM data to build our own visualizations.

---

## Your turn

Check out how to use MICOM for analysis of a single microbial community.

<img src="assets/coding.gif" width="50%">

---

<!-- .slide: data-background="assets/isb/microbes-azure.jpg" class="dark" -->

### And we are done :clap:

<div style="display: flex; justify-content: space-around; align-items: center;">

<div>

Christian Diener <br>
Nick Bohmann <br>
Sean Gibbons <br>
Sue Ishaq <br>
Emily Wissel <br>
Alex Carr <br>
Noa Rappaport <br>
Samantha Piekos <br>
James Johnson <br>
Kathryn Stephenson

</div>

<div>

Dominic Lewis <br>
Allison Kudla <br>
Audri Hubbard <br>
Joe Myxter <br>
Thea Swanson <br>
Victoria Uhl<br>
Connor Kelly<br>
Shanna Braga<br>
ISB Facilities Team

</div></div>
<br>

# Thanks! :heart:
