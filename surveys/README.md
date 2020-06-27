# Survey Responses

## Running the Indicator

The indicator is run by installing the package `delphiSurvey` and running the script
"run.R". To install the pacakge, run the following code from this directory:

```
R CMD build delphiSurveys
R CMD INSTALL delphiSurveys_1.0.1.tar.gz
```

If you see problems installing the built package, you might need to install some additional dependencies.
To do this, run the following code from this directory:

```
Rscript dep.R
```

All of the user-changable parameters are stored in `params.json`. A template is
included as `params.json.template`.

To execute the module and produce the output datasets (by default, in
`receiving`), run the following:

```
Rscript run.R
```

## Testing the code

The package dependencies and documentation are managed using the **roxygen2** package. To
re-build the documentation and dependency list, run the following from the `surveys`
directory:

```
R -e 'roxygen2::roxygenise("delphiSurveys")'
```

Testing the package is done with **testthat**. To run all tests,

1. Set your R working directory to `delphiSurveys/tests/testthat`.
2. Run `testthat::test_dir('.')`

*Note for R pros:* Package tests using `R CMD check` currently do not pass, as
they are not compatible with the gold output checks included for the hackathon.

## Outline of the Indicator

The symptom and behavior surveys are one of our most complex data pipelines. At
a high level, the pipeline must do the following each morning:

1. Obtain the latest survey response file from Qualtrics. For the hackathon,
   we've supplied this file for you; in the production version, this is done by
   a Python script using the Qualtrics API.
2. Read the survey data. This package extracts a unique token from each survey
   response and saves these to an output file. For the hackathon, we can discard
   this file; in the production version, the automation script driving this
   package uses SFTP to send this file to the appropriate survey partner for
   processing.
3. Obtain the latest survey weights computed by our survey partner for the
   tokens we provide. For the hackathon, we have included all weights files in
   the synthetic data; in the production version, the automation script driving
   this package would uses SFTP to download the weights file.
   
   Our survey partner usually provides survey weights within one day, so our
   pipeline can produce weighted estimates a day after unweighted estimates.
4. Aggregate the data and produce survey estimates.
5. Write the survey estimates to COVIDcast CSV files: one per day per signal
   type and geographic region type. (For example, there will be one CSV
   containing every unweighted unsmoothed county estimate for one signal on
   2020-05-10.)
6. Validate these estimates against basic sanity checks. (Not yet implemented in
   this pipeline!)

Hackathon addition: Mathematical details of how the survey estimates are
calculated are given in the signal descriptions PDF in the `data` directory at
the root of this repository. This pipeline currently calculates two basic types
of survey estimates:

1. Estimates of the fraction of individuals with COVID-like or influenza-like
   illness. The survey includes questions about how many people in your
   household have specific symptoms; we use the fractions within households to
   estimate a population rate of symptoms. This estimation is handled by
   `count.R` in the `delphiSurveys` package.
2. Estimates of the fraction of people who know someone in their local community
   with symptoms. Here we do not distinguish between COVID-like and
   influenza-like symptoms. We produce separate estimates including or excluding
   within-household symptoms, and do not use the number of people the respondent
   knows, only whether or not they know someone with symptoms. This estimation
   is handled by `binary.R` in the `delphiSurveys` package.
