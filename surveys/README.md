# Survey Responses

## Running the Indicator

The indicator is run by installing the package `delphiSurvey` and running the script
"run.R". To install the pacakge, run the following code from this directory:

```
R CMD build delphiSurveys
R CMD INSTALL delphiSurvey_1.0.tar.gz
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

## Building and testing the code

The documentation for the package is written using the **roxygen2** packaage. To
(re)-create this documentation for the package, run the following from the package
directory:

```
R -e 'roxygen2::roxygenise("delphiSurvey")'
```

Testing the package is done with the build-in R package checks (which include both
static and dynamic checks), as well as unit tests written with **testthat**. To run all
of these, use the following from within this directory:

```
R CMD build delphiSurvey
R CMD CHECK delphiSurvey_1.0.tar.gz
```

None of the tests should fail and notes and warnings should be manually checked for issues.
To see the code coverage from the tests and example run the following:

```
Rscript -e 'covr::package_coverage("delphiSurvey")'
```

There should be good coverage of all the core functions in the package.

## Outline of the Indicator

The symptom and behavior surveys are one of our most complex data pipelines. At a high level,
the pipeline must do the following:

1. Download the latest survey from Qualtrics and place it in a CSV. This is done
   by a Python script using the Qualtrics API (not yet in this repository).
2. Read the survey data. This package extracts a unique token from each survey
   response and saves these to an output file; the automation script driving
   this package uses SFTP to send this file to the appropriate survey partner.
3. Download the latest survey weights computed by our survey partner for the tokens we
   provide. Our survey partner usually provides survey weights within one day, so our
   pipeline can produce weighted estimates a day after unweighted estimates. The
   download is managed by the same automation script, not this package.
4. Aggregate the data and produce survey estimates.
5. Write the survey estimates to covidalert CSV files: one per day per signal
   type and geographic region type. (For example, there will be one CSV
   containing every unweighted unsmoothed county estimate for one signal on
   2020-05-10.)
6. Validate these estimates against basic sanity checks. (Not yet implemented in
   this pipeline!)
7. Push the CSV files to the API server. Also done by the automation script, not
   by this package.


Mathematical details of how the survey estimates are calculated are given in the
signal descriptions PDF in the `covid-19` repository. This pipeline currently
calculates two basic types of survey estimates:

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
